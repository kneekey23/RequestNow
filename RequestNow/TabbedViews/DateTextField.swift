//
//  DateTextField.swift
//  RequestNow
//
//  Created by Nicole Klein on 4/5/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI

struct DateTextField: View {
    var label: String
    var placeHolder: String
    @State var showDatePicker = false
    var dateTitle: String
    @ObservedObject var viewModel: AddEventViewModel
    
    init(label: String, placeHolder: String, dateTitle: String, viewModel: AddEventViewModel) {
        self.label = label
        self.placeHolder = placeHolder
        self.dateTitle = dateTitle
        self.viewModel = viewModel
        UIDatePicker.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.headline).foregroundColor(.white)
            TextField(placeHolder, text: $viewModel.startDateString, onEditingChanged: { (editing) in
                self.showDatePicker = editing
            })
                .padding(.all)
                .background(Color(.sRGB, red: 239.0/255, green: 243.0/255.0, blue: 244.0/255, opacity: 1.0))
                .cornerRadius(5.0)
            if self.showDatePicker {
                DatePicker(selection: $viewModel.start, in: Date()..., displayedComponents: .date) {
                    Text("")
                }.colorInvert()
            }
        }.padding(.horizontal, 15)
    }
}

struct DateTextField_Previews: PreviewProvider {
    static var previews: some View {
        DateTextField(label: "START DATE", placeHolder: "Select the start date", dateTitle: "START DATE", viewModel: AddEventViewModel())
    }
}
