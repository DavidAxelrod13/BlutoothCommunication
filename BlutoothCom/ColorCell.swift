//
//  ColorCell.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        colorView.layer.cornerRadius = (self.frame.width / 2)
        
        addSubview(colorView)
        
        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

