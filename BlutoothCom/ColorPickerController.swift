//
//  ColorPickerController.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ColorPickerController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let colorCellId = "colorCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(ColorCell.self, forCellWithReuseIdentifier: colorCellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellId, for: indexPath) as! ColorCell
        
        cell.colorView.backgroundColor = Constants.colors[indexPath.item]
        
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
        userData.colorId = indexPath.item
        userData.save()
        navigationController?.popViewController(animated: true)
    }
    
}

