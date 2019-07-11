//
//  RequestsViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import CoreData

class RequestsViewController: UITableViewController {

   var requests: [Request]?
    var requestResponse: Requests?
   var nameOfEvent: String?
    var defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        self.getRequests()
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshRequests(_:)), for: .valueChanged)
        refreshControl!.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        // Do any additional setup after loading the view.
    }
    
    
    @objc private func refreshRequests(_ sender: Any) {
        // Fetch Weather Data
        getRequests()
    }
    
    func getRequests() {
        Alamofire.request(EVENT_DATA + "?event_key=" + defaults.string(forKey: "eventKey")!, method: .get, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
            
            if response.result.error == nil {
                print(response.result)
                print("Success! Got all requests")
                dump(response.result.value)
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["message"].string  == "Internal server error" {
                        let alert = UIAlertController(title: "Error", message: "Please try logging in again with a current event code. The event code that is saved is incorrect", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            
                        }
                        alert.addAction(ok)
                        self.navigationController!.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.requestResponse = data
                        self.requests = self.requestResponse?.requestList
                        self.tableView.reloadData()
                        self.refreshControl!.endRefreshing()
                        //self.activityIndicatorView.stopAnimating()
                        
                    }
                    
                    
                }
                
                
            } else {
                print("Error!")
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func deleteRequest(id: Int) {
        print("id to be deleted:" + String(id))
        let body: [String: Any] = [
            "request_id": id
        ]
        
        Alamofire.request(DELETE_REQUEST, method: .post,parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
            
            if response.result.error == nil {
                print(response.result)
                print("Success! Deleted Request")
                dump(response.result.value)
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["message"].string  == "Internal server error" {
                        let alert = UIAlertController(title: "Error", message: "This request can't be deleted.", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            
                        }
                        alert.addAction(ok)
                        self.navigationController!.present(alert, animated: true, completion: nil)
                    }
                    else{
       
                        self.getRequests()
                        
                    }
                    
                    
                }
                
                
            } else {
                print("Error!")
                debugPrint(response.result.error as Any)
            }
        }
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCell
        if requests![indexPath.row].songName == nil && requests![indexPath.row].artist == nil {
            cell.originalMessage.text = requests![indexPath.row].originalRequest
            cell.songName.text = ""
            cell.artist.text = ""
        }
        else {
            cell.songName.text = requests![indexPath.row].songName
            cell.artist.text = requests![indexPath.row].artist
            cell.originalMessage.text = ""
        }
    
        cell.time.text = "Incoming Song Request - " + requests![indexPath.row].timeOfRequest!
    
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = requests?.count {
            return count
        }
        else{
            return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            requests?.remove(at: indexPath.row)
            self.deleteRequest(id: requests![indexPath.row].id!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Request Now"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        //label.font = UIFont().futuraPTMediumFont(16) // my custom font
       // label.textColor = UIColor.charcolBlackColour() // my custom colour
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

}
