//
//  UlangiViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 24/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit

class UlangiViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var labels : [String] = ["Jangan Pernah", "Setiap Hari", "Setiap 2 Hari", "Setiap 3 Hari", "Setiap Minggu", "Setiap 2 Minggu"]
    
      var delegate:MyProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        //self.tableView.bounces = false
    }
    

    
}

extension UlangiViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.bounces = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "ulangiCell") as! UlangiTableViewCell
        cell.ulangiLabel.text = labels[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.9607843137, alpha: 1)
        let footerChildView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        footerChildView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.937254902, blue: 0.9607843137, alpha: 1)
        view.addSubview(footerChildView)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.delegate?.setResultOfBusinessLogic(id: indexPath.row, valueSent: labels[indexPath.row])

        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}

protocol MyProtocol {
    func setResultOfBusinessLogic(id: Int, valueSent: String)
}

