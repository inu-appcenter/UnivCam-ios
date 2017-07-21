//
//  AlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let albumDataSource = AlbumDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        self.extendedLayoutIncludesOpaqueBars = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = albumDataSource
        collectionView.delegate = self
        albumDataSource.photos = GetServices.photos(type: .big)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icNavigateNext2X"), for: .normal)
        button.setTitle("  뒤로가기", for: .normal)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        button.addTarget(self, action: #selector(unwindToHome), for: .touchUpInside)
        
        
        
    }
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
extension AlbumViewController: UICollectionViewDelegate {
    
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 123, height: 123)
    }
    
}

class AlbumDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [UIImage]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumCollectionViewCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderCell", for: indexPath as IndexPath)
        return headerView
    }
}
