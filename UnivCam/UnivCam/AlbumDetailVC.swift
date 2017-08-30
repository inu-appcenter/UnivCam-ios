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

enum actionCase {
    case multi
    case delete
    case share
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
            self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    @IBOutlet weak var doneButton: UIBarButtonItem! {
        didSet {
            doneButton.target = self
            doneButton.action = #selector(moreAction)
        }
    }
    
    @IBOutlet weak var cancelAllButton: UIBarButtonItem! {
        didSet {
            cancelAllButton.tintColor = UIColor.clear
            cancelAllButton.target = self
            cancelAllButton.action = #selector(moreAction)
            cancelAllButton.isEnabled = false
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
    var _appendCells : NSMutableArray = []
    var _allCells : NSMutableArray = []
    var photoUrls = [String]()
    var album : Album?
    var token : NotificationToken?
    var appendPhotos = List<Photo>()
    var numberOfRow = 0
    var number = 0
    var newalbum : Album?
    var actionType : actionCase?
    
    override func viewWillAppear(_ animated: Bool) {
        self.photos.removeAll()
        print(photos.count)
        self.numberOfRow = 0
        self.number = 0
        self.photoUrls.removeAll()
        self.viewDidLoad()
        print("포토 갱신")
        print(photos.count)
        _allCells.removeAllObjects()
        _selectedCells.removeAllObjects()
        _appendCells.removeAllObjects()
        print("데이터갱신 전")
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: backButton), cancelAllButton], animated: false)
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = moreButton
        self.collectionView.allowsMultipleSelection = false
        appendPhotos = (self.album?.photos)!
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
            self.numberOfRow += 1
            //}
        }
    }
    
    func unwindToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func shareImages() {
        var sharePhotos = [UIImage]()
        
        for cindexPath in _selectedCells {
            guard let coindexPath = cindexPath as? IndexPath else { return }
            sharePhotos.append(photos[coindexPath.row])
        }
        let pictureShare = UIActivityViewController(activityItems: sharePhotos, applicationActivities: nil)
        UIButton.appearance().tintColor = UIColor(hex:0x515859)
        pictureShare.excludedActivityTypes = [ UIActivityType.airDrop]
        pictureShare.popoverPresentationController?.sourceView = self.view
        self.present(pictureShare, animated: true, completion: nil)
    }
    
    func deleteImages() {
        var indexPaths = [IndexPath]()
        //let fileManager = FileManager.default
        for cindexPath in _selectedCells {
            guard let coindexPath = cindexPath as? IndexPath else { return }
            indexPaths.append(coindexPath)
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: photoUrls[coindexPath.row])
            }
            catch {
                print("사진삭제 못했어;;")
            }
            self.numberOfRow -= 1
        }
        collectionView.deleteItems(at: indexPaths)
        collectionView.reloadData()
        let newAlbumCoverImageData = self.album?.coverImageData
//        let newAlbumtitle = self.album?.title
//        let newAlbumUrl = self.album?.url
        removeAlbum()
//        self.number = 0

//        removeAlbum()
//        createAlbum(titleOfAlbum: newAlbumtitle!, urlOfAlbum: newAlbumUrl!)
        print("이제 업데이트 시작한다")
//        let setNumber = numberOfRow
//        let _newCells = _allCells
//        for row in  1...setNumber {
//            let dindexPath = _allCells.lastObject
//            guard let delindexPath = dindexPath as? IndexPath else { return }
//            numberOfRow -= 1
//            collectionView.deleteItems(at: [delindexPath])
//            _allCells.removeLastObject()
////            collectionView.numberOfItems(inSection: numberOfRow)
//        }
//        print("일단 다 지워짐")
////        collectionView.reloadData()
//        self.photos.removeAll()
//        //let fileManager = FileManager.default
//
//        indexPaths.removeAll()
        for cindexPath in _appendCells{
//            let newIndexPath = _newCells.firstObject
//            guard let neindexpath = newIndexPath as? IndexPath else { return }
            guard let coindexPath = cindexPath as? IndexPath else { return }
            print(cindexPath)
            print(coindexPath)
            indexPaths.append(coindexPath)
            let appendPhoto = Photo()
            appendPhoto.url = photoUrls[coindexPath.row] + "$\(self.number)"

            let realm = try! Realm()
            do {
                try realm.write {
                    self.album?.photoCount = (album?.photoCount)! + 1
                    self.album?.photos.append(appendPhoto)
                    self.album?.coverImageData = nil
                    self.album?.coverImageData = newAlbumCoverImageData
                }
            }
            catch {

            }
            self.number += 1
        }
//        collectionView.insertItems(at: indexPaths)
////        for dindexPath in _selectedCells {
////            guard let deindexPath = dindexPath as? IndexPath else { return }
////            indexPaths.append(deindexPath)
////        }
//        print("사진 입력 완료")
        self.photos.removeAll()
        print(photos.count)
        self.numberOfRow = 0
        self.number = 0
        self.photoUrls.removeAll()
        self.viewDidLoad()
        print("포토 갱신")
        print(photos.count)
        _allCells.removeAllObjects()
        _selectedCells.removeAllObjects()
        _appendCells.removeAllObjects()
        print("데이터갱신 전")
        
        collectionView.reloadData()
    }
    
    func moreAction() {
        if collectionView.allowsMultipleSelection == false {
            
            let moreActionView = UIAlertController()
            let multiSelect = UIAlertAction(title: actionTitle.select_multi.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.moreButton.image = UIImage(named: "icDone2X")
                self.navigationItem.leftItemsSupplementBackButton = false
                self.navigationItem.leftBarButtonItems?.removeAll()
                self.navigationItem.setLeftBarButton(self.cancelAllButton, animated: false)
                self.actionType = .multi
            })
            let multiDelete = UIAlertAction(title: actionTitle.select_delete.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.navigationItem.leftBarButtonItems?.removeAll()
                self.navigationItem.leftBarButtonItem = self.cancelAllButton
                self.moreButton.image = UIImage(named: "icDone2X")
                self.actionType = .delete
            })
            let multiShare = UIAlertAction(title: actionTitle.select_share.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = true
                self.titleLabel.text = "사진 선택"
                self.navigationItem.leftBarButtonItems?.removeAll()
                self.navigationItem.leftBarButtonItem = self.cancelAllButton
                self.moreButton.image = UIImage(named: "icDone2X")
                self.actionType = .share
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
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let delete = UIAlertAction(title: actionTitle.delete.rawValue, style: .default, handler: { (action)->Void in
                self.deleteImages()
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let copy = UIAlertAction(title: actionTitle.copy.rawValue, style: .default, handler: { (action)->Void in
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
            })
            let share = UIAlertAction(title: actionTitle.share.rawValue, style: .default, handler: { (action)->Void in
                self.shareImages()
                self.collectionView.allowsMultipleSelection = false
                self.titleLabel.text = self.album?.title
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
                self.moreButton.image = UIImage(named: "icMoreVertWhite")
                self._selectedCells.removeAllObjects()
                self.collectionView.reloadData()
            })
            let cancelAction = UIAlertAction(title: actionTitle.cancel.rawValue, style: .cancel, handler: { (action)->Void in
            })
            
            switch self.actionType {
            case .delete?:
                moreActionView.addAction(delete)
                break
            case .multi?:
                moreActionView.addAction(delete)
                moreActionView.addAction(share)
                break
            case .share?:
                moreActionView.addAction(share)
                break
            case .none:
                break
            }
            //moreActionView.addAction(move)
            //moreActionView.addAction(copy)
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
        return numberOfRow
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.photo.identifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        cell.checkedImage.isHidden = true
        if !_allCells.contains(indexPath){
            _allCells.add(indexPath)
        }
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
        if cell.is_selected == false {
            if !_appendCells.contains(indexPath) {
                _appendCells.add(indexPath)
            }
        }
        return cell
    }
    
    
    
}
extension AlbumDetailVC: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(_selectedCells)
        let cell = self.collectionView.cellForItem(at: indexPath) as! PhotoCell
        if self.collectionView.allowsMultipleSelection == false {
            guard let nvc = ViewControllers.photo_album.instance as? PhotoAlbumVC else { return }
            nvc.photos = photos
            nvc.albumTitle = album?.title
            nvc.selectedIndex = indexPath
            nvc.photoUrls = self.photoUrls
            nvc.album = self.album
//            nvc.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
//            nvc.thumbnailCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            self.navigationController?.pushViewController(nvc, animated: true)
        }
        else {
                print(_selectedCells)
                _selectedCells.add(indexPath)
                _appendCells.remove(indexPath)
                collectionView.reloadItems(at: [indexPath])
                titleLabel.text = "\(_selectedCells.count)개의 사진 선택"
                print(indexPath)
                print(indexPath.row)
                print("selected")
                cell.is_selected = true
        }
    }
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! PhotoCell
            _selectedCells.remove(indexPath)
            _appendCells.add(indexPath)
            cell.is_selected = false
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

extension AlbumDetailVC {    
    func removeAlbum() {
        
        let dealbum = self.album?.photos
        RealmHelper.removePhotos(data: dealbum!)
        let realm = try! Realm()
        do {
            try realm.write {
                self.album?.photoCount = 0
            }
        }
        catch {
            
        }
    }
    
    func updateCells() {
        guard let dirPath = self.album?.url,
            let files = try? FileManager.default.contentsOfDirectory(atPath: dirPath) else { return }
        self.photos.removeAll()
        for filename in files {
            // 파일 확장자 png 체크
            print("no")
            let suffixIndex = filename.index(filename.endIndex, offsetBy: -3)
            _ = filename.substring(from: suffixIndex)
            //if suffix == "png" {
            let imageURL = dirPath + "/" + filename
            photoUrls.append(imageURL)
            self.photos.append(UIImage(named: imageURL)!)
        }
    }
}
