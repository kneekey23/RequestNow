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

class EventLoginController: UIViewController {
    
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
        // Do any additional setup after loading the view.
    }
    
    func segueToRequests(){
         performSegue(withIdentifier: "toRequestApp", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRequestApp" {
            if let requestVC = segue.destination as? RequestsViewController {
                requestVC.requests = self.requestResponse?.requestList
                requestVC.nameOfEvent = self.requestResponse?.nameOfEvent

            }
        }
    }

}

