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
            VStack(alignment: .leading) {
                HStack {
                
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                    .font(.custom("Segoe UI", size: 17))
                    .foregroundColor(Color.white)
                   
                    Text(viewModel.eventPhoneNumber)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                    }
                }
                Spacer()
                
            }
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 10))
        .background(ColorCodes.lighterShadeOfDarkGrey.color())
    }
}

//struct EventRow_Previews: PreviewProvider {
//    static var previews: some View {
//        EventRow(viewModel: EventCellViewModel(event: Event()))
//    }
//}
