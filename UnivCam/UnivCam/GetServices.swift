
import Photos

struct GetServices {
    
    static func photos(type: PhotoType) -> [UIImage] {
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
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: type.cellSize, contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        imageArray.append(image!)
                        imageArray.append(image!)
                    })
                }
                
            }
            //fetchResult.firstObject
        }
        
        
        return imageArray
    }
    
    static func albums() {
        let options:PHFetchOptions = PHFetchOptions()
        let getAlbums : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        // 앨범 정보
        print(getAlbums)
        
        for i in 0 ..< getAlbums.count{
            let collection = getAlbums[i]
            // . localizedTitle = 앨범 타이틀
            let title : String = collection.localizedTitle!
            
            if(collection.estimatedAssetCount != nil){
                // . estimatedAssetCount = 앨범 내 사진 수
                let count : Int = collection.estimatedAssetCount
                print(count)
                print(title)
                
            }else{
            }
        }
    }
    
    static func getAlbumWithName(named: String) -> Void {
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", named)
                let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                
//                if let album = collections.firstObject as? PHAssetCollection {
//                    
//                } else {
//                    
//                }
                
            }

            }
    }
    
  //DispatchQueue.global(attributes: .qosDefault) {
//            // Do background work
//            
//            DispatchQueue.main.async {
        

    
    static func albumThumbnail(name: String) {
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", name)
                let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                
                if let album = collections.firstObject as? PHAssetCollection {
                    print(album)
                } else {
                    
                }
                
            }
            
        }
        
    }
}


