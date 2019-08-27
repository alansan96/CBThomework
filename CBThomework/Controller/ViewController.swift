//
//  ViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities : [Activity] = []
    var journals : [Journal] = []
    var sectionTitle : [String] = ["Aktivitas", "Refleksi"]
    
    var activityToSend : Activity?
    var journalToSend : Journal?
    
    override func viewWillAppear(_ animated: Bool) {
        activities = createActivities()
        journals = createJournal()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activities = createActivities()
        journals = createJournal()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
    }
    
    func createActivities() -> Array<Activity> {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let tempActivities = realm.objects(Activity.self).sorted(byKeyPath: "date", ascending: false)
        
        
        
        return Array(tempActivities)
        
    }
    
    func createJournal() -> Array<Journal> {
        let realm = try! Realm()
        let tempJournal = realm.objects(Journal.self).sorted(byKeyPath: "date", ascending: false)
        
        return Array(tempJournal)
        
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        //self.performSegue(withIdentifier: "createNewActivity", sender: self)
        self.performSegue(withIdentifier: "createFirstActivity", sender: self)
        
        
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        journalToSend = nil
        self.performSegue(withIdentifier: "createNewJournal", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewActivity" {
            if let vc: EditActivityViewController = segue.destination as? EditActivityViewController {
                vc.fullDetailActivity = activityToSend
            }
        }else if segue.identifier == "createNewJournal" {
            if let vc: NewJournalViewController = segue.destination as? NewJournalViewController {
                vc.fullJournalDetail = journalToSend
            }
        }
        
        
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if activities.count < 3 {
                return activities.count
            }
            return 3
            
        }else{
            if journals.count < 3 {
                return journals.count
            }
            return 3
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let activity = activities[indexPath.row]
        
        if indexPath.section == 0 {
            let name = activities[indexPath.row].title
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! FirstTableViewCell
            cell.label.text = name
            cell.timestampLabel.text = activities[indexPath.row].date
            cell.selectionStyle = .none
            return cell
            
            
        }else{
            let title = journals[indexPath.row].title
            let desc = journals[indexPath.row].descriptionText
            let timestamp = journals[indexPath.row].date
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as! JournalTableViewCell
            cell.selectionStyle = .none
            cell.journalLabel.text = title
            cell.descriptionLabel.text = desc
            cell.timestampLabel.text = timestamp
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BOOM"
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8469870687, green: 0.8471065164, blue: 0.8469493985, alpha: 1)
        
        let view2 = UIView()
        view2.backgroundColor = #colorLiteral(red: 0.8469870687, green: 0.8471065164, blue: 0.8469493985, alpha: 1)
        
        
        let text1 = UILabel()
        text1.text = sectionTitle[0]
        text1.font = text1.font.withSize(24)
        text1.frame =  CGRect(x:20, y: 5, width: 100, height: 35)
        
        let seeAllLabel = UIButton()
        seeAllLabel.setTitleColor(#colorLiteral(red: 0.2039215686, green: 0.4705882353, blue: 0.9647058824, alpha: 1), for: .normal)
        seeAllLabel.setTitle("Tambah", for: .normal)
        seeAllLabel.frame =  CGRect(x: 300, y: 5, width: 100, height: 35)
        
        let seeAllLabel2 = UIButton()
        seeAllLabel2.setTitleColor(#colorLiteral(red: 0.2039215686, green: 0.4705882353, blue: 0.9647058824, alpha: 1), for: .normal)
        seeAllLabel2.setTitle("Tambah", for: .normal)
        seeAllLabel2.frame =  CGRect(x: 300, y: 5, width: 100, height: 35)
        
        let text2 = UILabel()
        text2.text = sectionTitle[1]
        text2.font = text2.font.withSize(24)
        
        text2.frame =  CGRect(x:20, y: 5, width: 100, height: 35)
        
        
        view.addSubview(text1)
        view.addSubview(seeAllLabel)
        
        view2.addSubview(text2)
        view2.addSubview(seeAllLabel2)
        
        seeAllLabel.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        seeAllLabel2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        
        
        
        if section == 0 {
            return view
        }
        
        
        
        return view2
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view = UIView()
        view.backgroundColor = .white

        let button:UIButton = UIButton(frame: CGRect(x: 250, y: -5, width: 120, height: 40))
        button.setTitle("Lihat Semua", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2039215686, green: 0.4705882353, blue: 0.9647058824, alpha: 1), for: .normal)

        if section == 0 {
            button.addTarget(self, action:#selector(self.buttonClickedActivity), for: .touchUpInside)
            if activities.count < 4 {
                button.isHidden = true
            }else{
                button.isHidden = false
            }

        }else {
            button.addTarget(self, action:#selector(self.buttonClickedRefleksi), for: .touchUpInside)
            if journals.count < 4 {
                button.isHidden = true
            }else{
                button.isHidden = false
            }

        }
        view.addSubview(button)

        
        return view
    }
    
    @objc func buttonClickedActivity() {
        print("Button Clicked activity")
        self.performSegue(withIdentifier: "seeAllActivitySegue", sender: self)
        
    }
    
    @objc func buttonClickedRefleksi() {
        print("Button Clicked refleksi")
        self.performSegue(withIdentifier: "seeAllRefleksiSegue", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 125
        }
        
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        
        
        
        if indexPath.section == 0 {
            let dateIndentifier = activities[indexPath.row].date
            let tempActivity = realm.objects(Activity.self).filter("date == '\(dateIndentifier)'")
            let array = Array(tempActivity) // la fin
            activityToSend = array[0]
            self.performSegue(withIdentifier: "createNewActivity", sender: self)
        }
        else if indexPath.section == 1 {
            let dateIndentifier = journals[indexPath.row].date
            let tempJournal = realm.objects(Journal.self).filter("date == '\(dateIndentifier)'")
            let array = Array(tempJournal)
            journalToSend = array[0]
            self.performSegue(withIdentifier: "createNewJournal", sender: self)
        }
        
        
        
    }
    
    
}
