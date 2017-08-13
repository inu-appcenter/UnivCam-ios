//
//  PhotoViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = photoDataSource
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    @IBOutlet var thumbnailCollectionView: UICollectionView! {
        didSet {
            thumbnailCollectionView.dataSource = photoDataSource
            thumbnailCollectionView.delegate = self
            thumbnailCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    
    let photoDataSource = PhotoDataSource()
    var selectedIndex : IndexPath?
    var photos = [UIImage]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        albumDataSource.photos = photos
//        collectionView.reloadData()
//        print(albumDataSource.photos)
        photoDataSource.photos = photos
        
        guard let selectedIndex = selectedIndex else { return }
        
        collectionView.selectItem(at: selectedIndex,
                                  animated: false,
                                  scrollPosition: .centeredHorizontally)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //albumDataSource.photos = GetServices.photos(type: .big)
        //photoDataSource.photos = GetServices.photos(type: .big)
        
        
        let button = UIButton(type: .system)
        button.setImage(Assets.leftNavigationItem.image, for: .normal)
        button.setTitle("  뒤로가기", for: .normal)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        button.addTarget(self, action: #selector(unwindToAlbum), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func unwindToAlbum() {
//        if let vc = self.navigationController?.viewControllers[1] {
//            self.navigationController?.popToViewController(vc, animated: true)
//        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension PhotoVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if let cv = thumbnailCollectionView {
            cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cv.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.thumbnailCollectionView.contentOffset, size: self.thumbnailCollectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        guard let indexPath = self.thumbnailCollectionView.indexPathForItem(at: visiblePoint) else { return }
//        
//        print(indexPath)
        //self.thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(self.thumbnailCollectionView.visibleCells)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let index = targetContentOffset.pointee.x / view.frame.width
//        
//        let indexPath = IndexPath(item: Int(index), section: 0)
//        print(indexPath)
//        thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = self.collectionView.indexPathForItem(at: visiblePoint)!
        thumbnailCollectionView.selectItem(
            at: visibleIndexPath,
            animated: true,
            scrollPosition: .centeredHorizontally
        )
        print(visibleIndexPath)
        
    }
}
extension PhotoVC {
    
}

extension PhotoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return collectionView == thumbnailCollectionView ? CGSize(width: 63, height: 63) : CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 63)
    }
    
}
