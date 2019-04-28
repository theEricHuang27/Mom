//
//  EventTableViewCell.swift
//  Mom
//
//  Created by Connor Stange (student LM) on 3/29/19.
//  Copyright © 2019 Duck Inc. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var Date: UILabel!
    @IBOutlet var Subject: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
