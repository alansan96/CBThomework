//
//  EditActivityViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 24/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import RealmSwift

class EditActivityViewController: UIViewController , UITextViewDelegate, MyProtocol, peringatanProtocol {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var beforePickerView: UIPickerView!
    var afterPickerView: UIPickerView!
    
    var randoms : [String] = ["Ulangi", "Peringatan", "Perasaan Sebelum Aktivitas", "Perasaan Sesudah Aktivitas"]
    var details : [String] = ["Jangan Pernah", "Tidak Ada", "", ""]
    var details2 : [Int] = [0,0,0,0]
    
    var ulangiDataSource : [String] = ["Jangan Pernah", "Setiap Hari", "Setiap 2 Hari", "Setiap 3 Hari", "Setiap Minggu", ""]
    var peringatanDataSource : [String] = ["Tidak ada", "Setiap Pagi", "Setiap Siang", "Setiap Malam", "Sepanjang Hari"]
    
    var fullDetailActivity : Activity?
    
    
    var dataSource = ["  ", "Sedih Sekali 😔", "Sedih 😟", "Biasa Saja 😐", "Senang 🙂", "Senang Sekali 😃"]
    
    var emojiBefore : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        tableView.bounces = false
        
       
    }
    
    @IBAction func tambahAction(_ sender: UIBarButtonItem) {
        let Titlecell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! NewActivity1TableViewCell // judul
        
        let CatatanCell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 5)) as! NewActivity2TableViewCell // judul
        
        
        print(Titlecell.titleTextField.text)
        print(details[0])
        print(details[1])
        print(CatatanCell.catatanTextView.text)
        
        let realm = try! Realm()
        
        try! realm.write({
            fullDetailActivity?.title = Titlecell.titleTextField.text!
            fullDetailActivity?.note = CatatanCell.catatanTextView.text
        })
        
        
    }
    
    
    
    
    func blurredPickerView() {
        let blurredBackground = UIVisualEffectView()
        blurredBackground.frame =  view.frame
        blurredBackground.backgroundColor = .gray
        blurredBackground.layer.opacity = 0.5
        blurredBackground.layer.opacity = 0.5
        blurredBackground.effect = UIBlurEffect(style: .light)
        blurredBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(removeBlurredPickerView)))
        
        view.addSubview(blurredBackground)
        
    }
    
    func createPickerView() -> UIPickerView {
        let pickerViews = UIPickerView(frame: CGRect(x: view.frame.minX, y: view.frame.midY - 75, width: view.frame.width, height: 150))
        //print("aaa")
        pickerViews.backgroundColor = UIColor.white
        pickerViews.dataSource = self
        pickerViews.delegate = self
        
        view.addSubview(pickerViews)
        view.bringSubviewToFront(pickerViews)
        
        return pickerViews
    }
    
    @objc func removeBlurredPickerView(_ gesture : UITapGestureRecognizer){
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) || subview.isKind(of: UIPickerView.self){
                subview.removeFromSuperview()
                
            }
        }
    }
    
    
    //protocol
    func setPeringatan(id: Int, valueSent: String) {
        details[1] = valueSent
        details2[1] = id
        
        let realm = try! Realm()
        try! realm.write({
            fullDetailActivity?.peringatan = id
        })
        
        tableView.reloadData()
    }
    
    //protocol
    func setResultOfBusinessLogic(id: Int, valueSent: String) {
        details[0] = valueSent
        details2[1] = id
        
        let realm = try! Realm()
        try! realm.write({
            fullDetailActivity?.ulangi = id
        })
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ulangiSegue" {
            let secondViewController = segue.destination as! UlangiViewController
            secondViewController.delegate = self
        }
        
        if segue.identifier == "peringatanSegue" {
            let secondViewController = segue.destination as! PeringatanViewController
            secondViewController.delegate = self
        }
    }
    
}


extension EditActivityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,2,3,4,5:
            return 1
        default:
            return 0
        }
        return randoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = UITableViewCell(style: .value1, reuseIdentifier: "activityCell")
        cell2.selectionStyle = .none
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell2") as! NewActivity1TableViewCell
            cell.titleTextField.text = fullDetailActivity?.title
            return cell
            
        }
        if indexPath.section == 1{
            cell2.textLabel?.text = randoms[indexPath.row]
            cell2.detailTextLabel?.text = ulangiDataSource[(fullDetailActivity?.ulangi)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        if indexPath.section == 2{
            cell2.textLabel?.text = randoms[indexPath.row+1]
            cell2.detailTextLabel?.text = ulangiDataSource[(fullDetailActivity?.peringatan)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 3{
            cell2.textLabel?.text = randoms[indexPath.row+2]
            cell2.detailTextLabel?.text = dataSource[(fullDetailActivity?.perasaanBefore)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 4{
            cell2.textLabel?.text = randoms[indexPath.row+3]
            cell2.detailTextLabel?.text = dataSource[(fullDetailActivity?.perasaanSesudah)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 5{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "activityCell3") as! NewActivity2TableViewCell
            cell3.catatanTextView.text = "Catatan"
            tableView.separatorStyle = .none
            return cell3
            
        }
        
        
        return UITableViewCell()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < 4 {
            return 44
        }
        if indexPath.section > 4 {
            return 162
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 6 {
            return 400
        }
        return 19
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "ulangiSegue", sender: self)
            
        }
        if indexPath.section == 2 {
            self.performSegue(withIdentifier: "peringatanSegue", sender: self)
            
        }
        if indexPath.section == 3 {
            blurredPickerView()
            beforePickerView = createPickerView()
            
            
        }
        if indexPath.section == 4 {
            blurredPickerView()
            afterPickerView = createPickerView()
            
        }
        
        
    }
    
    
}

extension EditActivityViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let realm = try! Realm()
        let temp = dataSource[row]
        let temp2 = temp.last
        
        if pickerView == beforePickerView {
            try! realm.write({
                fullDetailActivity?.perasaanBefore = row
            })
        } else {
            try! realm.write({
                fullDetailActivity?.perasaanSesudah = row
            })
        }
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}
