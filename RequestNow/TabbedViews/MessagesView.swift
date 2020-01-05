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
            List{
                ForEach(viewModel.messageViewModels, id: \.id) { messageViewModel in
                    NavigationLink(destination: MessageHistoryView(viewModel: messageViewModel)) {
                        MessageRow(viewModel: messageViewModel)
                        }
                }.listRowBackground(ColorCodes.darkGrey.color())
                
            }
            .navigationBarTitle(Text("Messages"), displayMode:.inline)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
