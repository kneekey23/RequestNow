//
//  LoginModalView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/28/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

struct LoginModalView: View {
    
    @Environment (\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("The Event Key can be viewed in the dashboard or in your event confirmation email. If you cannot find it, please contact us at contact@requestnow.io.")
                        .foregroundColor(.white)
                        .font(.custom("Segoe UI", size: 17))
                        .padding()
                    .navigationBarItems(trailing:
                        Button(action:  {
                             self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Dismiss")
                                .foregroundColor(Color.white)
                                .font(.custom("Segoe UI", size: 17))
                        }
                    )
                }
            }
        }
        
    }
}

struct LoginModalView_Previews: PreviewProvider {
    static var previews: some View {
        LoginModalView()
    }
}
