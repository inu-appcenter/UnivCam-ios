//
//  ZoomableImageVC.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class ZoomableImageVC: UIViewController {
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            self.scrollView.delegate = self
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 3.0
        }
    }
    @IBOutlet var imageView: UIImageView!
    
    var image : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageView.image = image
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTap = UITapGestureRecognizer(target: self,
                                         action: #selector(zoom))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(unwindToAlbum))
        scrollView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoom(sender: UITapGestureRecognizer) {
        if (scrollView.zoomScale < 1.5) {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    func unwindToAlbum() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
extension ZoomableImageVC : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
}
