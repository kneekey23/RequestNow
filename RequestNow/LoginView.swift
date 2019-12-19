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
    @State private var action: Int? = 0
    
    init() {
        viewModel = RequestViewModel()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: MainView(), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    Image("first")
                    Text("Request Now")
                        .font(.custom("Segoe UI", size: 32))
                        .foregroundColor(Color.white)
                    
                    HStack{
                        VStack {
                            HStack {
                                Image("second")
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
                            if !viewModel.errorMessage.isEmpty {
                                Text("There was an error with the request.")
                                    .foregroundColor(ColorCodes.pastelRed.color())
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }
                        }.padding()
                        
                    }
                    Button(action: {
                        self.viewModel.getEventId(with: self.viewModel.eventKey)
                        if !self.viewModel.eventKey.isEmpty {
                            self.action = 1
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
                }
            }.offset(y: editingMode ? -150 : 0)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

