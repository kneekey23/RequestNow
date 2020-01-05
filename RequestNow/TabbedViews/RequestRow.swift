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
   
    @ObservedObject var viewModel: RequestCellViewModel
    @State var isExpanded: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                if !viewModel.songName.isEmpty && !viewModel.artist.isEmpty {
                VStack(alignment: .leading) {
                Text(viewModel.songName)
                    .font(.custom("Segoe UI", size: 17))
                    .foregroundColor(Color.white)
                   
                Text(viewModel.artist)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                    }
                }
                else {
                    Text(viewModel.originalMessages[0])
                    .font(.custom("Segoe UI", size: 20))
                    .foregroundColor(Color.white)
                }
                Spacer()

                Image(systemName: isExpanded ? "minus": "plus")
                    .foregroundColor(ColorCodes.lightGrey.color())
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(ColorCodes.darkGrey.color())
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                }
                
                }
                HStack {
                HStack {
                    Image("time")
                    Text(viewModel.time)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(ColorCodes.darkGrey.color())
                HStack {
                    Image("chat")
                    Text(viewModel.count)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(ColorCodes.darkGrey.color())
                }
                if isExpanded {
                    HStack{
                        VStack(alignment: .leading) {
                        ForEach((viewModel.originalMessages), id: \.self)  { message in
                            HStack {
                                Image("chat")
                                Text(message)
                                    .font(.custom("Segou UI", size: 14))
                                    .foregroundColor(ColorCodes.lightGrey.color())
                                    .fixedSize(horizontal: false, vertical: true)
                                    .transition(.opacity)
                                    .transition(.slide)
                            }
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            .background(ColorCodes.darkGrey.color())
                        }
                        }
                        Spacer()
                        Image("megaphone")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                            .onTapGesture {
                                self.viewModel.informUpNext()
                        }
                    
                    }
                }
            }

            }

        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 10))
        .background(ColorCodes.lighterShadeOfDarkGrey.color())
        .alert(isPresented: $viewModel.showAlert) {
            switch viewModel.activeAlert {
            case .error:
                return Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
            case .success:
                return Alert(title: Text("Success"), message: Text(viewModel.successMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct RequestRow_Previews: PreviewProvider {
    static var previews: some View {
        RequestRow(viewModel: RequestCellViewModel(request: Request(id: "12345", count: "2", originalRequests: ["Some original request that is really freaking long and it is so many lines im not sure what to do with it", "another request for the same song"], artist: "Taylor Swift", songName: "Fearless", timeOfRequest: Date())))
    }
}
