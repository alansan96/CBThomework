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
    
    var ulangiDataSource : [String] = ["Jangan Pernah", "Setiap Hari", "Setiap 2 Hari", "Setiap 3 Hari", "Setiap Minggu", "Setiap 2 Minggu"]
    var peringatanDataSource : [String] = ["Tidak ada", "Setiap Pagi", "Setiap Siang", "Setiap Malam", "Sepanjang Hari"]
    
    var fullDetailActivity : Activity?
    var fullDetailUnmanaged :Activity?
    
    
    var dataSource = ["  ", "Sedih Sekali 😔", "Sedih 😟", "Biasa Saja 😐", "Senang 🙂", "Senang Sekali 😃"]
    
    var emojiBefore : String = ""
    var boolCheck = false
    var labelSection2 : [String] = ["Ulangi"]
    var temp = "waktunya"
    
    var tempUlangi = 0
    var tempPeringatan = 0
    var tempEndDate = ""
    var daysCounter : [Int] = [0,1,2,3,7,14]

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if boolCheck == false && labelSection2.count > 1 {
            tableView.beginUpdates()
            labelSection2.remove(at: 1)
            tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            
            labelSection2.remove(at: 1)
            tableView.deleteRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)
            getDateNowFullFormat()
            tableView.endUpdates()
        }
        
        
        if fullDetailUnmanaged?.ulangi != 0 {
            boolCheck = true
        }
        
        if boolCheck == true && labelSection2.count < 2 {
            labelSection2.append("Ulangi Sampai")
            labelSection2.append("Ulangi Sampai lagi")
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            tableView.insertRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)
            tableView.endUpdates()
            temp = getDateNow()
            
            tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            
        }
        
    }
    
    func getDateNow() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM YYYY"
        formatter.locale = Locale(identifier: "id")
        let result = formatter.string(from: date)
        return result
    }
    
    func getDateNowFullFormat() {
        let dateFromatter2 = DateFormatter()
        dateFromatter2.dateFormat = "dd.MM.yyyy hh:mm:ss"
        tempEndDate = dateFromatter2.string(from: Date.init())
        print(tempEndDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        tableView.bounces = false
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        fullDetailUnmanaged = Activity(value: fullDetailActivity)
        tempUlangi = fullDetailUnmanaged?.ulangi ?? 0
        tempPeringatan = fullDetailUnmanaged?.peringatan ?? 0
        
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "dd.MM.YYYY hh:mm:ss"

        
        tempEndDate = dateFromatter.string(from: Date.init())
        

    }
    
    //UBAH DETAIL KLIKED
    @IBAction func tambahAction(_ sender: UIBarButtonItem) {
        let Titlecell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! NewActivity1TableViewCell // judul
        
        let CatatanCell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 5)) as! NewActivity2TableViewCell // judul
   
        
        let realm = try! Realm()
        //FREQUENCY
        let startDateString = String((fullDetailUnmanaged?.date.prefix(10))!)
        var endDateString = String((fullDetailUnmanaged?.endDate.prefix(10))!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        
        if fullDetailUnmanaged?.ulangi == 0 {
            endDateString = startDateString
            
        }
        guard let startDate = dateFormatter.date(from: startDateString) else {
            fatalError()
        }
        
        guard let endDate = dateFormatter.date(from: endDateString) else {
            fatalError()
        }
        print("progress :\(startDate)   |    Total:  \(endDate)")
        
        let calendar = Calendar.current
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day! + 1
        //print(numberOfDays)
        
        //GET EVERY NUMBER OF DAYS
        let everyNumDays = fullDetailUnmanaged?.ulangi
        var total = 1
        if daysCounter[everyNumDays!] != 0 {
            total = calculateTotalFrequency(totalHari: numberOfDays, setiap: daysCounter[everyNumDays!])
        }
        
        // COUNTER FREQUENCY ACTIVITY
        var currentProgress = fullDetailUnmanaged?.currentFrequency
        print("progress :\(currentProgress)   |    Total:  \(total)")
        
        fullDetailUnmanaged?.totalFrequency = total
        
        //UPDATE DATA
        let alert = UIAlertController(title: "Anda Yakin?", message: "Tindakan ini akan mengubah aktivitas anda", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: { ACTION in
            print("cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { ACTION in
            try! realm.write({
                self.fullDetailActivity?.title = Titlecell.titleTextField.text!
                let note = (CatatanCell.catatanTextView.text == "Catatan") ? "" : CatatanCell.catatanTextView.text
                self.fullDetailActivity?.note = note ?? ""
                self.fullDetailActivity?.ulangi = self.tempUlangi
                self.fullDetailActivity?.peringatan = self.fullDetailUnmanaged?.peringatan ?? 0
                self.fullDetailActivity?.perasaanSesudah = self.fullDetailUnmanaged?.perasaanSesudah ?? 0
                self.fullDetailActivity?.perasaanBefore = self.fullDetailUnmanaged?.perasaanBefore ?? 0
                self.fullDetailActivity?.endDate = self.tempEndDate
                self.fullDetailActivity?.totalFrequency = self.fullDetailUnmanaged?.totalFrequency ?? 0
            })
            self.navigationController?.popViewController(animated: true)

        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func calculateTotalFrequency(totalHari : Int, setiap : Int) -> Int{
        var result = 0
        var totalHariSen = totalHari - 1
        result = ((totalHariSen+setiap) - ((totalHariSen + setiap) % setiap )) / setiap
        
        return result
    }
    
    //protocol
    func setPeringatan(id: Int, valueSent: String) {
        fullDetailUnmanaged?.peringatan = id
        tempPeringatan = id
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }
    
    //protocol
    func setResultOfBusinessLogic(id: Int, valueSent: String, isNever: Bool) {
        boolCheck = isNever
        fullDetailUnmanaged?.ulangi = id
        tempUlangi = id
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func selesaiAction(_ sender: Any) {
        
    }
    
    @IBAction func hapusAction(_ sender: Any) {
        
    }
    
    
    //PICKER VIEW EMOJI
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
    
}


extension EditActivityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2,3,4,5,6,7:
            return 1
        case 1:
            return labelSection2.count
        default:
            return 0
        }
    }
    
    @objc func handler(sender: UIDatePicker){

        
        let dateFromatter = DateFormatter()
        let index = IndexPath(item: 1, section: 1)
        tableView.reloadRows(at: [index], with: .automatic)
        dateFromatter.dateFormat = "E, dd MMM YYYY"
        
        dateFromatter.locale = Locale(identifier: "id")
        print(dateFromatter.string(from: sender.date))
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
        let cellPicker2 = tableView.dequeueReusableCell(withIdentifier: "pickerCell2") as! PickerEditActivityTableViewCell
        cell2.selectionStyle = .none
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell2") as! NewActivity1TableViewCell
            cell.titleTextField.text = fullDetailActivity?.title
            return cell
            
        }
        if indexPath.section == 1{
            if indexPath.row == 0 {
                cell2.textLabel?.text = randoms[indexPath.row]
                cell2.detailTextLabel?.text = ulangiDataSource[(fullDetailUnmanaged?.ulangi)!]

            }else if indexPath.row == 1 {
                cell2.detailTextLabel?.text = temp
                cell2.textLabel?.text = "Tanggal Berakhir"
            }else if indexPath.row == 2 {
                cellPicker2.pickerView.datePickerMode = .date
                cellPicker2.pickerView.minimumDate = Date.init()
                cellPicker2.pickerView.locale = Locale(identifier: "id")
                cellPicker2.pickerView.addTarget(self, action: #selector(handler), for: .valueChanged)
                return cellPicker2
            }
            
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        if indexPath.section == 2{
            cell2.textLabel?.text = randoms[indexPath.row+1]
            cell2.detailTextLabel?.text = peringatanDataSource[(fullDetailUnmanaged?.peringatan)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 3{
            cell2.textLabel?.text = randoms[indexPath.row+2]
            cell2.detailTextLabel?.text = dataSource[(fullDetailUnmanaged?.perasaanBefore)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 4{
            cell2.textLabel?.text = randoms[indexPath.row+3]
            cell2.detailTextLabel?.text = dataSource[(fullDetailUnmanaged?.perasaanSesudah)!]
            cell2.accessoryType = .disclosureIndicator
            return cell2
            
        }
        
        if indexPath.section == 5{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "activityCell3") as! NewActivity2TableViewCell
            if fullDetailActivity?.note == "" {
                cell3.catatanTextView.delegate = self
                cell3.catatanTextView.text = "Catatan"
                cell3.catatanTextView.textColor = UIColor.lightGray
            }else {
                cell3.catatanTextView.text = fullDetailActivity?.note

            }
            return cell3
            
        }
        
        if indexPath.section == 6{
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "selesaiCell") as! SelesaiTableViewCell
            cell5.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell5.selectionStyle = .none
            cell5.selesaiButton.addTarget(self, action: #selector(selesaiClicked), for: .touchUpInside)
            
            if fullDetailActivity!.currentFrequency == fullDetailActivity!.totalFrequency{
                cell5.selesaiButton.isEnabled = false
                cell5.selesaiButton.backgroundColor = .gray
                //print("masuk")
            }
            return cell5
        }
        
        if indexPath.section == 7{
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "hapusCell") as! HapusTableViewCell
            cell5.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            cell5.selectionStyle = .none
            cell5.hapusButton.addTarget(self, action: #selector(hapusClicked), for: .touchUpInside)
            return cell5
        }
        
        
        return UITableViewCell()
        
    }
    
    @objc func selesaiClicked(sender: UIButton){
        let realm = try! Realm()
        
        try! realm.write({
            fullDetailActivity?.currentFrequency += 1
        })
        
        
        print(fullDetailActivity?.currentFrequency)
        print("\(fullDetailActivity?.totalFrequency)")
        
        
        
    }
    
    @objc func hapusClicked(){
        print("testing hapus")
        //alert hapus
        let alert = UIAlertController(title: "Anda Yakin?", message: "Tindakan ini akan menghapus aktivitas yang anda pilih", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.default, handler: { ACTION in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { ACTION in
            let realm = try! Realm()
            print(self.fullDetailActivity?.date)
            let items = realm.objects(Activity.self).filter("date = '\(self.fullDetailActivity?.date ?? "")'")
            print(items)
            try! realm.write {
                realm.delete(items)
            }
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
        
       
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                return 200
            }
        }

        if indexPath.section < 5 {
            return 44
        }else if indexPath.section == 5 {
            return 162
        }else if indexPath.section > 5{
            return 51

        }else{
            return 70
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 8 {
            return 500
        }
        return 19
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            self.performSegue(withIdentifier: "ulangiSegue", sender: self)
            
        }
        if indexPath.section == 2  {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        return view
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
        
        if pickerView == beforePickerView {
            fullDetailUnmanaged?.perasaanBefore = row
        } else {
            fullDetailUnmanaged?.perasaanSesudah = row
        }
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}
