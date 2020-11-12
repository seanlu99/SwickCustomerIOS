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
    var reload: (() -> ())?
    var events:[( event: String, callbackId: String?)] = []
    var didConnect = false
    
    class AuthRequestBuilder: AuthRequestBuilderProtocol {
        var token: String
        
        init(_ token: String) {
            self.token = token
        }
        
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
    
    func createPusher(_ token: String) {
        let clientOptions = PusherClientOptions(authMethod: .authRequestBuilder(authRequestBuilder: AuthRequestBuilder(token)),
                                                host: .cluster(PUSHER_CLUSTER))
        pusher = Pusher(key: PUSHER_KEY, options: clientOptions)
        pusher.connection.delegate = self
    }

    func connect() {
        if !didConnect {
            pusher.connect()
        }
    }
    
    func disconenct() {
        pusher.disconnect()
        didConnect = false
    }
    
    func subscribe(_ channelName: String) {
        channel = pusher.subscribe(channelName)
    }
    
    func unsubscribe() {
        if let channel = self.channel {
            pusher.unsubscribe(channel.name)
        }
    }
    
    func channelBind(eventName: String, callback: @escaping (Any?) -> Void) {
        events.append((eventName, channel?.bind(eventName: eventName, callback: callback)))
    }
    
    func channelBind(eventName: String, eventCallback: @escaping (PusherEvent) -> Void) {
        events.append((eventName, channel?.bind(eventName: eventName, eventCallback: eventCallback)))
    }
    
    func unbindRecentEvents(_ numEvents: Int) {
        for _ in 1...numEvents {
            let event = events.removeFirst()
            guard let callbackId = event.1 else { continue }
            channel?.unbind(eventName: event.0, callbackId: callbackId)
        }
        
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
        if old == .reconnecting && new == .connected {
            if let reload = reload {
                reload()
            }
        }
    }
}
