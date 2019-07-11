//
//  RequestCell.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var originalMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
