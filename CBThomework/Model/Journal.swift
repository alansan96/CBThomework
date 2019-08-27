//
//  Journal.swift
//  CBThomework
//
//  Created by Alan Santoso on 22/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Journal : Object{
    
    @objc dynamic var title : String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var date : String = ""

}
