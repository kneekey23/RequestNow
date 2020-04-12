//
//  EventRow.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct EventRow: View {
    
    @ObservedObject var viewModel: EventCellViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                    Text(viewModel.name)
                    .font(.custom("Segoe UI", size: 17))
                    .foregroundColor(Color.white)
                   
                    Text(viewModel.eventPhoneNumber)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
            }
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))

        .background(ColorCodes.lighterShadeOfDarkGrey.color())
        .listRowBackground(ColorCodes.lighterShadeOfDarkGrey.color())
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(viewModel: EventCellViewModel(event: Event(id: "1", name: "Test Event", phoneNumber: PhoneNumber(id: "1", description: "PHONE NUMBER", phoneNumber: "+17149255830", region: "us-west-1"), startDate: Date(), endDate: Date(), autoReplySignature: "--nicki", thankYouMessage: "thank you!", thankYouSent: true, autoSongDetectionEnabled: true, pushNotificationsEnabled: true, guestNamesEnabled: true, createdDate: "created", modifiedDate: "created", isActive: true, textMessages: [:], songRequestGroups: [:], guestPhoneNumbers: [:], description: "description")))
    }
}
