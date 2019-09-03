//
//  SeeAllActivityViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 25/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class SeeAllActivityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var test : [String] = ["a", " v", "c"]
    var activities : Array<Activity> = Array()
    
    var activityToSend : Activity?

    override func viewWillAppear(_ animated: Bool) {
        activities = fetchAllActivities()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)

       
        
    }
    
    func fetchAllActivities() -> Array<Activity> {
        let realm = try! Realm()
        var tempActivities = realm.objects(Activity.self).sorted(byKeyPath: "date", ascending: false)
        
        return Array(tempActivities)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivitySegue" {
            if let vc: EditActivityViewController = segue.destination as? EditActivityViewController {
                vc.fullDetailActivity = activityToSend
            }
        }
    }

    
    
}

extension SeeAllActivityViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullActivityCell") as! FullActivityTableViewCell
        cell.selectionStyle = .none
        cell.judulLabel.text = activities[indexPath.row].title
        cell.judulLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.timestampLabel.text = activities[indexPath.row].date
        cell.activityView.dropShadow()
        cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let realm = try! Realm()
        let dateIndentifier = activities[indexPath.row].date
        let tempActivity = realm.objects(Activity.self).filter("date == '\(dateIndentifier)'")
        let array = Array(tempActivity)
        activityToSend = array[0]
        print(activityToSend)
        self.performSegue(withIdentifier: "editActivitySegue", sender: self)

    }
    
    
}
