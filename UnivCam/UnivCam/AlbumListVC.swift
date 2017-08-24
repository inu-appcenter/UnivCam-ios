//
//  AlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class AlbumListVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(Cells.album.nib,
                                    forCellWithReuseIdentifier: Cells.album.identifier)
            self.navigationItem.titleView = titleLabel
            self.titleLabel.isHidden = true
        }
    }
    @IBOutlet var noMessageView: NoMessageView! {
        didSet {
            noMessageView.messageLabel.text = Messages.has_no_albums.rawValue
            noMessageView.actionButton.addTarget(self,
                                                 action: #selector(setCreateAlbumView),
                                                 for: .touchUpInside)
            
        }
    }
    @IBOutlet var newAlbumButton: UIBarButtonItem! {
        didSet {
            newAlbumButton.target = self
            newAlbumButton.action = #selector(setCreateAlbumView)
        }
    }
    
    @IBOutlet var sortButton: UIBarButtonItem! {
        didSet {
            sortButton.target = self
            sortButton.action = #selector(sortAlbumList)
        }
    }
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        let value: Int
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: value = 210
            break
        case 1: value = 210
            break
        case 2: value = 265
            break
        case 3: value = 300
            break
        default:
            value = 0
            break
        }
        titleLabel.text = "앨범"
        titleLabel.textColor = Palette.title.color
        titleLabel.font = Fonts.navigationTitle.style
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 50, width: value, height: 44)
        //plus = 300, 7 = 265, 4,5 = 210
        return titleLabel
    }()
    
    var albums: Results<Album> = {
        let realm = try! Realm()
        return realm.objects(Album.self)
    }()
    
    var selectedAlbum : Album?
    var notificationToken: NotificationToken? = nil
    
    var tutorialView: TutorialView?
    var createAlbumView : CreateAlbumView?
    var confirmDeleteView : ConfirmDeleteView?
    var albumNamingView : AlbumNamingView?
    
    // MARK : 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.addRealmNotification()
    }
    
    /// 렘 노티피케이션 현재 뷰에 추가
    func addRealmNotification() {
        notificationToken = albums.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.reloadData()
                    self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
                }, completion: { _ in })
                
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
}

extension AlbumListVC: UICollectionViewDataSource {
    
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
        
        cell.titleLabel.text = album.title
        cell.isFavButtonChecked = album.isFavorite
        cell.favoriteButton.addTarget(
            self,
            action: #selector(toggleFavorite(sender:)),
            for: .touchUpInside
        )
        cell.editButton.addTarget(
            self,
            action: #selector(cellIsEditing(sender:)),
            for: .touchUpInside
        )
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        cell.cameraButton.addTarget(
            self,
            action: #selector(showCamera(sender:)),
            for: .touchUpInside
        )
        // 이미지 뷰 잔상 제거하기 위함.
        cell.imageView.image = nil
        guard let coverImageURL = album.photos.last?.url else { return cell }
        guard let coverImageData = album.coverImageData, album.coverImageData != nil else
        {
            cell.imageView.image = UIImage(named: coverImageURL)
            return cell
        }
        cell.imageView.image = UIImage(data: coverImageData as Data)
        
//        if let coverImageData = album.coverImageData {
//            cell.imageView.image = UIImage(data: coverImageData as Data)
//            return cell
//        }
//        if let coverImageURL = album.photos.last?.url {
//            cell.imageView.image = UIImage(named: coverImageURL)
//        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "CustomHeaderCell",
                                                                         for: indexPath)
        return headerView
    }
    
}

// MARK : 콜렉션 뷰 데이터 소스, 델리게이트 선언

extension AlbumListVC: UICollectionViewDelegateFlowLayout {
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
extension AlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = ViewControllers.album_detail.instance as? AlbumDetailVC else { return }
        vc.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


////// 앨범 CREATE, UPDATE, DELETE

// CREATE
extension AlbumListVC {
    // 앨범 생성 뷰, 메소드
    
    /// 앨범 생성 화면 띄우기
    func setCreateAlbumView() {
        self.createAlbumView = CreateAlbumView(frame: (UIApplication.shared.keyWindow?.frame)!)
        self.createAlbumView?.frame.origin.y = UIApplication.shared.statusBarFrame.height
        createAlbumView?.createButton.addTarget(
            self,
            action: #selector(createAlbum),
            for: .touchUpInside
        )
        guard let createAlbumView = self.createAlbumView else { return }
        UIApplication.shared.keyWindow?.addSubview(createAlbumView)
    }
    
    /// CREATE - 앨범 생성
    func createAlbum() {
        
        // 앨범 생성 뷰
        guard let createAlbumView = createAlbumView,
            let albumTitle = createAlbumView.albumTitleTextField.text else { return }
        print(albumTitle)
        let albumPath = UnivCamAPI.baseURLString + "/\(albumTitle)"
        var ojeCtBool : ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: albumPath,
                                                     isDirectory: &ojeCtBool)
        
        print("앨범생성 \(albumPath) \(isExist)")
        
        if isExist == false {
            do {
                let fileURL = URL(fileURLWithPath: albumPath)
                try FileManager.default.createDirectory(at: fileURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                guard let files = try? FileManager.default.contentsOfDirectory(atPath: albumPath) as [String] else {
                    return
                }
                
                // CREATE Album Model
                let album = Album()
                album.title = albumTitle
                album.url = albumPath
                album.photoCount = files.count
                let realm = try! Realm()
                
                do {
                    try realm.write {
                        realm.add(album)
                    }
                } catch {
                    
                }
            } catch {
                print("에러 발생")
            }
        } else {
            print("이미 파일이 존재합니다.")
        }
        createAlbumView.remove()
    }
    
}

//UPDATE
extension AlbumListVC {
    // 컬렉션 뷰 앨범 셀 기능 --
    
    /// UPDATE - Toggle Favorite  , 즐겨찾기
    func toggleFavorite(sender: UIButton) {
        // 버튼이 눌린 셀의 인덱스를 가져옴
        let senderPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: senderPosition) else { return }
        
        // 렘 업데이트
        let realm = try! Realm()
        let query = "title = '\(albums[indexPath.row].title)'"
        guard let album = realm.objects(Album.self).filter(query).first else { return }
        do {
            try realm.write {
                album.isFavorite = !album.isFavorite
            }
        } catch {
            print(error)
        }
    }
    
}

// DELETE
extension AlbumListVC {
    func removeAlbum(sender: UIButton) {
        
        // 앨범 삭제
        let album = self.albums[sender.tag]
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: album.url)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        RealmHelper.removeData(data: album)
        confirmDeleteView?.remove()
    }
}

// UPDATE
extension AlbumListVC {
    func showCamera(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tabBarController?.selectedIndex = TapViewControllers.camera.rawValue
                })
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIStoryboard.init(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
                vc.cameraType = .select
                vc.album = Array(self.albums)[indexPath.row]
                self.present(
                    vc,
                    animated: true,
                    completion: nil
                )
            })
        }
    }
    
    func cellIsEditing(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        let album = self.albums[indexPath.row]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if albums[indexPath.row].coverImageData != nil {
            alert.addAction(UIAlertAction(title: "앨범 커버 사진 삭제", style: .default) { action in
                
                let realm = try! Realm()
                do {
                    try realm.write {
                        album.coverImageData = nil
                    }
                } catch {
                    print(error)
                    print("에러났다 왜냐")
                }
                let cell = self.collectionView.cellForItem(at: indexPath) as? AlbumCell
                cell?.imageView.image = nil
                self.collectionView.reloadData()
            })
        } else {
            alert.addAction(UIAlertAction(title: "앨범 커버 사진 선택", style: .default) { action in
                self.addCoverImage()
                self.selectedAlbum = self.albums[indexPath.row]
            })
        }
        alert.addAction(UIAlertAction(title: "앨범 이름변경", style: .default) { action in
            
            let nvc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AlbumNameEditingVC") as! AlbumNameEditingVC
            nvc.album = album
            self.navigationController?.pushViewController(nvc, animated: true)
            
            
        })
        alert.addAction(UIAlertAction(title: "앨범 삭제", style: .default) { action in
            // perhaps use action.title here
            
            self.confirmDeleteView = ConfirmDeleteView(frame: (UIApplication.shared.keyWindow?.frame)!)
            self.confirmDeleteView?.frame.origin.y = UIApplication.shared.statusBarFrame.height
            
            self.confirmDeleteView?.deleteButton.tag = indexPath.row
            self.confirmDeleteView?.deleteButton.addTarget(
                self,
                action: #selector(self.removeAlbum(sender:)),
                for: .touchUpInside
            )
            self.confirmDeleteView?.albumTitleLabel.text = self.albums[indexPath.row].title
            
            UIApplication.shared.keyWindow?.addSubview(self.confirmDeleteView!)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            
        })
        
        self.present(
            alert,
            animated: true,
            completion: { () in
                // add view tapped evnets
        })
    }
}

extension AlbumListVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func addCoverImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(
            imagePicker,
            animated: true,
            completion: nil
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let data = NSData(data: UIImagePNGRepresentation(image)!)
        
        let realm = try! Realm()
        do {
            try realm.write {
                self.selectedAlbum?.coverImageData = data
            }
        } catch {
            print(error)
        }
        self.selectedAlbum = nil
        
        picker.dismiss(
            animated: true,
            completion: nil
        )
    }
}

extension AlbumListVC {
    /// 스크롤 라벨 show , hide 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition < 50 {
            titleLabel.isHidden = true
            self.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            titleLabel.isHidden = false
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }
}

// 정렬 기능
extension AlbumListVC {
    
    func sortAlbumList() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "이름순으로 정렬", style: .default) { action in
            //let realm = try! Realm()
            self.albums = self.albums.sorted(byKeyPath: "title", ascending: true)
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "이름역순으로 정렬", style: .default) { action in
            //let realm = try! Realm()
            self.albums = self.albums.sorted(byKeyPath: "title", ascending: false)
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "시간순으로 정렬", style: .default) { action in
            //let realm = try! Realm()
            self.albums = self.albums.sorted(byKeyPath: "createdAt", ascending: false)
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "시간역순으로 정렬", style: .default) { action in
            //let realm = try! Realm()
            self.albums = self.albums.sorted(byKeyPath: "createdAt", ascending: true)
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
        })
        
        alert.view.tintColor = UIColor(hex: 0x515859)
        self.present(
            alert,
            animated: true,
            completion: { () in
                // add view tapped evnets
        })
    }
}
