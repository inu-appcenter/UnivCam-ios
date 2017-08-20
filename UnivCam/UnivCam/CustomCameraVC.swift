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
    
    let realm = try! Realm()

    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
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
    }
    
    func beginSession() {
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
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.cameraView.layer.frame
        captureSession.startRunning()
        self.layerView.addSubview(shutterButton)
        self.view.addSubview(layerView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(toggleCameraButton)
        
        self.shutterButton.addTarget(
            self,
            action: #selector(saveCaptureImage),
            for: .touchUpInside
        )
    }
    
    
    func saveCaptureImage() {
        
        switch cameraType {
        case .all:
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
    
}


