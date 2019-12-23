//
//  ThankYouNoteView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/22/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

struct ThankYouNoteView: View {
    @State private var note: String = ""
    @ObservedObject var viewModel: RequestViewModel
    var body: some View {
        NavigationView {
            ZStack {
                ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    TextField("Enter your thank you note", text: $note)
                        .foregroundColor(Color.white)
                        .lineLimit(10)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .padding(.all)
                        .background(ColorCodes.lighterShadeOfDarkGrey.color())
                        .cornerRadius(5.0)
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Send Thank You Note")
                                .font(.custom("Oswald", size: 17))
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                    }.padding(.vertical, 10.0)
                        .background(ColorCodes.teal.color())
                        .cornerRadius(5.0)
                    .navigationBarItems(trailing:
                        Button(action:  {
                           
                        }) {
                            Text("Dismiss")
                            .foregroundColor(Color.white)
                            .font(.custom("Segoe UI", size: 17))
                        }
                    )
                }.padding(.horizontal, 15)
                
            }
        }
    }
}

struct ThankYouNoteView_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouNoteView(viewModel: RequestViewModel())
    }
}
