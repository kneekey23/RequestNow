//
//  LoginView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @ObservedObject var viewModel: RequestViewModel
    @State var editingMode: Bool = false
    @State var showMessage = false
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
     private var viewController: UIViewController? {
        self.viewControllerHolder
     }
    
    init() {
        viewModel = RequestViewModel()
        viewModel.errorMessage = ""
    }
    
    var body: some View {
            ZStack {
                ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("requestnowlogo")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    Text("RequestNow")
                    .font(.custom("Segoe UI", size: 32))
                    .foregroundColor(Color.white)
                    
                    HStack{
                        VStack {
                            HStack {
                                Image("3.settings")
                                TextField("Enter event key", text: $viewModel.eventKey, onEditingChanged: {edit in
                                    if edit == true
                                    {self.editingMode = true}
                                    else
                                    {self.editingMode = false}
                                }).foregroundColor(.white)
                                    .font(.custom("Oswald-Regular", size: 21))
                            }
                            Rectangle()
                            .frame(height: 0.5, alignment: .bottom)
                            .foregroundColor(Color.white)

                        }.padding()
                        
                    }
                    if !viewModel.errorMessage.isEmpty {
                        VStack(alignment: .leading) {
                            Text("There was an error with the request. That event key does not exist.")
                                .foregroundColor(ColorCodes.pastelRed.color())
                                .lineLimit(nil)
                        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                    Button(action: {
                        if self.viewModel.eventId.isEmpty {
                            self.viewModel.getEventId(with: self.viewModel.eventKey)
                        }
                        else {
                            self.viewController?.present(style: .fullScreen) {
                                MainView()
                            }
                        }
                    }) {
                        HStack {
                            Text("LOGIN").font(.custom("Oswald-Regular", size: 21))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(ColorCodes.teal.color())
                    }.padding()
                    Button(action: {
                        self.showMessage.toggle()
                    }){
                        Text("Forgot your event key?")
                            .foregroundColor(ColorCodes.lightGrey.color())
                            .font(.custom("Oswald-Light", size: 17))
                    }
                    Spacer()
                    Button(action: {
                        let url: URL = URL(string: "https://requestnow.io/?ref=ios")!
                        UIApplication.shared.open(url)
                    }) {
                        Text("Don't have an account? Create one here")
                            .foregroundColor(ColorCodes.lightGrey.color())
                            .font(.custom("Oswald-Light", size: 17))
                    }
                }
            }.sheet(isPresented: $showMessage, content: {
                LoginModalView()
            }).offset(y: editingMode ? -150 : 0)

    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        self.navigationController?.modalPresentationStyle = .overCurrentContext
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

