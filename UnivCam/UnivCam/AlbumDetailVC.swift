//
//  AlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDetailVC: UIViewController {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = album?.title
        }
    }
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(Cells.photo.nib,
                                    forCellWithReuseIdentifier: Cells.photo.identifier)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
        }
    }
    
    @IBOutlet var deletePhotoButton: UIBarButtonItem! {
        didSet {
            deletePhotoButton.target = self
            deletePhotoButton.action = #selector(deleteImages)
        }
    }
    
    @IBOutlet var moreButton: UIBarButtonItem! {
        didSet {
            moreButton.target = self
            moreButton.action = #selector(deleteImages)
        }
    }
    
    lazy var backButton : UIButton = {
        let btn : UIButton = .init(type: .system)
        btn.setImage(
            Assets.leftNavigationItem.image,
            for: .normal)
        btn.setTitle("  뒤로가기", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(unwindToHome), for: .touchUpInside)
        return btn
    }()
    
    var photos = [UIImage]()
    var selectedPhotos = [UIImage]()
    var _selectedCells : NSMutableArray = []
    var album : Album?
    
    override func viewWillAppear(_ animated: Bool) {
        guard let dirPath = album?.url,
            let files = try? FileManager.default.contentsOfDirectory(atPath: dirPath) else { return }
        for filename in files {
            // 파일 확장자 png 체크
            print("no")
            let suffixIndex = filename.index(filename.endIndex, offsetBy: -3)
            _ = filename.substring(from: suffixIndex)
            //if suffix == "png" {
                let imageURL = dirPath + "/" + filename
                photos.append(UIImage(named: imageURL)!)
            //}
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func deleteImages() {
        var indexPaths = [IndexPath]()
        //let fileManager = FileManager.default
        for indexPath in _selectedCells {
            guard let indexPath = indexPath as? IndexPath else { return }
            photos.remove(at: indexPath.row)
            indexPaths.append(indexPath)
        }
        
        collectionView.deleteItems(at: indexPaths)
        collectionView.reloadData()
    }
    func moreAction() {
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.photo.identifier,
                                                      for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        
        if _selectedCells.contains(indexPath) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: UICollectionViewScrollPosition.top)
            cell.backgroundColor = UIColor.lightGray
            
        }
        else {
            cell.isSelected = false
        }
        
        
        return cell
    }
    
    
    
}
extension AlbumDetailVC: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(_selectedCells)
        
        guard let nvc = ViewControllers.photo_album.instance as? PhotoAlbumVC else { return }
        nvc.photos = photos
        nvc.albumTitle = album?.title
        nvc.selectedIndex = indexPath
        nvc.selectedIndex = indexPath
        
        self.navigationController?.pushViewController(nvc, animated: true)
        
        //_selectedCells.add(indexPath)
        //collectionView.reloadItems(at: [indexPath])
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //_selectedCells.remove(indexPath)
        //collectionView.reloadItems(at: [indexPath])
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
