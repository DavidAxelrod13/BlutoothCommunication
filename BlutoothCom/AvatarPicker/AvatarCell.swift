//
//  AvatarCell.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        addSubview(avatarImageView)
        
        avatarImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
