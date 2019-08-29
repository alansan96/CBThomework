//
//  SeeAllJournalViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 26/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class SeeAllJournalViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var labels : [String] = ["asd", "aqw", "zxc"]
    var journals : Array<Journal> = Array()
    
    var journalToSend : Journal?

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journals = fetchAllJournal()
        
        tableView.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    func fetchAllJournal() -> Array<Journal> {
        let realm = try! Realm()
        let tempActivities = realm.objects(Journal.self).sorted(byKeyPath: "date", ascending: false)
        
        return Array(tempActivities)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editJournalSegue" {
            if let vc: NewJournalViewController = segue.destination as? NewJournalViewController {
                vc.fullJournalDetail = journalToSend
            }
        }
    }

    
}


extension SeeAllJournalViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullRefleksiCell") as! FullRefleksiTableViewCell
        cell.selectionStyle = .none
        cell.judulRefleksiLabel.text = journals[indexPath.row].title
        cell.descriptionRefleksiLabel.text = journals[indexPath.row].descriptionText
        cell.timestampLabel.text = journals[indexPath.row].date
        cell.journalView.dropShadow()
        cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let realm = try! Realm()
        let dateIndentifier = journals[indexPath.row].date
        let tempJournal = realm.objects(Journal.self).filter("date == '\(dateIndentifier)'")
        let array = Array(tempJournal)
        journalToSend = array[0]
        print(journalToSend)
        self.performSegue(withIdentifier: "editJournalSegue", sender: self)

    }
    
}
