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
    var labels : [String] = ["Ulangi", "Tanggal Berakhir", "Peringatan", ""]
    var details : [String] = ["Jangan Pernah", "Tidak Ada", "Tidak Ada"]
    var details2 : [Int] = [0,0,0,0]
    var temp = ""
    var tempEndDate = ""
    var newLabel : [String] = ["Ulangi"]
    
    var boolCheck = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        if boolCheck == false && newLabel.count > 1 {
            tableView.beginUpdates()
            newLabel.remove(at: 1)
            tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)

            newLabel.remove(at: 1)
            tableView.deleteRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)

            tableView.endUpdates()
        }
        
        if boolCheck == true && newLabel.count < 2 {
            newLabel.append("Tanggal Berakhir")
            newLabel.append("Ulangi Sampai lagi")
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            tableView.insertRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)
            tableView.endUpdates()
            temp = getDateNow()
            tempEndDate = getDateNow()
            tableView.reloadData()
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        tableView.isScrollEnabled = false
        
    }
    
    @IBAction func tambahAktivitasAction(_ sender: Any) {
        let Titlecell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! FirstActivityJudulTableViewCell // judul
        let realm = try! Realm()
        
        let newActivity = Activity()
        newActivity.title = Titlecell.judulKegiatanTextField.text ?? ""
        newActivity.ulangi = details2[0]
        newActivity.peringatan = details2[2]
        newActivity.endDate = tempEndDate
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
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
    func setResultOfBusinessLogic(id: Int, valueSent: String, isNever: Bool) {
        details[0] = valueSent
        details2[0] = id
        boolCheck = isNever
        tableView.reloadData()
    }
    
    //protocol
    func setPeringatan(id: Int, valueSent: String) {
        details[2] = valueSent
        details2[2] = id
        tableView.reloadData()
    }
    
    func getDateNow() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM YYYY"
        formatter.locale = Locale(identifier: "id")
        let result = formatter.string(from: date)
        return result
    }
    
}


extension FirstActivityViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return newLabel.count
        }
        return 1
    }
    
    @objc func handler(sender: UIDatePicker){
        
        let dateFromatter = DateFormatter()
        let index = IndexPath(item: 1, section: 1)
        tableView.reloadRows(at: [index], with: .automatic)
        dateFromatter.dateFormat = "E, dd MMM YYYY"
      
        dateFromatter.locale = Locale(identifier: "id")
        print("\(dateFromatter.string(from: sender.date))")
        temp = dateFromatter.string(from: sender.date)
        tableView.reloadRows(at: [index], with: .automatic)

        //reload rows
        let dateFromatter2 = DateFormatter()
        dateFromatter2.dateFormat = "dd.MM.yyyy hh:mm:ss"
        tempEndDate = dateFromatter2.string(from: sender.date)
        print(tempEndDate)

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = UITableViewCell(style: .value1, reuseIdentifier: "activityCell")
        let cellPicker = tableView.dequeueReusableCell(withIdentifier: "cellPicker") as! PickerTableViewCell
        
        cell2.selectionStyle = .none
        tableView.bounces = false
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "judulKegiatanCell") as! FirstActivityJudulTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        
        
        if indexPath.section == 1 {
            cell2.textLabel?.text = newLabel[indexPath.row]
            if indexPath.row == 0 {
                cell2.detailTextLabel?.text = details[indexPath.row]
            }else if indexPath.row == 1 {
                cell2.detailTextLabel?.text = temp
                
            }else if indexPath.row == 2 {
               
                cellPicker.pickerViewOutlet.datePickerMode = .date
                cellPicker.pickerViewOutlet.locale = Locale(identifier: "id")
                cellPicker.pickerViewOutlet.minimumDate = Date.init()
                cellPicker.pickerViewOutlet.addTarget(self, action: #selector(handler), for: .valueChanged)
                return cellPicker
            }
            
            
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        
        if indexPath.section == 2 {
            cell2.textLabel?.text = labels[indexPath.row+2]
            cell2.detailTextLabel?.text = details[indexPath.row+2]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                return 200
            }
        }
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
        if indexPath.section == 1 && indexPath.row == 0 {
            
            self.performSegue(withIdentifier: "ulangiSegue2", sender: self)
        }
        
        if indexPath.section == 2 {
            
            self.performSegue(withIdentifier: "peringatanSegue2", sender: self)
            
        }
    }
    
    
    
    
}
