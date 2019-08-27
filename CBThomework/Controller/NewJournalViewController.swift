//
//  NewJournalViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 25/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class NewJournalViewController: UIViewController {
    
    @IBOutlet weak var journalTitle: UITextField!
    @IBOutlet weak var journalDescription: UITextView!
    @IBOutlet weak var tambahOutlet: UIBarButtonItem!
    
    var fullJournalDetail : Journal?


    override func viewDidLoad() {
        super.viewDidLoad()
        print("view2 \(fullJournalDetail)")
        initiateData()
    }
    
    func initiateData(){
        if fullJournalDetail != nil {
            journalTitle.text = fullJournalDetail?.title
            journalDescription.text = fullJournalDetail?.descriptionText
            tambahOutlet.title = "Edit"
            
        }else {
            journalTitle.text = ""
            journalTitle.placeholder = "Judul Title"
            journalDescription.text = ""
        }
        
        
        
    }
    
    
    func sendToRealm(){
        let realm = try! Realm()
        var  journal1 = Journal()
        journal1.title = journalTitle.text ?? ""
        journal1.descriptionText = journalDescription.text
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:SS"
        let result = formatter.string(from: date)
        journal1.date = result
        
        
        try! realm.write {
            realm.add(journal1)
        }
        //var tempJournal = realm.objects(Journal.self).sorted(byKeyPath: "date", ascending: false)
        
        
    }

    @IBAction func addJournalAction(_ sender: UIBarButtonItem) {
        let realm = try! Realm()

        if fullJournalDetail != nil {
            try! realm.write {
                fullJournalDetail?.title = journalTitle.text!
                fullJournalDetail?.descriptionText = journalDescription.text
            }
        }else {
            sendToRealm()

        }
    }
    
}