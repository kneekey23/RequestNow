//
//  RequestsViewController.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import CoreData

class RequestsViewController: UITableViewController {

   // var requests: [Request]?
    var nameOfEvent: String?
    var defaults = UserDefaults.standard
    private let viewModel: RequestViewModel
    
    init(viewModel: RequestViewModel = RequestViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
       // self.getRequests()
      
        self.refreshControl = UIRefreshControl()
       // refreshControl!.addTarget(self, action: viewModel.getRequests(with:), for: .valueChanged)
        refreshControl!.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        setUpBindings()
        // Do any additional setup after loading the view.
//         NotificationCenter.default.addObserver(self, selector: #selector(RequestsViewController.recievedPushNotification(_:)), name: UPDATE_REQUESTS, object: nil)
    }
    
    private func setUpBindings() {

        
        func bindViewModelToView() {
            _ = viewModel.$requestViewModels
                .receive(on: RunLoop.main)
                .sink { [weak self] viewModels in
                    self?.tableView.reloadData()
            }
            
            _ = viewModel.$state
                .receive(on: RunLoop.main)
                .sink { [weak self] state in
                    switch state {
                    case .loading: self?.refreshControl?.beginRefreshing()
                    case .finishedLoading: self?.refreshControl?.endRefreshing()
                    case .error(let error):
                        self?.refreshControl?.endRefreshing()
                        self?.showError(error)
                    }
            }
        }
        bindViewModelToView()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func recievedPushNotification(_ notification: Notification) {
//        DispatchQueue.main.async {
//            print("got a new song request")
//            self.tableView.reloadData()
//        }
//    }
    
    
//    @objc private func refreshRequests(_ sender: Any) {
//        getRequests()
//    }
//
    
//    func getRequests() {
//
//        requestService.getRequests2(eventId: defaults.integer(forKey: "eventKey"), completion: { (success) in
//            if success {
//                self.requests = self.requestService.requests
//                self.nameOfEvent = self.requestService.nameOfEvent
//                self.tableView.reloadData()
//                self.refreshControl!.endRefreshing()
//            }
//            else {
//                let alert = UIAlertController(title: "Error", message: "Please try logging in again with a current event code. The event code that is saved is incorrect", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in }
//                alert.addAction(ok)
//                self.navigationController!.present(alert, animated: true, completion: nil)
//            }
//        })
//    }
    
//    func registerForPushNotifications() {
//        DispatchQueue.global(qos: .utility).async {
//            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"){
//                let eventKey = UserDefaults.standard.integer(forKey: "eventKey")
//                self.requestService.registerDeviceToken(eventKey: eventKey, deviceToken: deviceToken, completion: { (success) in
//                    if success {
//                        print("device registered for push notifications")
//                    }
//                    else {
//                        print("device registration for push notifications was unsucessful")
//                    }
//                })
//            }
//        }
//    }

    
//    func deleteRequest(id: Int) {
//        requestService.deleteRequest(id: id, completion: { (success) in
//            if success {
//                self.getRequests()
//            }
//            else{
//                let alert = UIAlertController(title: "Error", message: "This request can't be deleted.", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in }
//                alert.addAction(ok)
//                self.navigationController!.present(alert, animated: true, completion: nil)
//            }
//        })
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCell
        
        if viewModel.requestViewModels[indexPath.row].songName.isEmpty && viewModel.requestViewModels[indexPath.row].artist.isEmpty {
            cell.originalMessage.text = viewModel.requestViewModels[indexPath.row].originalMessage
            cell.songName.text = ""
            cell.artist.text = ""
        }
        else {
            cell.songName.text = viewModel.requestViewModels[indexPath.row].songName
            cell.artist.text = viewModel.requestViewModels[indexPath.row].artist
            cell.originalMessage.text = ""
        }
        
        cell.time.text = "Incoming Song Request - " + (viewModel.requestViewModels[indexPath.row].time.toDate()?.toTime())!
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requestViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //requests?.remove(at: indexPath.row)
           // self.deleteRequest(id: requests![indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        headerView.backgroundColor = UIColor.darkGray
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 30)
        label.text = "Request Now"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        let eventNameLabel = UILabel()
        eventNameLabel.frame = CGRect.init(x: 0, y: 20, width: headerView.frame.width, height: 70)
        eventNameLabel.text = nameOfEvent ?? "Event Name"
        eventNameLabel.font = UIFont.init(name: "System", size: 30)
        eventNameLabel.textAlignment = .center
        eventNameLabel.numberOfLines = 3
        eventNameLabel.contentMode = .scaleToFill
        eventNameLabel.lineBreakMode = .byWordWrapping
        //label.font = UIFont().futuraPTMediumFont(16) // my custom font
       // label.textColor = UIColor.charcolBlackColour() // my custom colour
        
        headerView.addSubview(label)
        headerView.addSubview(eventNameLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

}
