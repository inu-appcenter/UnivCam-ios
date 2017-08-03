//
//  PhotoViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = photoDataSource
            collectionView.delegate = self
        }
    }
    @IBOutlet var thumbnailCollectionView: UICollectionView! {
        didSet {
            thumbnailCollectionView.dataSource = photoDataSource
            thumbnailCollectionView.delegate = self
        }
    }
    
    let photoDataSource = PhotoDataSource()
    let albumDataSource = PhotoDataSource()
    var photos = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        albumDataSource.photos = photos
//        collectionView.reloadData()
//        print(albumDataSource.photos)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumDataSource.photos = GetServices.photos(type: .big)
        photoDataSource.photos = GetServices.photos(type: .big)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icNavigateNext2X"), for: .normal)
        button.setTitle("  뒤로가기", for: .normal)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        button.addTarget(self, action: #selector(unwindToAlbum), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func unwindToAlbum() {
//        if let vc = self.navigationController?.viewControllers[1] {
//            self.navigationController?.popToViewController(vc, animated: true)
//        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if collectionView == thumbnailCollectionView {
            return CGSize(width: 58, height: 58)
        }
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 71.5)
    }
    
}
