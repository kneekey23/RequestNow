//
//  MessagesView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

let messageNavAppearance = UINavigationBarAppearance()

struct MessagesView: View {
    
    @ObservedObject var viewModel: RequestViewModel
    
    init() {
        viewModel = RequestViewModel()
        
        messageNavAppearance.configureWithOpaqueBackground()
        
        messageNavAppearance.backgroundColor = ColorCodes.darkGrey.uicolor()
        messageNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        messageNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = messageNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = messageNavAppearance
        
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        NavigationView {
            if viewModel.messageViewModels.isEmpty {
                ZStack {
                    ColorCodes.darkGrey.color()
                        .edgesIgnoringSafeArea(.all)
                    Text("No messages have been sent yet").foregroundColor(.white).font(.custom("Segoe UI", size: 17))
                }
            }else {
                List{
                    ForEach(viewModel.messageViewModels, id: \.id) { messageViewModel in
                        NavigationLink(destination: MessageHistoryView(viewModel: messageViewModel)) {
                            MessageRow(viewModel: messageViewModel)
                        }
                    }.onDelete(perform: delete)
                        .listRowBackground(ColorCodes.darkGrey.color())
                    
                }
                .navigationBarTitle(Text("Messages"), displayMode:.inline)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
        viewModel.deleteRequest(index: index)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
