//
//  Device.swift
//  BlutoothCom
//
//  Created by David on 10/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {
    
    var peripheral: CBPeripheral
    var name: String
    var message = [String]()
    
    init(peripheral: CBPeripheral, name: String) {
        self.peripheral = peripheral
        self.name = name
    }
    
}
