//
//  ViewControllers.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllers {
    
    // 탭바
    case tapbar
    
    // 홈
    case album_list
    
    // 검색
    case search_album
    
    // 카메라
    case permission
    case custom_camera
    case taken_photo
    case select_album
    
    // 즐겨찾기
    case favorite_album_list
    
    // 앨범
    case album_detail
    case photo_album
    case zoomable_image
    
}

extension ViewControllers {
    var instance : UIViewController {
        get {
            switch self {
            case .tapbar:
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
            case .album_list:
                return UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "GallerySliderVC")
            case .search_album:
                return PhotoAlbumVC()
            case .permission:
                return PhotoAlbumVC()
            case .custom_camera:
                return UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraNVC")
            case .taken_photo:
                return UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "TakenPhotoVC")
            case .select_album:
                return UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "SelectAlbumVC")
            case .favorite_album_list:
                return PhotoAlbumVC()
            case .photo_album:
                return UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "PhotoAlbumVC")
            case .zoomable_image:
                return UIStoryboard(name: "Album", bundle: nil).instantiateViewController(withIdentifier: "ZoomableImageVC")
            case .album_detail:
                return UIStoryboard(name: "Album", bundle: nil).instantiateViewController(withIdentifier: "AlbumDetailVC")
            }
        }
    }
}
