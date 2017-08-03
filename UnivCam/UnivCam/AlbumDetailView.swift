//
//  AlbumDetailView.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 25..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

@IBDesignable
class AlbumDetailView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var indexPath: IndexPath!
    //var collectionView:UICollectionView!
    var collectionView: UICollectionView!
    
    let identifier = "AlbumDetailViewCell"
    var photoDataSource = PhotoDataSource()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        initLayout()
    }
    func initLayout() {
        if(collectionView != nil){ return }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.height)
            , collectionViewLayout: flowLayout)
        
        
        collectionView.backgroundColor = UIColor.clear//背景色为透明
        //collectionView.isPagingEnabled = true//每次滚一页
        
        collectionView.delegate = self
        photoDataSource.photos = GetServices.photos(type: .big)
        collectionView.dataSource = photoDataSource
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(AlbumDetailViewCell.self, forCellWithReuseIdentifier: identifier)
        //collectionView.register(UINib(nibName: "AlbumDetailViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        
        if(indexPath != nil){
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 123, height: 123)
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let row = indexPath.row
        let cell: AlbumDetailViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumDetailViewCell
//        cell.setData()
//        cell.delegate = self
//        if row == 0 {
//            cell.backgroundColor = UIColor.red
//        } else {
//            cell.backgroundColor = UIColor.blue
//        }
        //cell.setupContents()
        //cell.imageView?.image = UIImage(named: "splash")
        return cell
        
    }
    func onAlbumItemClick(){
        //点击cell回调
    }
}
//class AlbumViewCell: UICollectionViewCell ,UIScrollViewDelegate{
//    var vScrollView: UIScrollView!
//    var startContentOffsetX :CGFloat!
//    var startContentOffsetY :CGFloat!
//    var vImage: UIImageView!
//    var delegate: AlbumViewDelegate!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        vImage = UIImageView()
//        vImage.frame.size = frame.size
//        vImage.contentMode = UIViewContentMode.scaleAspectFit
//        
//        vScrollView = UIScrollView()
//        vScrollView.frame.size = frame.size
//        vScrollView.addSubview(vImage)
//        
//        vScrollView.delegate = self
//        vScrollView.minimumZoomScale = 0.5
//        vScrollView.maximumZoomScale = 2
//        vScrollView.showsVerticalScrollIndicator = false
//        vScrollView.showsHorizontalScrollIndicator = false
//        //添加单击
//        //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AlbumViewCell.scrollViewTapped(_:)))
//        //vScrollView.addGestureRecognizer(tapRecognizer)
//        //self.addSubview(vScrollView)
//    }
//    
//    func setData() {
//        vScrollView.zoomScale = 1
//        vImage.image = UIImage(named:"IMG_1798")
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return vImage
//    }
//    //缩放触发
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerScrollViewContents()//缩小图片的时候把图片设置到scrollview中间
//    }
//    func centerScrollViewContents() {
//        let boundsSize = vScrollView.bounds.size
//        var contentsFrame = vImage.frame
//        
//        if contentsFrame.size.width < boundsSize.width {
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
//        } else {
//            contentsFrame.origin.x = 0.0
//        }
//        
//        if contentsFrame.size.height < boundsSize.height {
//            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
//        } else {
//            contentsFrame.origin.y = 0.0
//        }
//        
//        vImage.frame = contentsFrame
//    }
//    func scrollViewTapped(_ recognizer: UITapGestureRecognizer) {
//        //单击回调
//        if(delegate != nil){
//            delegate.onAlbumItemClick()
//        }
//    }
//    
//}
//protocol AlbumViewDelegate{
//    func onAlbumItemClick()
//}
