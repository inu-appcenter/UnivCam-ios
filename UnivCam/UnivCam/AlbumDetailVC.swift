//
//  AlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDetailVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            collectionView.dataSource = photoDataSource
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    
    lazy var backButton : UIButton = {
        let btn : UIButton = .init(type: .system)
        btn.setImage(UIImage(named: "icNavigateNext2X"), for: .normal)
        btn.setTitle("  뒤로가기", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(unwindToHome), for: .touchUpInside)
        return btn
    }()
    
    let photoDataSource = PhotoDataSource()
    var photos = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.extendedLayoutIncludesOpaqueBars = true
        //albumDetailView.albumDataSource.photos = GetServices.photos(type: .big)
        //albumDetailView.collectionView.reloadData()
        //albumDetailViewHeightConstraint.constant = ((20 / 3) + 1) * 123
        //albumDetailView.collectionView.frame = CGRect(x: 0, y: 0, width: 375, height: ((20 / 3) + 1) * 123)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = GetServices.photos(type: .big)
        photoDataSource.photos = photos
        
        
    }
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
extension AlbumDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        
        nvc.photos = photos
        
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}

extension AlbumDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 123, height: 123)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
