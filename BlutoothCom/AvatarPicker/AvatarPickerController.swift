//
//  AvatarPickerController.swift
//  BlutoothCom
//
//  Created by David on 10/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class AvatarPickerController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let avatarCellId = "avatarCellId"
    let avatarNumber = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(AvatarCell.self, forCellWithReuseIdentifier: avatarCellId)
        collectionView?.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: avatarCellId, for: indexPath) as! AvatarCell
        
        cell.avatarImageView.image = UIImage(named: "\(Constants.kAvatarImagePrefix)\(indexPath.item + 1)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 3) - 4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var userData = UserData()
        userData.avatarId = indexPath.item + 1
        userData.save()
        
        navigationController?.popViewController(animated: true)
        
    }
}


