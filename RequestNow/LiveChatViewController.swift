//
//  LiveChatViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//


import SwiftUI
import UIKit


final class LiveChatViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {

        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LiveChatViewController>) {
        let button = UIButton()
        button.frame = CGRect(x: uiViewController.view.frame.size.width - 60, y: 60, width: 50, height: 50)
        button.addTarget(self, action: #selector(openLiveChat), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Open Live chat", for: .normal)
        uiViewController.view.addSubview(button)
    }
    
    @objc func openLiveChat() {
         LiveChat.presentChat()
    }

}
