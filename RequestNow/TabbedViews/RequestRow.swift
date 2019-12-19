//
//  RequestRow.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI
import Combine

struct RequestRow: View {
   // @State var request: Request
    @ObservedObject var viewModel: RequestCellViewModel
    @State var isExpanded: Bool = false
    
    var body: some View {
        HStack {
            Image("first")
            VStack(alignment: .leading) {
                if !viewModel.songName.isEmpty && !viewModel.artist.isEmpty {
                Text(viewModel.songName)
                    .font(.custom("Segoe UI", size: 20))
                    .foregroundColor(Color.white)
                Text(viewModel.artist)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                }
                else {
                    Text(viewModel.originalMessage)
                    .font(.custom("Segoe UI", size: 20))
                    .foregroundColor(Color.white)
                }
                HStack {
                HStack {
                    Image("second")
                    Text(viewModel.time)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }.background(ColorCodes.darkGrey.color())
                HStack {
                    Image("first")
                    Text(viewModel.artist)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }.background(ColorCodes.darkGrey.color())
                }
            }
            Spacer()
            VStack {
                Button(action: {
                    self.isExpanded.toggle()
                }) {
                    Image("first")
                    }
                .foregroundColor(Color.white).background(ColorCodes.darkGrey.color())
            }
            if isExpanded {
                HStack {
                    Image("first")
                    Text(viewModel.originalMessage)
                        .frame(idealHeight: .infinity)
                }.background(ColorCodes.lighterShadeOfDarkGrey.color())
            }
            }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 10))
        .background(ColorCodes.lighterShadeOfDarkGrey.color())
      
    }
}

struct RequestRow_Previews: PreviewProvider {
    static var previews: some View {
        RequestRow(viewModel: RequestCellViewModel(request: Request(id: 1234, originalRequest: "Some original request", artist: "Taylor Swift", songName: "Fearless", timeOfRequest: Date(), isFavorite: false, fromNumber: "7149255555")))
    }
}
