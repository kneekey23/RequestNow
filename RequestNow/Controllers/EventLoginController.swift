//
//  FirstViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import Combine

@available(iOS 13.0, *)
class EventLoginController: UIViewController, UITextFieldDelegate {
    
    var requests: [Request] = [Request]()
    var requestResponse: Requests?
    var nameOfEvent: String?

    @IBAction func submitEventKey(_ sender: Any) {
        
        if let eventKey = eventKeyTxtField.text, let unwrappedEventKey = Int(eventKey) {
            
        DispatchQueue.global(qos: .utility).async {
            self.registerDeviceTokenForPushNotifications(eventKey: unwrappedEventKey)
        }
        
//        requestService.getRequests(eventId: unwrappedEventKey, completion: { (success) in
//            if success {
//                self.segueToRequests()
//            }
//            else{
//                let alert = UIAlertController(title: "Error", message: "Please enter a current event code. The event code you entered was incorrect", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in }
//                alert.addAction(ok)
//                self.navigationController!.present(alert, animated: true, completion: nil)
//            }
//        })
        }
    }
    
    @IBOutlet weak var eventKeyTxtField: UITextField!
    
    func registerDeviceTokenForPushNotifications(eventKey: Int) {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
//            requestService.registerDeviceToken(eventKey: eventKey, deviceToken: deviceToken, completion: { (success) in
//                if success {
//                    print("device registered for push notifications")
//                }
//                else {
//                    print("device registration for push notifications was unsucessful")
//                }
//            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Welcome to RequestNow"
        self.eventKeyTxtField.delegate = self
        // Do any additional setup after loading the view.
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

