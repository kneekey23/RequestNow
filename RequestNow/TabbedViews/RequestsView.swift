//
//  RequestsView.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI

let coloredNavAppearance = UINavigationBarAppearance()

struct RequestsView: View {
    
    @ObservedObject var viewModel: RequestViewModel
    
    init() {
        viewModel = RequestViewModel()

        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = ColorCodes.darkGrey.uicolor()
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance

         UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            ZStack {
            ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
         
                List{
                    ForEach(viewModel.requestsViewModels, id: \.id) { requestViewModel in
                        RequestRow(viewModel: requestViewModel)
                    }.listRowBackground(ColorCodes.darkGrey.color())
                }
                .navigationBarTitle(Text("Song Requests").font(.custom("Segoe UI", size: 40)))
                
            }
        }
    }
}

struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView()
    }
}
