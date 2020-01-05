//
//  MessageRow.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/22/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI
import Combine

struct MessageRow: View {
    
    @ObservedObject var viewModel: MessageCellViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.originalMessages[0])
                .font(.custom("Segoe UI", size: 17))
                .foregroundColor(Color.white)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
                .transition(.slide)
                HStack {
                    HStack {
                        Image("time")
                        Text(viewModel.time)
                            .font(.custom("Segou UI", size: 14))
                            .foregroundColor(ColorCodes.lightGrey.color())
                    }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(ColorCodes.darkGrey.color()).cornerRadius(2)
                    HStack {
                        Image("chat")
                        Text(viewModel.messageCount)
                            .font(.custom("Segou UI", size: 14))
                            .foregroundColor(ColorCodes.lightGrey.color())
                    }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(ColorCodes.darkGrey.color()).cornerRadius(2)
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 20))
        .background(ColorCodes.lighterShadeOfDarkGrey.color())
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(viewModel: MessageCellViewModel(message: Message(id: "12345", originalRequests: [OriginalRequest(timeStamp: Date(), original: "test string", fromDJ: false)], timeOfRequest: Date(), messageCount: "2")))
    }
}
