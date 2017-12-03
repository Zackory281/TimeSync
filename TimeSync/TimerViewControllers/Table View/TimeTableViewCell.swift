//
//  TimeTableViewCell.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/12/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
