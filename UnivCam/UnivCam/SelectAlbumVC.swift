//
//  SelectAlbumVC.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 10..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

enum selectType {
    case single
    case multi
}

class SelectAlbumVC: UIViewController {
    
    var capturedImage : UIImage?
    var selectedImages = List<Photo>()
    @IBOutlet var selectMessageLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(Cells.album.nib, forCellWithReuseIdentifier: Cells.album.identifier)
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    var albums: Results<Album> = {
        let realm = try! Realm()
        return realm.objects(Album.self)
    }()
    
    var selectedAlbums = [Album]()
    var _selectedCells : NSMutableArray = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToCapturedVC(_ sender: UIBarButtonItem) {
        print("no")
        let vc = self.navigationController?.viewControllers[1] as! TakenPhotoVC
        self.navigationController?.popToViewController(vc, animated: true)
        
    }
    @IBAction func storeImagesToFolder(_ sender: Any) {
        
        for idx in _selectedCells {
            let indexPath = idx as! IndexPath
            let imageName = String(describing: Date())
            let imageData =  UIImageJPEGRepresentation(capturedImage!, 1.0)
            try! imageData?.write(to: URL.init(fileURLWithPath: albums[indexPath.row].url + "/\(imageName)"), options: .atomicWrite)
            
            let realm = try! Realm()
            let query = "title = '\(albums[indexPath.row].title)'"
            guard let album = realm.objects(Album.self).filter(query).first else { return }
            let photo = Photo()
            photo.url = albums[indexPath.row].url + "/\(imageName)"
            
            do {
                try realm.write {
                    album.photoCount = album.photoCount + 1
                    album.photos.append(photo)
                }
            } catch {
                print(error)
            }
            
            
        }
        self.dismiss(
            animated: true,
            completion: nil
        )
    }
    
    
}

extension SelectAlbumVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        
        cell.cameraButton.isHidden = true
        cell.titleLabel.text = album.title
        cell.favoriteButton.isHidden = true
        cell.editButton.isHidden = true
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        
        if _selectedCells.contains(indexPath) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.top)
            cell.backgroundColor = UIColor.lightGray
            cell.checkImage.isHidden = false
        }
        else{
            cell.isSelected = false
            cell.checkImage.isHidden = true
        }
        
        guard let coverImageURL = album.photos.last?.url else { return cell }
        guard let coverImageData = album.coverImageData, album.coverImageData != nil else
        {
            cell.imageView.image = UIImage(named: coverImageURL)
            return cell
        }
        cell.imageView.image = UIImage(data: coverImageData as Data)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(_selectedCells)
        _selectedCells.add(indexPath)
        collectionView.reloadItems(at: [indexPath])
        selectMessageLabel.text = "\(_selectedCells.count)개의 앨범 선택"
        print("selected")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _selectedCells.remove(indexPath)
        collectionView.reloadItems(at: [indexPath])
        if _selectedCells.count == 0 {
            selectMessageLabel.text = "앨범을 선택해주세요"
        } else {
            selectMessageLabel.text = "\(_selectedCells.count)개의 앨범 선택"
        }
        print("deselected")
    }
    
}

extension SelectAlbumVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch (DeviceUtility.knowDeviceSize()) {
        case 0:
            return CGSize(width: 148, height: 204.1)
        case 1:
            return CGSize(width: 148, height: 204.1)
        case 2:
            return CGSize(width: 175.5, height: 243)
        case 3:
            return CGSize(width: 195, height: 269)
        default:
            return CGSize(width: 175.5, height: 243)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
}
