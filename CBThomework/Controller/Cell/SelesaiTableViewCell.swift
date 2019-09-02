//
//  SelesaiTableViewCell.swift
//  CBThomework
//
//  Created by Alan Santoso on 02/09/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class SelesaiTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        selesaiButton.layer.cornerRadius = 10
    }
    @IBOutlet weak var selesaiButton: UIButton!
    
}
