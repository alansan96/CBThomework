//
//  FirstTableViewCell.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func setActivity(activity : Activity){
        label.text = activity.title
    }
    

}
