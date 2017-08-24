//
//  AlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

enum actionTitle : String {
    case select_multi = "사진 선택하기"
    case select_delete = "사진 삭제하기"
    case select_share = "사진 공유하기"
    case cancel = "취소"
    case move = "선택사진 이동"
    case copy = "선택사진 복사"
    case share = "선택사진 공유"
    case delete = "선택사진 삭제"
}

class AlbumDetailVC: UIViewController {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = album?.title
        }
    }
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = false
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
            moreButton.action = #selector(moreAction)
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
    var photoUrls = [String]()
    var album : Album?
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dirPath = album?.url,
            let files = try? FileManager.default.contentsOfDirectory(atPath: dirPath) else { return }
        for filename in files {
            // 파일 확장자 png 체크
            print("no")
            let suffixIndex = filename.index(filename.endIndex, offsetBy: -3)
            _ = filename.substring(from: suffixIndex)
            //if suffix == "png" {
            let imageURL = dirPath + "/" + filename
            photoUrls.append(imageURL)
            photos.append(UIImage(named: imageURL)!)
            //}
        }
    }
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func deleteImages() {
        var indexPaths = [IndexPath]()
        //let fileManager = FileManager.default
        for indexPath in _selectedCells {
            guard let indexPath = indexPath as? IndexPath else { return }
            let realm = try! Realm()
            do {
//                try realm.write {
//                    let deletePhoto : Photo
//                    deletePhoto = (self.album?.photos.filter("url = \"\(photoUrls[indexPath.row])\"").first)!
//                    realm.delete(deletePhoto)
//
////                    self.album?.photoCount = (album?.photoCount)! - 1
//                    indexPaths.append(indexPath)
//                }
            }
            catch {
                
            }
        }
        collectionView.deleteItems(at: indexPaths)
        collectionView.reloadData()
    }
    func moreAction() {
        if collectionView.allowsMultipleSelection == false {
            
            let moreActionView = UIAlertController()
            let multiSelect = UIAlertAction(title: actionTitle.select_multi.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.backButton.isHidden = true
                self.moreButton.image = UIImage(named: "icDone2X")
            })
            let multiDelete = UIAlertAction(title: actionTitle.select_delete.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.backButton.isHidden = true
                self.deleteImages()
                self.moreButton.image = UIImage(named: "icDone2X")
            })
            let multiShare = UIAlertAction(title: actionTitle.select_share.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.backButton.isHidden = true
                self.moreButton.image = UIImage(named: "icDone2X")
            })
            let cancelAction = UIAlertAction(title: actionTitle.cancel.rawValue, style: .cancel, handler: { (action)->Void in
            })
            moreActionView.addAction(multiSelect)
            moreActionView.addAction(multiDelete)
            moreActionView.addAction(multiShare)
            moreActionView.addAction(cancelAction)
            moreActionView.view.tintColor = UIColor(hex: 0x515859)
            self.present(moreActionView, animated: true, completion: nil)
        }
        else {
            
            let moreActionView = UIAlertController()
            let move = UIAlertAction(title: actionTitle.move.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.backButton.isHidden = false
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let delete = UIAlertAction(title: actionTitle.delete.rawValue, style: .default, handler: { (action)->Void in
                self.deleteImages()
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.backButton.isHidden = false
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let copy = UIAlertAction(title: actionTitle.copy.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.backButton.isHidden = false
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let share = UIAlertAction(title: actionTitle.share.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.backButton.isHidden = false
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let cancelAction = UIAlertAction(title: actionTitle.cancel.rawValue, style: .cancel, handler: { (action)->Void in
            })
            moreActionView.addAction(move)
            moreActionView.addAction(delete)
            moreActionView.addAction(copy)
            moreActionView.addAction(share)
            moreActionView.addAction(cancelAction)
            moreActionView.view.tintColor = UIColor(hex: 0x515859)
            self.present(moreActionView, animated: true, completion: nil)
        }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.photo.identifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        cell.is_selected = false
        cell.checkedImage.isHidden = true
        //        if _selectedCells.contains(indexPath) {
        //            cell.isSelected = true
        //            collectionView.selectItem(at: indexPath,
        //                                      animated: true,
        //                                      scrollPosition: UICollectionViewScrollPosition.top)
        //            cell.backgroundColor = UIColor.lightGray
        //
        //        }
        //        else {
        //            cell.isSelected = false
        //        }
        if _selectedCells.contains(indexPath) {
            cell.translucentView.backgroundColor = UIColor.lightGray
            cell.is_selected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.top)
            cell.checkedImage.isHidden = false
        }
        else{
            cell.translucentView.backgroundColor = UIColor.clear
            cell.is_selected = false
            cell.checkedImage.isHidden = true
        }
        return cell
    }
    
    
    
}
extension AlbumDetailVC: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(_selectedCells)
        if self.collectionView.allowsMultipleSelection == false {
            guard let nvc = ViewControllers.photo_album.instance as? PhotoAlbumVC else { return }
            nvc.photos = photos
            nvc.albumTitle = album?.title
            nvc.selectedIndex = indexPath
//            nvc.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
//            nvc.thumbnailCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            self.navigationController?.pushViewController(nvc, animated: true)
        }
        else {
                print(_selectedCells)
                _selectedCells.add(indexPath)
                collectionView.reloadItems(at: [indexPath])
                titleLabel.text = "\(_selectedCells.count)개의 사진 선택"
                print(indexPath)
                print(indexPath.row)
                print("selected")
        }
    }
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            _selectedCells.remove(indexPath)
            collectionView.reloadItems(at: [indexPath])
            if _selectedCells.count == 0 {
                titleLabel.text = "사진 선택"
            } else {
                titleLabel.text = "\(_selectedCells.count)개의 사진 선택"
            }
            print("deselected")
        }
    //_selectedCells.add(indexPath)
    //collectionView.reloadItems(at: [indexPath])

}

extension AlbumDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size : CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: size = 89
            break
        case 1: size = 102
            break
        case 2: size = 123
            break
        case 3: size = 135
            break
        default:
            size = 123
            break
        }
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
