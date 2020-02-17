//
//  EventsView.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct EventsView: View {
    @ObservedObject var viewModel: EventsViewModel
    
    init() {
        viewModel = EventsViewModel()
        coloredNavAppearance.configureWithOpaqueBackground()
        
        coloredNavAppearance.backgroundColor = ColorCodes.darkGrey.uicolor()
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        
        UINavigationBar.appearance().tintColor = .white
        
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            if viewModel.eventViewModels.isEmpty {
                ZStack {
                    ColorCodes.darkGrey.color()
                        .edgesIgnoringSafeArea(.all)
                    Text("No events are active yet. Click the plus button to purchase an event.").foregroundColor(.white).font(.custom("Segoe UI", size: 17))
                }
            }else {
                List{
                    ForEach(viewModel.eventViewModels, id: \.id) { eventViewModel in
                        EventRow(viewModel: eventViewModel)
                    }.listRowBackground(ColorCodes.darkGrey.color())
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                }
                .font(.custom("Segoe UI", size: 17))
                .navigationBarTitle(Text("Active Events"), displayMode:.inline)
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
