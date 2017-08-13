//
//  TutorialView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 11..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class TutorialView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            collectionView.isPagingEnabled = true
        }
        
    }

    let images : [UIImage] = [Assets.tutorial1.image, Assets.tutorial2.image, Assets.tutorial3.image]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
}
extension TutorialView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: images[indexPath.row])
        // Configure the cell
        
        return cell
    }
}

extension TutorialView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
}


