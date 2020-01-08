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
        Group {
            if viewModel.fromDJ {
                HStack{
                    Group {
                        Spacer()
                        Text(viewModel.message)
                            .foregroundColor(.white)
                            .font(.custom("Segoe UI", size: 17))
                            .padding(10)
                            .background(viewModel.color)
                            .cornerRadius(6)
                    }
                }
                
            }
            else{
                HStack {
                    Group {
                        Text(viewModel.message)
                            .foregroundColor(.white)
                            .font(.custom("Segoe UI", size: 17))
                            .padding(10)
                            .background(viewModel.color)
                            .cornerRadius(6)
                    }
                }
            }
        }
    }
}

struct IndividualMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        IndividualMessageRow(viewModel: MessageHistoryCellViewModel(originalRequest: OriginalMessage(timeStamp: Date(), original: "Orginal test message", fromDJ: false, name: "someone")))
    }
}
