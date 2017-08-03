//
//  AlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var albumDetailView: AlbumDetailView!
    
    let albumDataSource = AlbumDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.extendedLayoutIncludesOpaqueBars = true
        //albumDetailView.albumDataSource.photos = GetServices.photos(type: .big)
        //albumDetailView.collectionView.reloadData()
        //albumDetailViewHeightConstraint.constant = ((20 / 3) + 1) * 123
        //albumDetailView.collectionView.frame = CGRect(x: 0, y: 0, width: 375, height: ((20 / 3) + 1) * 123)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //albumDetailView.collectionView.dataSource = albumDataSource
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //albumDataSource.photos = GetServices.photos(type: .big)
        
        
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
//extension AlbumDetailViewController: UICollectionViewDelegate {
//    
//}
//
//extension AlbumDetailViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize{
//        
//        return CGSize(width: 123, height: 123)
//    }
//    
//}
