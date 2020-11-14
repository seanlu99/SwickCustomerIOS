//
//  ContentView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import SwiftyJSON
import PusherSwift
import Reachability
import ExytePopupView

struct ContentView: View {
    // Initial
    @EnvironmentObject var user: UserData
    // Properties
    @State var hasRestaurant = true
    @State var showNetworkError = false
    let reachability = try! Reachability()
    
    init() {
        // Set navigation bar font globally
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 30)!
            ]
        UINavigationBar.appearance()
            .titleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 18)!
            ]
    }
    
    func login() {
        // If no token
        if UserDefaults.standard.string(forKey: "token") == nil {
            user.screenState = .loginView
        }
        else {
            API.login() { json in
                if json["status"] == "success" {
                    user.screenState = .tabView
                    connectToPusher(json["id"].int, json["restaurant_id"].int)
                    // If name not set
                    if !(json["name_set"].bool ?? true) {
                        user.showSetNameSheet = true
                    }
                }
                
                // If token invalid, remove token
                else {
                    UserDefaults.standard.removeObject(forKey: "token")
                    user.screenState = .loginView
                }
            }
        }
    }
    
    func connectToPusher(_ uid: Int?, _ restaurantId: Int? = nil) {
        if let id = uid {
            user.id = id
            PusherObj.shared.createPusher()
            
            #if CUSTOMER
            let channelName = "private-customer-\(user.id!)"
            PusherObj.shared.subscribe(channelName)
            
            #else
            if let restaurantId = restaurantId {
                let channelName = "private-restaurant-\(restaurantId)"
                PusherObj.shared.subscribe(channelName)
            }
            else {
                hasRestaurant = false
                let channelName = "private-server-\(user.id!)"
                PusherObj.shared.subscribe(channelName)
                PusherObj.shared.channelBind(eventName: "restaurant-added") { (event: PusherEvent) -> Void in
                    if let eventData = event.data {
                        let json = JSON(eventData.data(using: .utf8) ?? "")
                        if let restaurantId = json["restaurant_id"].int {
                            let restaurantChannel = "private-restaurant-\(restaurantId)"
                            hasRestaurant = true
                            PusherObj.shared.unsubscribe()
                            PusherObj.shared.subscribe(restaurantChannel)
                        }
                    }
                }
            }
            #endif
            PusherObj.shared.connect()
        }
    }
    
    func listenNetworkChanges() {
        reachability.whenReachable = { reachability in
            // If network was previously unavailable, force reconnect to Pusher
            if !API.isNetworkAvailable {
                PusherObj.shared.overrideReconnectGap()
            }
            API.isNetworkAvailable = true
            showNetworkError = false
        }
        reachability.whenUnreachable = { _ in
            API.isNetworkAvailable = false
            showNetworkError = true
        }
        
        do {
            try reachability.startNotifier()
        }
        catch {
            print("Unable to start notifier")
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                if user.screenState == .loadingScreen {
                    GradientView()
                }
                else if user.screenState == .loginView {
                    LoginView(login: login)
                        .accentColor(.white)
                        .onAppear {
                            hasRestaurant = true
                        }
                }
                else {
                    RootTabView(hasRestaurant: $hasRestaurant)
                        // Show undismissable set name sheet if name not set
                        .sheet(isPresented: $user.showSetNameSheet) {
                            SetNameView()
                                .allowAutoDismiss { false }
                        }
                }
            }
        }
        .onAppear {
            listenNetworkChanges()
            login()
        }
        .popup(
            isPresented: $showNetworkError,
            type: .floater(verticalPadding: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40),
            position: .top,
            closeOnTap: false,
            closeOnTapOutside: false
        ) {
            HStack {
                Text("No internet connection")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(height: 40)
            .background(Color(.systemGray).opacity(0.75))
            .cornerRadius(15.0)
            // Work around for "no internet" popup showing after post-tip popup view bug
            .if(!showNetworkError) {
                $0.hidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
