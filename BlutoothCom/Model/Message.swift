//
//  Message.swift
//  BlutoothCom
//
//  Created by David on 10/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

struct Message {
    var text: String
    var isSent: Bool
    
    init(text: String, isSent: Bool) {
        self.text = text
        self.isSent = isSent
    }
}
