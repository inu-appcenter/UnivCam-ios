//
//  PhotoViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

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
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        photoDataSource.photos.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
        
        self.thumbnailCollectionView.deleteItems(at: [indexPath])
        
        
        if !photoDataSource.photos.isEmpty {
            thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        self.collectionView.reloadData()
        self.thumbnailCollectionView.reloadData()
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
    var albumTitle : String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        photoDataSource.photos.removeAll()
        photoDataSource.photos = photos
        
        guard let selectedIndex = selectedIndex else { return }
        
        collectionView.selectItem(at: selectedIndex,
                                  animated: false,
                                  scrollPosition: .centeredHorizontally)
        
        _selectedCells.add(selectedIndex)
        
        
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
        //self.navigationController?.popToRootViewController(animated: true)
        //self.navigationController?.popToViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if scrollView == collectionView {
            
            for indexPath in _selectedCells {
                guard let indexPath = indexPath as? IndexPath else { return }
                thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                _selectedCells.remove(indexPath)
            }
            
            
            let index = targetContentOffset.pointee.x / view.frame.width
            
            let indexPath = IndexPath(item: Int(index), section: 0)
            thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            _selectedCells.add(indexPath)
            
        }
        print("움직이는중")
    }
    
    
}
extension PhotoAlbumVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            let vc = UIStoryboard(name: "Album", bundle: nil).instantiateViewController(withIdentifier: "ZoomableImageVC") as! ZoomableImageVC
            vc.image = photos[indexPath.row]
            
            self.present(vc,
                         animated: false,
                         completion: nil)
        } else if collectionView == self.thumbnailCollectionView {
           
            for indexPath in _selectedCells {
                guard let indexPath = indexPath as? IndexPath else { return }
                thumbnailCollectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                print(indexPath)
                _selectedCells.remove(indexPath)
            }
            
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            _selectedCells.add(indexPath)
            
        }
    }
}

extension PhotoAlbumVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return collectionView == thumbnailCollectionView ? CGSize(width: 63, height: 63) : CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 63)
    }
    
}
