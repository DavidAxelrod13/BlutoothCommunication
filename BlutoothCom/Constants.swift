//
//  Constants.swift
//  BlutoothCom
//
//  Created by David on 09/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Constants {
    
    static let SERVICE_UUID = CBUUID(string: "80576447-A2F7-43CE-8D9B-CDF214DE01C1")
    static let WR_UUID = CBUUID(string: "CA4E1DD1-F80C-4759-992F-D9F94A5D5C1A")
    static let WR_PROPERTIES: CBCharacteristicProperties = .write
    static let WR_PERMISSIONS: CBAttributePermissions = .writeable
    
    static let kAvatarImagePrefix = "avatar"
    
    static let colors = [UIColor(red: 0/255, green: 102/255, blue:155/255, alpha: 1.0),
                         UIColor(red: 102/255, green: 204/255, blue:255/255, alpha: 1.0),
                         UIColor(red: 0/255, green: 153/255, blue:51/255, alpha: 1.0),
                         UIColor(red: 255/255, green: 153/255, blue:0/255, alpha: 1.0),
                         UIColor(red: 255/255, green: 51/255, blue:0/255, alpha: 1.0),
                         UIColor(red: 255/255, green: 51/255, blue:204/255, alpha: 1.0),
                         UIColor(red: 255/255, green: 255/255, blue:0/255, alpha: 1.0),
                         UIColor(red: 153/255, green: 51/255, blue:255/255, alpha: 1.0),
                         UIColor(red: 153/255, green: 102/255, blue:0/255, alpha: 1.0)]
}
