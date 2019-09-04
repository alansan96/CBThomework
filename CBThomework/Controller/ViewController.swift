//
//  ViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
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
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    
        //CALENDAR
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        calendar.locale = Locale(identifier: "id")
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.selectionColor = #colorLiteral(red: 0, green: 0.7300438285, blue: 0.9550673366, alpha: 1)
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        
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
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
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
            cell.label.font = UIFont.boldSystemFont(ofSize: 18)
            cell.timestampLabel.text = activities[indexPath.row].date
            cell.selectionStyle = .none
            cell.aktivitasView.dropShadow()
            cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            
            cell.frekuensiLabel.text = "Progress:\(activities[indexPath.row].currentFrequency)      Total: \(activities[indexPath.row].totalFrequency)"
            
            
            return cell
            
            
        }else{
            let title = journals[indexPath.row].title
            let desc = journals[indexPath.row].descriptionText
            let timestamp = journals[indexPath.row].date
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as! JournalTableViewCell
            cell.selectionStyle = .none
            cell.journalLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.journalLabel.text = title
            cell.descriptionLabel.text = desc
            cell.timestampLabel.text = timestamp
            cell.journalView.dropShadow()
            cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BOOM"
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        let view2 = UIView()
        view2.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        
        let text1 = UILabel()
        text1.text = sectionTitle[0]
        text1.font = UIFont.boldSystemFont(ofSize: 25)
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
        text2.font = UIFont.boldSystemFont(ofSize: 25)
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
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)

        let button:UIButton = UIButton(frame: CGRect(x: 280, y: -5, width: 120, height: 40))
        button.setTitle("Lihat Semua", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2117647059, green: 0.7176470588, blue: 0.9333333333, alpha: 1), for: .normal)

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
        if section == 0 {
            return 60
        }
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 100
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



extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = 10
        
    }
}
