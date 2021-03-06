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
    @State var showSortModal: Bool = false
    init() {
        viewModel = RequestViewModel()
        
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
            if viewModel.requestsViewModels.isEmpty {
                ZStack {
                    ColorCodes.darkGrey.color()
                    .edgesIgnoringSafeArea(.all)
                    Text("No songs have been requested yet").foregroundColor(.white).font(.custom("Segoe UI", size: 17))
                }
            }else {
                List{
                    ForEach(viewModel.requestsViewModels, id: \.id) { requestViewModel in
                        RequestRow(viewModel: requestViewModel)
                    }.onDelete(perform: delete)
                    .listRowBackground(ColorCodes.darkGrey.color())
                }
                .background(PullToRefresh(action: {
 
                    self.viewModel.getRequests(with: self.viewModel.eventId, sortSelection: self.viewModel.sortSelection)
                    
                    
                }, isShowing: $viewModel.isShowingRefresh))
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                }
                .navigationBarItems(trailing:
                    Button("Sort By") {
                        self.showSortModal.toggle()
                    }
                ).font(.custom("Segoe UI", size: 17))
                    .navigationBarTitle(Text("Song Requests"), displayMode:.inline)
                    .sheet(isPresented: $showSortModal) {
                        SortModal(viewModel: self.viewModel)
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
        viewModel.deleteRequest(index: index, fromRequests: true)
        }
    }
}



struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView()
    }
}
