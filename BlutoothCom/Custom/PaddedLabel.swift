//
//  PaddedLabel.swift
//  BlutoothCom
//
//  Created by David on 12/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    
    let topInset: CGFloat = 10
    let leftInset: CGFloat = 20
    let bottomInset: CGFloat = 10
    let rightInset: CGFloat = 20
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
