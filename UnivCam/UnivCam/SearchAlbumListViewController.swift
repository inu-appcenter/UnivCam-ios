//
//  SearchPhotoAlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class SearchAlbumListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = albumDataSource
            collectionView.delegate = self
        }
    }
    
    let albumDataSource = AlbumDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        self.extendedLayoutIncludesOpaqueBars = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumDataSource.photos = GetServices.photos(type: .big)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPhoto" {
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = albumDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoViewController
                destinationVC.photos = albumDataSource.photos
                print("e")
            }
        }
    }
    

}
extension SearchAlbumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 123, height: 123)
    }
    
}
extension SearchAlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPhoto", sender: self)
        
    }
}


