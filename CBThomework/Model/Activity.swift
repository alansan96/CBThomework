//
//  Activity.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Activity : Object{
    
   @objc dynamic var title : String = ""
   @objc dynamic var ulangi : Int = 0
   @objc dynamic var peringatan : Int = 0
   @objc dynamic var perasaanBefore : Int = 0
   @objc dynamic var perasaanSesudah : Int = 0
   @objc dynamic var date : String = ""
    @objc dynamic var note : String = ""
    
  
}
