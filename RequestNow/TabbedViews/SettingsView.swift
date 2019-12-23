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
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Send Thank you Note")
                        .foregroundColor(.white)
                }.listRowBackground(ColorCodes.lighterShadeOfDarkGrey.color())
                .onTapGesture {
                    self.viewModel.sendThankYouNote()
                }
                Section {
                    Text("Logout")
                    .foregroundColor(.white)

                }
                .onTapGesture {
                        self.viewModel.logout()
                        self.viewController?.present(style: .fullScreen) {
                               LoginView()
                        }
                }
                .listRowBackground(ColorCodes.lighterShadeOfDarkGrey.color())
            }
            .alert(isPresented: $viewModel.showAlert) {
                switch viewModel.activeAlert {
                case .error:
                    return  Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                case .success:
                    return Alert(title: Text("Success"), message: Text("Your thank you note has been sent"), dismissButton: .default(Text("Ok")))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Settings"))
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
