//
//  JournalTableViewCell.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var journalLabel: UILabel!
    
    func setJournal(journal : Journal){
        journalLabel.text = journal.title
    }
    
    
}
