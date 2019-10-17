//
//  PeringatanViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 24/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class PeringatanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var labels2 : [String] = ["Tidak ada", "Setiap Pagi", "Setiap Siang", "Setiap Malam", "Sepanjang Hari"]
    var delegate : peringatanProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.tableView.bounces = false
        //print
    }
    


}

extension PeringatanViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.bounces = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "peringatanCell") as! PeringatanTableViewCell
        cell.peringatanLabel.text = labels2[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        let footerChildView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        footerChildView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        view.addSubview(footerChildView)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.delegate?.setPeringatan(id: indexPath.row, valueSent: labels2[indexPath.row])
        navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    
}

protocol peringatanProtocol {
    func setPeringatan(id: Int,valueSent: String)

}
