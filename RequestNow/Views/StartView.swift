//
//  StartView.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/15/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var auth: AuthAccess

    var body: some View {
           Group {
            if auth.isLoggedIn {
                MainView()
            } else {
                LoginView().environmentObject(auth)
            }

        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(AuthAccess())
    }
}
