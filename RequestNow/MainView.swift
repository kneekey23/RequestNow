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
                        selection == 0 ? Image("1.music.fill") : Image("1.music")
                        Text("Requests")
                    }
                }
                .tag(0)
            MessagesView()
                .font(.title)
                .tabItem {
                    VStack {
                        selection == 1 ? Image("2.history.fill") : Image("2.history")
        
                        Text("Messages")
                    }
                }
                .tag(1)
            SettingsView()
                .font(.title)
                .tabItem {
                    VStack {
                        selection == 2 ? Image("3.settings.fill") : Image("3.settings")
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
        standardAppearance.stackedItemPositioning = .centered
        tabBar.standardAppearance = standardAppearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
