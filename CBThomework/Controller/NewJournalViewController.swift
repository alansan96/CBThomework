//
//  NewJournalViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 25/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class NewJournalViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var journalTitle: UITextField!
    @IBOutlet weak var journalDescription: UITextView!
    @IBOutlet weak var tambahOutlet: UIBarButtonItem!
    
    
    
    @IBOutlet weak var hapusOutlet: UIButton!
    
    var fullJournalDetail : Journal?
    
    override func viewWillAppear(_ animated: Bool) {
        print(fullJournalDetail)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view2 \(fullJournalDetail)")
        journalDescription.delegate = self
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        
        initiateData()
        
    }
    
    func textViewDidBeginEditing(_ journalDescription: UITextView) {
        print("masuk edit")
        if journalDescription.textColor == UIColor.lightGray {
            journalDescription.text = nil
            journalDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ journalDescription: UITextView) {
        print("selesai edit")
        
        if journalDescription.text.isEmpty {
            journalDescription.text = "Placeholder"
            journalDescription.textColor = UIColor.lightGray
        }
    }
    
    func initiateData(){
        if fullJournalDetail != nil {
            journalTitle.text = fullJournalDetail?.title
            journalDescription.text = fullJournalDetail?.descriptionText
            tambahOutlet.title = "Edit"
            
            
        }else {
            journalTitle.text = ""
            journalTitle.placeholder = "Judul Title"
            journalDescription.text = "Catatan"
            journalDescription.textColor = UIColor.lightGray
            hapusOutlet.isHidden = true
            
        }
        
        
        
    }
    
    func sendToRealm(){
        let realm = try! Realm()
        var  journal1 = Journal()
        journal1.title = journalTitle.text ?? ""
        journal1.descriptionText = journalDescription.text
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        let result = formatter.string(from: date)
        journal1.date = result
        
        
        try! realm.write {
            realm.add(journal1)
        }
        //var tempJournal = realm.objects(Journal.self).sorted(byKeyPath: "date", ascending: false)
        
        
    }
    
    @IBAction func addJournalAction(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            let alert = UIAlertController(title: "Anda Yakin?", message: "Tindakan ini akan mengubah refleksi anda", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: { ACTION in
                print("cancel")
            }))
            alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { ACTION in
                let realm = try! Realm()
                if self.fullJournalDetail != nil {
                    try! realm.write {
                        self.fullJournalDetail?.title = self.journalTitle.text!
                        self.fullJournalDetail?.descriptionText = self.journalDescription.text
                    }
                }else {
                    self.sendToRealm()
                    
                }
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let alert = UIAlertController(title: "Anda Yakin?", message: "Tindakan ini akan menambah refleksi anda", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: { ACTION in
                print("cancel")
            }))
            alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { ACTION in
                let realm = try! Realm()
                if self.fullJournalDetail != nil {
                    try! realm.write {
                        self.fullJournalDetail?.title = self.journalTitle.text!
                        self.fullJournalDetail?.descriptionText = self.journalDescription.text
                    }
                }else {
                    self.sendToRealm()
                    
                }
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    

    
    @IBAction func hapusActiion(_ sender: Any) {
        let alert = UIAlertController(title: "Anda Yakin?", message: "Tindakan ini akan menghapus refleksi yang anda pilih", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: { ACTION in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { ACTION in
            let realm = try! Realm()
            let items = realm.objects(Journal.self).filter("date = '\(self.fullJournalDetail?.date ?? "")'")
            print(items)
            try! realm.write {
                realm.delete(items)
            }
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
