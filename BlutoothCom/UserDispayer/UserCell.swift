//
//  UserCell.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var advertisementData: [String]? {
        didSet {
            guard let advertisementData = advertisementData else { return }
            
            nameLabel.text = advertisementData[0]
            
            if advertisementData.count > 1 {
                // not just the name of the user (may also have avatar and/or color)
                let indexOfAvatar = advertisementData[1]
                avatarImageView.image = UIImage(named: "\(Constants.kAvatarImagePrefix)\(indexOfAvatar)")
                let indexOfColor = Int(advertisementData[2])
                if let indexOfColor = indexOfColor {
                    backgroundColor = Constants.colors[indexOfColor]
                }
            }
        }
    }
    
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        
        backgroundColor = .lightGray
        
        addSubview(avatarImageView)
        
        avatarImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(nameLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
