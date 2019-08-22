//
//  ViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var activities : [Activity] = []
    var journals : [Journal] = []
    var sectionTitle : [String] = ["Activity", "Journal"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activities = createActivities()
        journals = createJournal()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
    
    func createActivities() -> [Activity] {
        var tempActivities : [Activity] = []
        
        var  act1 = Activity(title: "makan")
        var  act2 = Activity(title: "makan2")
        var  act3 = Activity(title: "makan3")
        
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)

        
        return tempActivities

    }
    
    func createJournal() -> [Journal] {
        var tempActivities : [Journal] = []
        
        var  act1 = Journal(title: "journal")
        var  act2 = Journal(title: "journal2")
        var  act3 = Journal(title: "journal3")
        
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)
        tempActivities.append(act1)
        tempActivities.append(act2)
        tempActivities.append(act3)



        return tempActivities
        
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activities.count
            
        }
        
        return journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let activity = activities[indexPath.row]
        
        if indexPath.section == 0 {
            let name = activities[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! FirstTableViewCell
            cell.setActivity(activity: name)
            return cell

            
        }else{
            let name = journals[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as! JournalTableViewCell
            cell.setJournal(journal: name)
            return cell
        }
        

        return UITableViewCell()
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BOOM"
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray

        let view2 = UIView()
        view2.backgroundColor = .gray

        
        let text1 = UILabel()
        text1.text = sectionTitle[0]
        text1.frame =  CGRect(x:20, y: 0, width: 100, height: 35)
        
        let seeAllLabel = UILabel()
        seeAllLabel.text = "See All"
        seeAllLabel.frame =  CGRect(x: 330, y: 0, width: 100, height: 35)
        
        let text2 = UILabel()
        text2.text = sectionTitle[1]
        text2.frame =  CGRect(x:20, y: 0, width: 100, height: 35)
        
        view.addSubview(text1)
        view.addSubview(seeAllLabel)
        
        view2.addSubview(text2)
        
        if section == 0 {
            return view
        }

        
        return view2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 200
    }

}
