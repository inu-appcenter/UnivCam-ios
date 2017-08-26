//
//  CameraViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

enum CameraType {
    //셀카메라
    case select
    //가운데 카메라
    case all
}

class CustomCameraVC: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var layerView: UIView!
    @IBOutlet var shutterButton: UIButton!
    @IBOutlet var toggleCameraButton: UIButton!
    
    @IBOutlet weak var selectShowImage: UIImageView!
    @IBOutlet weak var showDetailBttn: UIButton!

    
    @IBAction func toggleCamera(_ sender: Any) {
        if isCameraBack {
            isCameraBack = false
            self.captureSession = AVCaptureSession.init()
            self.stillImageOutput = AVCaptureStillImageOutput.init()
            self.viewDidLoad()
        }
        else {
            isCameraBack = true
            self.captureSession = AVCaptureSession.init()
            self.stillImageOutput = AVCaptureStillImageOutput.init()
            self.viewDidLoad()
        }
    }
    
    var isCameraBack = true
    
    let realm = try! Realm()

    var captureSession = AVCaptureSession()
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var cameraType : CameraType = .all
    var album : Album?
    var albumURL : String?
    var imageDatas = [String : Data]()
    var number = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let imageUrl = self.album?.photos.last?.url {
            self.selectShowImage.image = UIImage(named: imageUrl)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.frame = self.view.frame
        self.showCameraView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func unwindToTabVC(_ sender: UIButton) {
        
        switch cameraType {
        case .all:
            self.selectShowImage.isHidden = true
            break
        case .select:
            //folderUpdate()
            break
        }
        
        self.dismiss(
            animated: true,
            completion: nil
        )
    }
    
}
extension CustomCameraVC : AVCapturePhotoCaptureDelegate,UIImagePickerControllerDelegate {
    func showCameraView() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        switch isCameraBack {
        case true:
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                        if (device.position == AVCaptureDevicePosition.back) {
                            captureDevice = device
                            if captureDevice != nil {
                                print("Capture device found")
                                beginSession()
                            }
                        }
                }
            }
        }
        break
        case false:
            if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
            // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                        if (device.position == AVCaptureDevicePosition.front) {
                            captureDevice = device
                            if captureDevice != nil {
                                print("Capture device found")
                                beginSession()
                            }
                        }
                }
            }
        }
        break
        }
    }
    
    func beginSession() {
        let heightForLayerView : CGFloat
        let widthAndHeightForButtons : CGFloat
        let yposition : CGFloat
        let xposition : CGFloat
        let widthAndHeightForUpperButtons : CGFloat
        let ypositionForUpperButtons : CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: heightForLayerView = 106
            widthAndHeightForButtons = 58
            widthAndHeightForUpperButtons = 35
            yposition = 7
            ypositionForUpperButtons = 19
            xposition = 86
            break
        case 1: heightForLayerView = 125
            widthAndHeightForButtons = 68
            widthAndHeightForUpperButtons = 42
            yposition = 9
            ypositionForUpperButtons = 21
            xposition = 102
            break
        case 2: heightForLayerView = 147
            widthAndHeightForButtons = 80
            widthAndHeightForUpperButtons = 49
            yposition = 10
            ypositionForUpperButtons = 25
            xposition = 120
            break
        case 3: heightForLayerView = 162
            widthAndHeightForButtons = 88
            widthAndHeightForUpperButtons = 54
            yposition = 11
            ypositionForUpperButtons = 27
            xposition = 132
            break
        default:
            heightForLayerView = 147
            widthAndHeightForButtons = 80
            widthAndHeightForUpperButtons = 49
            yposition = 10
            ypositionForUpperButtons = 25
            xposition = 120
            break
        }
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("no preview layer")
            return
        }
        //뷰 더하기 및 레이아웃 사이즈 정해주기.
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.cameraView.layer.frame
        captureSession.startRunning()
        self.layerView.addSubview(shutterButton)
        self.layerView.frame = CGRect(x: 0, y: (self.view.frame.height - heightForLayerView), width: self.cameraView.frame.width, height: heightForLayerView)
        self.shutterButton.frame = CGRect(x: 0, y: 0, width: widthAndHeightForButtons, height: widthAndHeightForButtons)
        self.selectShowImage.frame = CGRect(x: 0, y: 0, width: widthAndHeightForButtons, height: widthAndHeightForButtons)
        self.showDetailBttn.frame = CGRect(x: 0, y: 0, width: widthAndHeightForButtons, height: widthAndHeightForButtons)
        self.shutterButton.center.x = self.layerView.center.x
        self.shutterButton.center.y = ((self.layerView.frame.height / 2) - yposition)
        self.selectShowImage.center.x = self.layerView.center.x + xposition
        self.showDetailBttn.center.x = self.layerView.center.x + xposition
        self.selectShowImage.center.y = ((self.layerView.frame.height / 2) - yposition)
        self.showDetailBttn.center.y = ((self.layerView.frame.height / 2) - yposition)
        self.layerView.addSubview(shutterButton)
        self.layerView.addSubview(selectShowImage)
        self.layerView.insertSubview(showDetailBttn, aboveSubview: selectShowImage)
        self.view.addSubview(layerView)
        self.cancelButton.frame = CGRect(x: 0, y: ypositionForUpperButtons, width: widthAndHeightForUpperButtons, height: widthAndHeightForUpperButtons)
        self.toggleCameraButton.frame = CGRect(x: (self.view.frame.width - widthAndHeightForUpperButtons), y: ypositionForUpperButtons, width: widthAndHeightForUpperButtons, height: widthAndHeightForUpperButtons)
        self.view.addSubview(cancelButton)
        self.view.addSubview(toggleCameraButton)
        
        self.shutterButton.addTarget(
            self,
            action: #selector(saveCaptureImage),
            for: .touchUpInside
        )
        self.showDetailBttn.addTarget(
            self,
            action: #selector(showAlbumDetail),
            for: .touchUpInside
        )
    }
    
    
    func saveCaptureImage() {
        showScreenshotEffect()
        switch cameraType {
        case .all:
            self.showDetailBttn.isHidden = true
            self.showSelectListVC()
            break
        case .select:
            self.takePhoto()
            break
        }
        
    }
    func takePhoto() {
        self.shutterButton.isUserInteractionEnabled = false
        let name = self.album?.url
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                
                //group.enter()
                
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        self.storePhotoImage(image: cameraImage, name: name!, completion: { (success) in
                            if success {
                                self.shutterButton.isUserInteractionEnabled = true
                                self.selectShowImage.image = UIImage(data: imageData)
                            }
                        })
                    }
                }


            })
        }
    }
    
    func storePhotoImage(
        image: UIImage,
        name: String,
        completion: @escaping (_ success: Bool) -> ()
        ) {
        let imageName = String(describing: Date())
        let imageData =  UIImageJPEGRepresentation(image, 1.0)
        
        do {
            try imageData?.write(to: URL.init(fileURLWithPath: name + "/\(imageName)$\(number)"), options: .atomicWrite)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                self.folderUpdate(image: image, photoURLString: name + "/\(imageName)$\(self.number)")
                self.number = self.number + 1
                completion(true)
            })
        } catch {
            completion(false)
            
        }
        
    }
    
    
    
    func folderUpdate(image: UIImage, photoURLString: String) {
        
        guard let oldAlbum = album else { return }
//        let updateAlbum = Album()
//        updateAlbum.title = oldAlbum.title
//        updateAlbum.id = oldAlbum.id
//        updateAlbum.createdAt = oldAlbum.createdAt
//        updateAlbum.isFavorite = oldAlbum.isFavorite
//        updateAlbum.createdAt = oldAlbum.createdAt
//        updateAlbum.url = oldAlbum.url
//        updateAlbum.photoCount = oldAlbum.photoCount + 1
//        updateAlbum.photos = oldAlbum.photos
        
        //let query = "id == \(updateAlbum.id)"
        //let query = "title = '\(updateAlbum.title)'"

        
        //updateAlbum.photos
        //let photo = Photo()
        //photo.url = photoURLString
        //updateAlbum.photos.append(photo)

        //RealmHelper.updateObject(data: updateAlbum, query: query)
        
//        do {
//            try realm.write {
//                updateAlbum.photos.append(photo)
//                print("추가")
//            }
//        } catch {
//            print(error)
//        }
       
        let photo = Photo()
        photo.url = photoURLString
        
        let realm = try! Realm()
        do {
            try realm.write {
                album?.photoCount = (album?.photoCount)! + 1
                album?.photos.append(photo)
            }
        } catch {
            print(error)
        }
    }
    
    
    func showSelectListVC() {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    guard let cameraImage = UIImage(data: imageData) else { return }
                        
                        guard let nvc = ViewControllers.taken_photo.instance as? TakenPhotoVC else { return }
                        nvc.capturedImage = cameraImage
                        self.navigationController?.pushViewController(nvc, animated: false)
                    
                }
            })
        }
    }
    
    func showScreenshotEffect() {
        
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snapshotView)
        
        let constraints:[NSLayoutConstraint] = [
            snapshotView.topAnchor.constraint(equalTo: view.topAnchor),
            snapshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            snapshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            snapshotView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        snapshotView.backgroundColor = UIColor.white

        UIView.animate(withDuration: 0.2, animations: {
            snapshotView.alpha = 0
        }) { _ in
            snapshotView.removeFromSuperview()
        }
    }
    
    func showAlbumDetail() {
        guard let vc = ViewControllers.album_detail.instance as? AlbumDetailVC else { return }
        vc.album = self.album
        self.navigationController?.navigationBar.shadowImage = nil
        vc.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


