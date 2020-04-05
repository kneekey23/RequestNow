//
//  LabelTextField.swift
//  RequestNow
//
//  Created by Nicole Klein on 4/5/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI


struct LabelTextField : View {
    var label: String
    var placeHolder: String
 
    var body: some View {
 
        VStack(alignment: .leading) {
            HStack {
            Text(label).font(.headline).foregroundColor(.white)
                Image("time")
            }
            TextField(placeHolder, text: .constant(""))
                .padding(.all)
                .background(Color(.sRGB, red: 239.0/255, green: 243.0/255.0, blue: 244.0/255, opacity: 1.0))
                .cornerRadius(5.0)
        }.padding(.horizontal, 15)
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(label: "NAME", placeHolder: "Fill in the restaurant name")
    }
}
