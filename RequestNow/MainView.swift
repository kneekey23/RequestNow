//
//  ContentView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            RequestsView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Requests")
                    }
                }
                .tag(0)
            MessagesView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Messages")
                    }
                }
                .tag(1)
            SettingsView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
