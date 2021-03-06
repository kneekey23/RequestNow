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
                    Text(viewModel.originalRequests[0].original)
                        .font(.custom("Segoe UI", size: 17))
                        .foregroundColor(Color.white)
                }
                Spacer()

                Image(systemName: isExpanded ? "minus": "plus")
                    .foregroundColor(ColorCodes.lightGrey.color())
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(ColorCodes.darkGrey.color()).cornerRadius(2)
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
                .background(ColorCodes.darkGrey.color()).cornerRadius(2)
                HStack {
                    Image("chat")
                    Text(viewModel.count)
                    .font(.custom("Segou UI", size: 14))
                    .foregroundColor(ColorCodes.lightGrey.color())
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(ColorCodes.darkGrey.color()).cornerRadius(2)
                }
                if isExpanded {
                    HStack{
                        VStack(alignment: .leading) {
                        ForEach((viewModel.originalRequests), id: \.id)  { request in
                            HStack {
                               Image("chat")
                                VStack(alignment: .leading) {
                                if !request.name.isEmpty {
                                Text(request.name)
                                    .font(.custom("Segou UI", size: 14))
                                    .foregroundColor(ColorCodes.lightGrey.color())
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                                    .transition(.opacity)
                                    .transition(.slide)
                                    }
                                Text(request.original)
                                    .font(.custom("Segou UI", size: 14))
                                    .foregroundColor(ColorCodes.lightGrey.color())
                                    .fixedSize(horizontal: false, vertical: true)
                                    .transition(.opacity)
                                    .transition(.slide)
                                }
                            }
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            .background(ColorCodes.darkGrey.color()).cornerRadius(2)
                        }
                        }
                        Spacer()
                        Image("megaphone")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                            .onTapGesture {
                                self.viewModel.activeAlert = .confirm
                                self.viewModel.showAlert = true
                        }
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(ColorCodes.darkGrey.color()).cornerRadius(2)
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
            case .confirm:
                return Alert(title: Text("Confirmation"), message: Text("Are you sure you want to notify everyone that " + viewModel.songName + " is next?"), primaryButton: .default(Text("Yes"), action: {
                    self.viewModel.informUpNext()
                }), secondaryButton: .cancel(Text("Cancel")))
            }
        }
    }
}

struct RequestRow_Previews: PreviewProvider {
    static var previews: some View {
        RequestRow(viewModel: RequestCellViewModel(request: Request(id: "12345", count: "2", originalRequests: [OriginalRequest(original: "Some original request that is really freaking long and it is so many lines im not sure what to do with it", name: "me"), OriginalRequest(original:"another request for the same song", name: "justin") ], artist: "Taylor Swift", songName: "Fearless", timeOfRequest: Date())))
    }
}
