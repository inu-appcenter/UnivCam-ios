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
            navigationItem.titleView = titleLabel
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "앨범"
        titleLabel.textColor = UIColor.init(hex: 0x353946)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        return titleLabel
    }()
    
    var albums : Results<Album> = AppDelegate.getDelegate().albums
    var notificationToken: NotificationToken? = nil
    
    var isScrollGreaterThanSpace = false
    var tutorialView: TutorialView?
    var createAlbumView : CreateAlbumView?
    var confirmDeleteView : ConfirmDeleteView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialView = TutorialView(frame: (UIApplication.shared.keyWindow?.frame)!)
        UIApplication.shared.keyWindow?.addSubview(tutorialView!)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(removeTutorial))
        tutorialView?.addGestureRecognizer(tapGesture)
        //        tutorialView?.frame.origin.y = 20
        
        notificationToken = albums.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                     self?.collectionView.reloadData()
                    
                }, completion: { _ in })
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
        
    }
    func removeTutorial() {
        tutorialView?.removeFromSuperview()
    }
    public func cellImageViewDidTap() {
        print("yes")
    }
    @IBAction func addFolderButtonDidTap(_ sender: UIBarButtonItem) {
        //        let alert = UIAlertController(title:"앨범 생성", message:"앨범을 생성하시겠습니까?", preferredStyle: .alert)
        //        alert.addTextField(configurationHandler: { textField in
        //            textField.placeholder = "앨범 명을 입력하세요."
        //            textField.clearButtonMode = .whileEditing
        //            //textField.text = defaultText
        //        })
        //        let okAction = UIAlertAction(
        //            title: "확인",
        //            style: UIAlertActionStyle.destructive,
        //            handler: {(action: UIAlertAction!) in
        //                let text = alert.textFields?.first?.text ?? ""
        //                self.createAlbumFolder(title: text)
        //
        //        }
        //        )
        //        let cancelAction = UIAlertAction(
        //            title: "취소",
        //            style: UIAlertActionStyle.cancel,
        //            handler: nil
        //        )
        //        alert.addAction(okAction)
        //        alert.addAction(cancelAction)
        //self.view.addSubview(<#T##view: UIView##UIView#>)
        //self.present(alert, animated: true, completion: nil)
        //        let createAlbumView = Bundle.main.loadNibNamed(
        //            "CreateAlbumView",
        //            owner: self,
        //            options: nil
        //            )?[0] as! UIView
        
        createAlbumView = CreateAlbumView(frame: (UIApplication.shared.keyWindow?.frame)!)
        UIApplication.shared.keyWindow?.addSubview(createAlbumView!)
        createAlbumView?.frame.origin.y = 20
        createAlbumView?.cancelButton.addTarget(
            self,
            action: #selector(removeCreateView),
            for: .touchUpInside
        )
        createAlbumView?.createButton.addTarget(
            self,
            action: #selector(createAlbum),
            for: .touchUpInside
        )
        
    }
    
    func createAlbumFolder(title: String) {
        let createdAt = NSDate()
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentDirecortPath = mainPath + "/UnivCam" + "/\(title)"
        
        var ojeCtBool : ObjCBool = true
        let isExit = FileManager.default.fileExists(atPath: documentDirecortPath, isDirectory: &ojeCtBool)
        print(isExit)
        print(documentDirecortPath)
        if isExit == false {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: documentDirecortPath), withIntermediateDirectories: true, attributes: nil)
                
                let album = Album()
                album.title = title
                album.url = UnivCamAPI.baseURL() + "/" + title
                album.id = Album.incrementID()
                
                guard let files = try! FileManager.default.contentsOfDirectory(atPath: album.url) as? [String] else {
                    return
                }
                album.photoCount = files.count
                
                
                RealmHelper.addData(data: album)
                //albums.removeAll()
                //RealmHelper.fetchData(dataList: &albums)
                //collectionView.reloadData()
                
            } catch {
                print("error")
            }
        } else {
            print("fail")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailAlbum" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let album = albums[selectedIndexPath.row]
                let destinationVC = segue.destination as! AlbumDetailVC
                destinationVC.dirPath = album.url
            }
        }
    }
    
    func updateFavoriteAlbum(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        //print(albums[indexPath.row].title)
        
        let oldAlbum = albums[indexPath.row]
        
        let updateAlbum = Album()
        updateAlbum.title = oldAlbum.title
        updateAlbum.id = oldAlbum.id
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.isFavorite = !oldAlbum.isFavorite
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.url = oldAlbum.url
        updateAlbum.photoCount = oldAlbum.photoCount
        
        let query = "id == \(updateAlbum.id)"
        RealmHelper.updateObject(data: updateAlbum, query: query)
        
        
    }
    
    
    func cellIsEditing(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범 선택", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 이름변경", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 삭제", style: .default) { action in
            // perhaps use action.title here
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
            guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
            
            self.confirmDeleteView = ConfirmDeleteView(frame: (UIApplication.shared.keyWindow?.frame)!)
            
            self.confirmDeleteView?.cancelButton.addTarget(
                self,
                action: #selector(self.removeDeleteView),
                for: .touchUpInside
            )
            self.confirmDeleteView?.deleteButton.tag = indexPath.row
            self.confirmDeleteView?.deleteButton.addTarget(
                self,
                action: #selector(self.removeAlbum(sender:)),
                for: .touchUpInside
            )
            self.confirmDeleteView?.albumTitleLabel.text = self.albums[indexPath.row].title
            UIApplication.shared.keyWindow?.addSubview(self.confirmDeleteView!)
            self.confirmDeleteView?.frame.origin.y = 20
            
            
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
    @IBAction func sortAlbumList(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "이름순으로 정렬", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "이름 역순으로 정렬", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "시간순으로 정렬", style: .default) { action in
        })
        alert.addAction(UIAlertAction(title: "즐겨찾는 앨범", style: .default) { action in
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
extension AlbumListVC {
    func removeCreateView() {
        createAlbumView?.removeFromSuperview()
    }
    func createAlbum() {
        guard let albumTitle = createAlbumView?.albumTitleTextField.text, !(createAlbumView?.albumTitleTextField.text?.characters.isEmpty)! else {
            return
        }
        createAlbumFolder(title: albumTitle)
        removeCreateView()
    }
    func removeDeleteView() {
        confirmDeleteView?.removeFromSuperview()
    }
    func removeAlbum(sender: UIButton) {
        print("호출?")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let album = self.albums[indexPath.row]
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: album.url)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        RealmHelper.removeData(data: album)
        
        //self.albums.remove(at: indexPath.row)
        //self.collectionView.deleteItems(at: [indexPath])
        removeDeleteView()
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
            action: #selector(updateFavoriteAlbum(sender:)),
            for: .touchUpInside
        )
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(
            self,
            action: #selector(cellIsEditing(sender:)),
            for: .touchUpInside
        )
        cell.imageView.image = UIImage(named: "back")
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        cell.cameraButton.tag = indexPath.row
        cell.cameraButton.addTarget(
            self,
            action: #selector(showCameraVC(sender:)),
            for: .touchUpInside
        )
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "CustomHeaderCell",
                                                                         for: indexPath)
        return headerView
    }
    
}

extension AlbumListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
    
}
extension AlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetailAlbum", sender: self)
    }
    
}

extension AlbumListVC {
    func showCameraVC(sender: UIButton) {
        
        let captureSession = AVCaptureSession()
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    //self.tabbarController
                    //self.ta
                    
                })
                print("에러")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
                vc.cameraType = .select
                vc.album = Array(self.albums)[sender.tag]
                print(vc.album?.title)
                //let albums = Array(self.albums)
                //vc.album = albums[sender.tag]
                
                self.present(
                    vc,
                    animated: true,
                    completion: nil
                )
            })
//            // access granted

            
        }
    }
}
