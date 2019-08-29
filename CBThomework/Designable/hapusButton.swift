//
//  hapusButton.swift
//  CBThomework
//
//  Created by Alan Santoso on 28/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class hapusButton: UIButton {

    override func awakeFromNib() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0.7253277898, blue: 0.9552869201, alpha: 1)
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.backgroundColor = #colorLiteral(red: 0.8047918081, green: 0, blue: 0, alpha: 1)

    }

}
