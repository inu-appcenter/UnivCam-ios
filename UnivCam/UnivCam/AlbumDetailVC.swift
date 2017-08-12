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
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
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
    
    var photos = [UIImage]()
    var dirPath : String?
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
//        let dirPath = UnivCamAPI.baseURL() + "/" + dirName
        
        
        guard let dirPath = dirPath else { return }
        
        if let files = try! FileManager.default.contentsOfDirectory(atPath: dirPath) as? [String] {
            for filename in files {
                print(filename)
                let imageURL = dirPath + "/" + filename
                photos.append(UIImage(named: imageURL)!)
            }
        }
        
//        print(RealmHelper.objectsFromQuery(data: Album(), query: ""))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension AlbumDetailVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        //cell.backgroundColor = UIColor.brown
        //cell.backgroundColor = UIColor(patternImage: photo)
        
        return cell
    }
    
}
extension AlbumDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoVC
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
