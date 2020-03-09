//
//  EventSettings.swift
//  RequestNow
//
//  Created by Nicole Klein on 3/8/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct EventSettingsView: View {
    @EnvironmentObject var auth: AuthAccess
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color().edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 30) {
                    Button(action: {
                      
                        LiveChat.presentChat()
                    }) {
                        HStack {
                            Text("Support")
                                .foregroundColor(.white)
                                .font(.custom("Oswald-Regular", size: 17))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(ColorCodes.lightGrey.color())
                    }
                    Button(action: {
                        self.auth.logout()
                    }) {
                        HStack {
                            Text("Logout")
                                .foregroundColor(.white)
                                .font(.custom("Oswald-Regular", size: 17))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(ColorCodes.pastelRed.color())
                    }
                }
            }.navigationBarTitle(Text("Settings"), displayMode: .large)
        }
    }
}

struct EventSettings_Previews: PreviewProvider {
    static var previews: some View {
        EventSettingsView()
    }
}
