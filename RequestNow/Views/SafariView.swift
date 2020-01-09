//
//  SafariView.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/8/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    var url: URL?

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url!)
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

#if DEBUG
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://david.y4ng.fr")!)
    }
}
#endif
