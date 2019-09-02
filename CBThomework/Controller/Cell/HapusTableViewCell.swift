//
//  HapusTableViewCell.swift
//  CBThomework
//
//  Created by Alan Santoso on 02/09/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class HapusTableViewCell: UITableViewCell {

    @IBOutlet weak var hapusButton: UIButton!
    
    override func awakeFromNib() {
        hapusButton.layer.cornerRadius = 10
    }
    
    
}
