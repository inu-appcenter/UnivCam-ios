//
//  Cells.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum Cells {
    case album
    case photo
    case setting
    case setting_header
//    var size: CGSize = UIScreen.main.bounds.width {
//        switch self {
//
//        }
//    }
}

extension Cells {
    var nib : UINib {
        get {
            switch self {
            case .album:
                return UINib(nibName: "AlbumCell", bundle: nil)
            case .photo:
                return UINib(nibName: "PhotoCell", bundle: nil)
            case .setting:
                return UINib(nibName: "SettingCell", bundle: nil)
            case .setting_header:
                return UINib(nibName: "SettingHeaderCell", bundle: nil)
            }
        }
    }
    var identifier : String {
        get {
            switch self {
            case .album:
                return "UICollectionViewCell"
            case .photo:
                return "UICollectionViewCell"
            case .setting:
                return "SettingCell"
            case .setting_header:
                return "SettingHeaderCell"
            }
        }
    }
}

