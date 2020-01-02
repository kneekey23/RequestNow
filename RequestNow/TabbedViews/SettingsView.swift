//
//  SettingsView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

let navAppearance = UINavigationBarAppearance()

struct SettingsView: View {
    
    @ObservedObject var viewModel: RequestViewModel
    @State var showActionSheet = false
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
     private var viewController: UIViewController? {
        self.viewControllerHolder
     }
    
    init() {
        viewModel = RequestViewModel()
        
        navAppearance.configureWithOpaqueBackground()
        
        navAppearance.backgroundColor = ColorCodes.darkGrey.uicolor()
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        
    }
    
    func copyPhoneNumber() {
        UIPasteboard.general.string = viewModel.eventNumber
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Choose an option"), buttons: [
            .default(Text("Copy " + viewModel.eventNumber), action: {self.copyPhoneNumber()}),
            .destructive(Text("Cancel"))
        ])
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 30) {
                    HStack {
                        Text("Event is " + viewModel.eventStatus)
                            .foregroundColor(.white)
                            .font(.custom("Oswald-Regular", size: 20))
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    Button(action: {
                        self.showActionSheet.toggle()
                    }) {
                        HStack {
                            Text(viewModel.eventNumber)
                            .foregroundColor(.blue)
                            .font(.custom("Oswald-Regular", size: 20))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(ColorCodes.lighterShadeOfDarkGrey.color())
                    }
                    Button(action: {
                        self.viewModel.sendThankYouNote()
                    }) {
                        HStack {
                            Text("Send Thank You Note")
                            .foregroundColor(.white)
                            .font(.custom("Oswald-Regular", size: 17))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(ColorCodes.teal.color())
                    }
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
                        self.viewModel.logout()
                        self.viewController?.present(style: .fullScreen) {
                            LoginView()
                        }
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
                    Spacer()
                }     .actionSheet(isPresented: $showActionSheet, content: {
                       self.actionSheet })
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .alert(isPresented: $viewModel.showAlert) {
                switch viewModel.activeAlert {
                case .error:
                    return Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                case .success:
                    return Alert(title: Text("Success"), message: Text(viewModel.successMessage), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
