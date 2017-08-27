//
//  PhotoViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoAlbumVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = photoDataSource
            collectionView.delegate = self
            collectionView.register(Cells.photo.nib,
                                    forCellWithReuseIdentifier: Cells.photo.identifier)
        }
    }
    @IBOutlet var thumbnailCollectionView: UICollectionView! {
        didSet {
            thumbnailCollectionView.dataSource = photoDataSource
            thumbnailCollectionView.delegate = self
            thumbnailCollectionView.register(Cells.photo.nib,
                                             forCellWithReuseIdentifier: Cells.photo.identifier)
        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print(selectedIndex)
        guard let selectedIndex = selectedIndex else { return }
        let photo = photos[selectedIndex.row]
        let pictureShare = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        UIButton.appearance().tintColor = UIColor(hex:0x515859)
        pictureShare.excludedActivityTypes = [ UIActivityType.airDrop]
        pictureShare.popoverPresentationController?.sourceView = self.view
        self.present(pictureShare, animated: true, completion: nil)
    }
    
    @IBOutlet var deleteButton: UIBarButtonItem! {
        didSet {
            deleteButton.target = self
            deleteButton.action = #selector(deletePhoto)
        }
    }
    
    func deletePhoto() {
        
        let alert = UIAlertController()
        let confirm_delete = UIAlertAction(title: "사진 삭제", style: .default, handler: { (action)->Void in
            
            let indexPath = IndexPath(row: 0, section: 0)
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: self.photoUrls[(self.selectedIndex?.row)!])
            }
            catch {
                print("사진삭제 못했어;;")
            }
            let realm = try! Realm()
            do {
                try realm.write {
                    self.album?.photoCount -= 1
                }
            }
            catch {
                
            }
            print("일단 지우기는함")
            print(self.photos)
            self.photoDataSource.photos.remove(at: (self.selectedIndex?.row)!)
            self.collectionView.deleteItems(at: [self.selectedIndex!])
            self.thumbnailCollectionView.deleteItems(at: [self.selectedIndex!])
            self.photos.remove(at: (self.selectedIndex?.row)!)
            self.photoUrls.remove(at: (self.selectedIndex?.row)!)
            print("지워짐??")
            print(self.photos)
            self.photoDataSource.photos.removeAll()
            self.photoDataSource.photos = self.photos
            if self.photos.isEmpty == true {
                self.unwindToAlbum()
            }
            else {
                self.thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
                self.thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
                
                if self.selectedIndex?.row != 0{
                    self.selectedIndex?.row = (self.selectedIndex?.row)! - 1
                }
                else {
                    self.selectedIndex?.row = 0
                }
                self._selectedCells.add(self.selectedIndex)
                self.collectionView.reloadData()
                self.thumbnailCollectionView.reloadData()
                let indexToScrollTo = IndexPath(item: (self.selectedIndex?.row)!, section: 0)
                self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
                self.thumbnailCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
                self._selectedCells.remove(self.selectedIndex)
            }

        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (action)->Void in
            print("취소")
        })
        alert.addAction(confirm_delete)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor(hex: 0x515859)
        self.present(alert, animated: true, completion: nil)
        
//        self.collectionView.reloadData()
//        self.thumbnailCollectionView.reloadData()
    }
    
    
    lazy var backButton : UIButton = {
        let btn : UIButton = .init(type: .system)
        btn.setImage(
            Assets.leftNavigationItem.image,
            for: .normal)
        
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(unwindToAlbum), for: .touchUpInside)
        return btn
    }()
    
    let photoDataSource = PhotoDataSource()
    var selectedIndex : IndexPath?
    var photos = [UIImage]()
    var _selectedCells : NSMutableArray = []
    var album : Album?
    var albumTitle : String?
    var onceOnly = false
    var photoUrls = [String]()
    var returnedFromZoom : Bool = false
    var isSrolledLeft : Bool = true
    var scrollOnce : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if returnedFromZoom {
            returnedFromZoom = false
            photoDataSource.photos.removeAll()
            photoDataSource.photos = photos
        }
        else {
            photoDataSource.photos.removeAll()
            photoDataSource.photos = photos
            
            guard let selectedIndex = selectedIndex else { return }
            
            //        collectionView.selectItem(at: selectedIndex,
            //                                  animated: false,
            //                                  scrollPosition: .centeredHorizontally)
            
            _selectedCells.add(selectedIndex)
        }
//        self.thumbnailCollectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: UICollectionViewScrollPosition())
//        self.thumbnailCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)
//        thumbnailCollectionView.cellForItem(at: selectedIndex)?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        self.collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: UICollectionViewScrollPosition())
//        self.collectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)
        print(selectedIndex)
        print("사진 눌렀음")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        photoDataSource.photos.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button : UIButton = .init(type : .system)
        button.setImage(Assets.leftNavigationItem.image, for: .normal)
        guard let title = albumTitle else { return }
        button.setTitle("  \(title)", for: .normal)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(unwindToAlbum), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func unwindToAlbum() {
        if let vc = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: (selectedIndex?.row)!, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            self.thumbnailCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView).x > 0) {
            isSrolledLeft = true
            print("left")
        }
        else {
            isSrolledLeft = false
            print("right")
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isSrolledLeft {
            self.selectedIndex?.row = (self.selectedIndex?.row)! - 1
        }
        else {
            self.selectedIndex?.row = (self.selectedIndex?.row)! + 1
        }
        if scrollView == collectionView {
            guard _selectedCells.count == 0 else { return }
            for cindexPath in _selectedCells {
                guard let coindexPath = cindexPath as? IndexPath else { return }
                thumbnailCollectionView.cellForItem(at: coindexPath)?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                _selectedCells.remove(coindexPath)
            }
            
            
            let index = targetContentOffset.pointee.x / view.frame.width
            
            let indexPath = IndexPath(item: Int(index), section: 0)
            thumbnailCollectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            thumbnailCollectionView.scrollToItem(at: selectedIndex!, at: .centeredHorizontally, animated: true)
            thumbnailCollectionView.cellForItem(at: selectedIndex!)?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            _selectedCells.add(indexPath)
        }
        print("움직이는중")
    }
    
    
}
extension PhotoAlbumVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if collectionView == self.collectionView {
            let vc = UIStoryboard(name: "Album", bundle: nil).instantiateViewController(withIdentifier: "ZoomableImageVC") as! ZoomableImageVC
            vc.image = photos[indexPath.row]
            returnedFromZoom = true
            self.present(vc, animated: false, completion: nil)
        } else if collectionView == self.thumbnailCollectionView {
           
            for indexPath in _selectedCells {
                guard let indexPath = indexPath as? IndexPath else { return }
                thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                print(indexPath)
                _selectedCells.remove(indexPath)
            }
            
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            _selectedCells.add(indexPath)
            self.selectedIndex = indexPath
        }
    }
}

extension PhotoAlbumVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == thumbnailCollectionView {
            return CGSize(width: 63, height: 63)
        }
        else {
            return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 63)
        }
    }
    
}
