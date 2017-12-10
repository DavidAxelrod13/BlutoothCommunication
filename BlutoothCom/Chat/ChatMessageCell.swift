//
//  ChatCell.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            guard let message = message else { return }
            
            if message.isSent {
                // message sent
                recievedMessageLabel.isHidden = true
                sentMessageLabel.isHidden = false
                sentMessageLabel.text = message.text
                sentMessageLabel.sizeToFit()
            } else {
                // message recieved
                sentMessageLabel.isHidden = true
                recievedMessageLabel.isHidden = false
                recievedMessageLabel.text = message.text
                recievedMessageLabel.sizeToFit()
            }
        }
    }
    
    let recievedMessageLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    
    let sentMessageLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        addSubview(recievedMessageLabel)
        
        recievedMessageLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, topPadding: 0, leadingPadding: 0, bottomPadding: 0, trailingPadding: 50, width: 0, height: 0)
        
        addSubview(sentMessageLabel)
        
        sentMessageLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, topPadding: 0, leadingPadding: 50, bottomPadding: 0, trailingPadding: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
