//
//  UserData.swift
//  BlutoothCom
//
//  Created by David on 10/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

struct UserData {
    
    private let userDatakey = "userData"
    
    var name: String = ""
    var avatarId: Int = 0
    var colorId:Int = 0
    
    var hasAllDataFilled: Bool {
        return !name.isEmpty && avatarId > 0
    }
    
    public init() {
        if let dictionary = UserDefaults.standard.dictionary(forKey: userDatakey) {
            
            name = dictionary["name"] as? String ?? ""
            avatarId = dictionary["avatarId"] as? Int ?? 0
            colorId = dictionary["colorId"] as? Int ?? 0
        }
    }
    
    public func save() {
        
        var dictionary: Dictionary = [String : Any]()
        dictionary["name"] = name
        dictionary["avatarId"] = avatarId
        dictionary["colorId"] = colorId
        
        UserDefaults.standard.set(dictionary, forKey: userDatakey)
    }
}























