//
//  RequestsViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

class RequestsViewController: UITableViewController {

   var requests: [Request]?
   var nameOfEvent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)

        // Do any additional setup after loading the view.
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCell
    
        cell.songName.text = requests![indexPath.row].songName
        cell.artist.text = requests![indexPath.row].artist
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
