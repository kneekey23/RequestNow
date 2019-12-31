//
//  MessageHistoryView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/30/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

struct MessageHistoryView: View {
    @ObservedObject var viewModel: MessageCellViewModel
    @State var composedMessage: String = ""
    
    var body: some View {
        ZStack {
            ColorCodes.darkGrey.color()
                .edgesIgnoringSafeArea(.all)
            VStack {
            List {
                ForEach(viewModel.messages, id:\.id) {msg in
                    IndividualMessageRow(viewModel: msg)
                }.listRowBackground(ColorCodes.darkGrey.color())
            }
            Spacer()
            HStack {
                TextField("Message...", text: $composedMessage)
                .frame(minHeight: 30)
                .foregroundColor(.white)
                .background(ColorCodes.lighterShadeOfDarkGrey.color())
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Button(action: {
                
                }) {
                    Text("Send")
                }
                }.frame(minHeight: CGFloat(50)).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            }
        }
    }
}

struct MessageHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MessageHistoryView(viewModel: MessageCellViewModel(message: Message(id: "1234", originalRequests: [OriginalRequest(timeStamp: Date(), original: "orgiinal request test", fromDJ: false)], timeOfRequest: Date(), messageCount:"2")))
    }
}
