//
//  SearchPhotoAlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class SearchAlbumListViewController: UIViewController {
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
        
        // Do any additional setup after loading the view.
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
extension SearchAlbumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 123, height: 123)
    }
    
}
extension SearchAlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushPhotoSegue", sender: self)
    }
}
