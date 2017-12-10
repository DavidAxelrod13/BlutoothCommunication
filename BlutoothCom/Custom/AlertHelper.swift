//
//  AlertHelper.swift
//  BlutoothCom
//
//  Created by David on 10/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class AlertHelper {
    class func warn(title: String, message: String) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(okAction)
        return ac
    }
}
