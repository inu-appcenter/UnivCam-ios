//
//  AlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    var albums = [Album]()
    
    var isScrollGreaterThanSpace = false
    
    func fetchFromDirectories() {
        
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentDirecortPath = mainPath + "/UnivCam"
        
        if let files = try! FileManager.default.contentsOfDirectory(atPath: documentDirecortPath) as? [String] {
            for filename in files {
                print(filename)
            }
        }
        let files = try! FileManager.default.contentsOfDirectory(atPath: documentDirecortPath)
        print(files.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("결과")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        RealmHelper.fetchData(dataList: &albums)
        fetchFromDirectories()
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func cellImageViewDidTap() {
        print("yes")
    }
    @IBAction func addFolderButtonDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"앨범 생성", message:"앨범을 생성하시겠습니까?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "앨범 명을 입력하세요."
            textField.clearButtonMode = .whileEditing
            //textField.text = defaultText
        })
        let okAction = UIAlertAction(
            title: "확인",
            style: UIAlertActionStyle.destructive,
            handler: {(action: UIAlertAction!) in
                let text = alert.textFields?.first?.text ?? ""
                self.createAlbumFolder(title: text)
        }
        )
        let cancelAction = UIAlertAction(
            title: "취소",
            style: UIAlertActionStyle.cancel,
            handler: nil
        )
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
//                let album = CoreDataHelper.newAlbum()
//                album.title = title
//                album.createdAt = NSDate()
//                album.isFavorite = false
//                album.thumbnail = "icStar"
//                CoreDataHelper.saveAlbum()
                let album = Album()
                album.title = title
                album.url = documentDirecortPath
                album.id = Album.incrementID()
                RealmHelper.addData(data: album)
                albums.removeAll()
                RealmHelper.fetchData(dataList: &albums)
                collectionView.reloadData()
                
            } catch {
                print("error")
            }
        } else {
            print("fail")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailAlbum" {
            
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
        cell.imageView.image = UIImage(named: "back")
        cell.titleLabel.text = album.title
//        cell.favToggleButton.isHidden = (viewType == "Favorites")
//        cell.editButton.addTarget(self, action: #selector(test(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        
        return cell
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
        self.performSegue(withIdentifier: "ShowAlbumDetail", sender: self)
    }
}

extension AlbumListVC: Editable {
    func cellIsEditing() {
        
        let alert = UIAlertController(title: "", message: "앨범 선택", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범 선택", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 상세정보", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 삭제", style: .default) { action in
            // perhaps use action.title here
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
