//
//  Pusher.swift
//  Customer
//
//  Created by Andrew Jiang on 11/6/20.
//


import PusherSwift

final class PusherObj: PusherDelegate {
    static var shared = PusherObj()
    
    var pusher: Pusher!
    var channel: PusherChannel!
    var currView: Int = 0
    var reload: (() -> ())? = nil
    // Did the user attempt to connect (by logging in)
    var didConnect = false
    // Is there a sustained connection
    var isPusherConnected = false
    
    class AuthRequestBuilder: AuthRequestBuilderProtocol {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        func requestFor(socketID: String, channelName: String) -> URLRequest? {
            #if CUSTOMER
            let backendURL = "\(BACKEND_URL)/api/customer/pusher_auth/"
            #elseif SERVER
            let backendURL = "\(BACKEND_URL)/api/server/pusher_auth/"
            #endif
            var request = URLRequest(url: URL(string: backendURL)!)
            request.httpMethod = "POST"
            request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
            request.setValue( "Token \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
    func createPusher() {
        let clientOptions = PusherClientOptions(
            authMethod: .authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
            host: .cluster(PUSHER_CLUSTER)
        )
        pusher = Pusher(key: PUSHER_KEY, options: clientOptions)
        pusher.connection.delegate = self
    }
    
    func connect() {
        if !didConnect {
            pusher.connect()
            didConnect = true
        }
    }
    
    func disconenct() {
        if didConnect {
            pusher.disconnect()
            didConnect = false
        }
    }
    
    // Checks if network is available and forces Pusher reconnection
    func overrideReconnectGap() {
        if didConnect && !isPusherConnected {
            self.disconenct()
            self.connect()
        }
    }
    
    func subscribe(_ channelName: String) {
        channel = pusher.subscribe(channelName)
    }
    
    func unsubscribe() {
        if let channel = self.channel {
            pusher.unsubscribe(channel.name)
        }
    }
    
    func channelBind(eventName: String, callback: @escaping (Any?) -> Void) -> String? {
        return channel?.bind(eventName: eventName, callback: callback)
    }
    
    func channelBind(eventName: String, eventCallback: @escaping (PusherEvent) -> Void) -> String? {
        return channel?.bind(eventName: eventName, eventCallback: eventCallback)
    }
    
    func channelUnbind(eventName: String, callbackId: String) {
        channel?.unbind(eventName: eventName, callbackId: callbackId)
    }
    
    func channelUnbindAll() {
        channel?.unbindAll()
    }
    
    func channelUnbindAll(forEventName: String) {
        channel?.unbindAll(forEventName: forEventName)
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        // reload view data in case of missed messages after reconnection
        if old == .connecting && new == .connected {
            if let reload = reload {
                reload()
            }
        }
        switch(new) {
        case .connected:
            isPusherConnected = true
        default:
            isPusherConnected = false
        }
    }
}
