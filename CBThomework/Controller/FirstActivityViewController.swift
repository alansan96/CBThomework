//
//  FirstActivityViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 26/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class FirstActivityViewController: UIViewController, MyProtocol, peringatanProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var labels : [String] = ["Ulangi", "Peringatan", ""]
    var details : [String] = ["Jangan Pernah", "Tidak Ada", ""]
    var details2 : [Int] = [0,0,0,0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        tableView.isScrollEnabled = false

    }
    
    @IBAction func tambahAktivitasAction(_ sender: Any) {
        let Titlecell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! FirstActivityJudulTableViewCell // judul
        
        print(Titlecell.judulKegiatanTextField.text)
        print(details2[0])
        print(details2[1])
        
        
        
        let realm = try! Realm()
        
        var  newActivity = Activity()
        newActivity.title = Titlecell.judulKegiatanTextField.text ?? ""
        newActivity.ulangi = details2[0]
        newActivity.peringatan = details2[1]
       
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:SS"
        let result = formatter.string(from: date)
        newActivity.date = result
        
        
        try! realm.write {
            realm.add(newActivity)
        }
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ulangiSegue2" {
            let secondViewController = segue.destination as! UlangiViewController
            secondViewController.delegate = self
        }
        
        if segue.identifier == "peringatanSegue2" {
            let secondViewController = segue.destination as! PeringatanViewController
            secondViewController.delegate = self
        }
    }
    
    //protocol
    func setResultOfBusinessLogic(id: Int, valueSent: String) {
        details[0] = valueSent
        details2[0] = id
        tableView.reloadData()
    }
    
    //protocol
    func setPeringatan(id: Int, valueSent: String) {
        details[1] = valueSent
        details2[1] = id
        tableView.reloadData()
    }

}


extension FirstActivityViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = UITableViewCell(style: .value1, reuseIdentifier: "activityCell")
        cell2.selectionStyle = .none
        tableView.bounces = false
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "judulKegiatanCell") as! FirstActivityJudulTableViewCell
            cell.selectionStyle = .none
            return cell
        }
       
        
        if indexPath.section == 1 {
            cell2.textLabel?.text = labels[indexPath.row]
            cell2.detailTextLabel?.text = details[indexPath.row]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 2 {
            cell2.textLabel?.text = labels[indexPath.row+1]
            cell2.detailTextLabel?.text = details[indexPath.row+1]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 1000
        }
        
        return 19
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "ulangiSegue2", sender: self)

        }
        
        if indexPath.section == 2 {
            
            self.performSegue(withIdentifier: "peringatanSegue2", sender: self)

        }
    }
    
  
    
    
}
