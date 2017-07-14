//
//  GetServices.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 14..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Photos

struct GetServices {
    static func photos() -> [UIImage] {
        let imgManager = PHImageManager.default()
        var imageArray = [UIImage]()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(
            key: "creationDate",
            ascending: false
            )
        ]
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(
            with: .image,
            options: fetchOptions
            ) {
        
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    image, error in
                    imageArray.append(image!)
                })
            }
            
        }
        
        }
        
        return imageArray
    }
}
