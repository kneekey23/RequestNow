//
//  SortModal.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct SortModal: View {

    @ObservedObject var viewModel: RequestViewModel
     @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
        ZStack {
            ColorCodes.darkGrey.color()
                .edgesIgnoringSafeArea(.all)
            HStack {
            Button(action: {
                self.viewModel.sortSelection = .recency
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text("Recency")
                    .font(.custom("Oswald-Regular", size: 17))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(self.viewModel.sortSelection == .recency ? ColorCodes.teal.color() : ColorCodes.lighterShadeOfDarkGrey.color())
                }
            
            Button(action: {
                self.viewModel.sortSelection = .popularity
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text("Popularity")
                    .font(.custom("Oswald-Regular", size: 17))
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                    .background(self.viewModel.sortSelection == .popularity ? ColorCodes.teal.color() : ColorCodes.lighterShadeOfDarkGrey.color())
            }
            }
        }.navigationBarItems(trailing:
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

struct SortModal_Previews: PreviewProvider {
    static var previews: some View {
        SortModal(viewModel: RequestViewModel())
    }
}
