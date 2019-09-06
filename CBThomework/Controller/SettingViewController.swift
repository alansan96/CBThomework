//
//  SettingViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 23/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var settingLabel : [String] = ["Face ID", "Notification", "Term and Condition", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.bounces = false
        tableView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    }
    
    
}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = settingLabel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingTableViewCell
        cell.settingLabel.text = name
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            let defaults = UserDefaults.standard
            let faceID = defaults.bool(forKey: "FaceID")
            if faceID == true {
                cell.settingSwitch.isOn = true
            }else {
                cell.settingSwitch.isOn = false

            }

            cell.settingSwitch.addTarget(self, action: #selector(handler), for: .valueChanged)
            
            
        }else if indexPath.row > 1 {
            // right arrow
            cell.accessoryType = .disclosureIndicator
            cell.settingSwitch.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        let footerChildView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        view.addSubview(footerChildView)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentCell = tableView.cellForRow(at: indexPath) as! SettingTableViewCell

    
    }
    
    @objc func handler(sender : UISwitch){
        let defaults = UserDefaults.standard

        if sender.isOn == true {
            print("now on")
            defaults.set(true, forKey: "FaceID")
            }else {
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "FaceID")
        }
        let faceId = defaults.bool(forKey: "FaceID")
        print(faceId)

    }
    
    
    
}

