//
//  TutorialView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 11..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            collectionView.isPagingEnabled = true
        }
        
    }
    let nibName = "TutorialView"
    var view : UIView!
    let images : [UIImage] = [UIImage(named:"1")!,UIImage(named:"2")!,UIImage(named:"3")!]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    func loadViewFromNib() ->UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        addSubview(view)
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


