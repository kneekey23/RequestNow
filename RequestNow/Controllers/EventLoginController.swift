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

class EventLoginController: UIViewController, UITextFieldDelegate {
    
    var requests: [Request] = [Request]()
    var requestResponse: Requests?

    var nameOfEvent: String?

    @IBAction func submitEventKey(_ sender: Any) {
        
        Alamofire.request(EVENT_DATA + "?event_key=" + eventKeyTxtField.text!, method: .get, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
            
            if response.result.error == nil {
                print(response.result)
                print("Success! Got all requests")
                dump(response.result.value)
               
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["message"].string  == "Internal server error" {
                        let alert = UIAlertController(title: "Error", message: "Please enter a current event code. The event code you entered was incorrect", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            
                        }
                        alert.addAction(ok)
                        self.navigationController!.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.requestResponse = data
                        //store event key to call requests from next page
                        UserDefaults.standard.set(self.eventKeyTxtField.text!, forKey: "eventKey")
                   
                    }
                    
                        self.segueToRequests()
                }

                
            } else {
                print("Error!")
                debugPrint(response.result.error as Any)
            }
        }
        
        
    }
    
    @IBOutlet weak var eventKeyTxtField: UITextField!
    
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

