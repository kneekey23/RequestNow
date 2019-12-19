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
                        Image("1.music.fill")
                        Text("Requests")
                    }
                }
                .tag(0)
            MessagesView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("2.history")
                        Text("Messages")
                    }
                }
                .tag(1)
            SettingsView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("3.settings")
                        Text("Settings")
                    }
                }
                .tag(2)
        }.edgesIgnoringSafeArea(.top)
    }
}

extension UITabBarController {
    override open func viewDidLoad() {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = ColorCodes.lighterShadeOfDarkGrey.uicolor()
    standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Segoe UI", size: 10)!]
        standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: ColorCodes.teal.uicolor(), .font: UIFont(name: "Segoe UI", size: 10)!]
        standardAppearance.selectionIndicatorTintColor = ColorCodes.teal.uicolor()
        standardAppearance.shadowColor = .white
        standardAppearance.stackedItemPositioning = .fill
        
        tabBar.standardAppearance = standardAppearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
