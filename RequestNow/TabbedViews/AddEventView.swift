//
//  AddEventView.swift
//  RequestNow
//
//  Created by Nicole Klein on 3/8/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: AddEventViewModel
    // let style = CheckBoxAppearance(color: .blue, backgroundColor: .clear, cornerRadius: 5, borderWidth: 5, style: .small)
    
    init(viewModel: AddEventViewModel){
        self.viewModel = viewModel
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color().edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    LabelTextField(label: "NAME OF EVENT", placeHolder: "Fill in the name of the event")
                     DateTextField(label: "EVENT DATE", placeHolder: "Select start date", dateTitle: "Start Date", viewModel: viewModel)
                    LabelTextField(label: "AUTO REPLY SIGNATURE", placeHolder: "Fill in your auto reply signature")
                    LabelTextField(label: "THANK YOU MESSAGE", placeHolder: "Fill in your thank you message")
       
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Create Event").font(.custom("Oswald-Regular", size: 21))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(ColorCodes.teal.color())
                        }.padding().background(ColorCodes.darkGrey.color())
                }
                .listRowInsets(EdgeInsets())
                .background(ColorCodes.darkGrey.color())
                
            }
        }.navigationBarTitle(Text("Settings").foregroundColor(.white), displayMode: .inline)
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(viewModel: AddEventViewModel())
    }
}
