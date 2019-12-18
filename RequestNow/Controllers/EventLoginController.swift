//
//  FirstViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import Combine

class EventLoginController: UIViewController, UITextFieldDelegate {
    
    var viewModel: RequestViewModel!

    @IBAction func submitEventKey(_ sender: Any) {
        
        if !viewModel.eventId.isEmpty {
            self.segueToRequests()
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter a current event code. The event code you entered was incorrect", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var eventKeyTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RequestViewModel()
        navigationItem.title = "Welcome to RequestNow"
        eventKeyTxtField.delegate = self
        setUpBindings()
        // Do any additional setup after loading the view.
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
            _ = eventKeyTxtField.textPublisher
                .debounce(for: 0.1, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.eventKey, on: viewModel)
            
        }
        bindViewToViewModel()
    }
    
    func segueToRequests(){
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestsViewController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventKeyTxtField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

