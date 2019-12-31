//
//  IndividualMessageRow.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/30/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

struct IndividualMessageRow: View {
    @ObservedObject var viewModel: MessageHistoryCellViewModel
    
    var body: some View {
        HStack {
            if viewModel.fromDJ {
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.message)
                        .foregroundColor(.white)
                        .font(.custom("Segoe UI", size: 17))
                        .background(viewModel.color)
                        .cornerRadius(6)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            else{
                VStack(alignment: .trailing, spacing: 10) {
                    Text(viewModel.message)
                        .foregroundColor(.white)
                        .font(.custom("Segoe UI", size: 17))
                        .background(viewModel.color)
                        .cornerRadius(6)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
        }
    }
}

struct IndividualMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        IndividualMessageRow(viewModel: MessageHistoryCellViewModel(originalRequest: OriginalRequest(timeStamp: Date(), original: "Orginal test message", fromDJ: false)))
    }
}
