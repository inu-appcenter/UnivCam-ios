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
    case select
    case all
}

class CustomCameraVC: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var layerView: UIView!
    @IBOutlet var shutterButton: UIButton!
    @IBOutlet var toggleCameraButton: UIButton!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var cameraType : CameraType = .all
    var album : Album?
    var albumURL : String?
    var imageDatas = [String : Data]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        print(album?.url)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCameraView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToTabVC(_ sender: UIButton) {
        
        
        switch cameraType {
        case .all:
            
            
            break
        case .select:
            
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
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            //let fileManager = FileManager.default
                            let imageName = String(describing: Date())
                            let imageData =  UIImageJPEGRepresentation(cameraImage, 1.0)
                            
                            try! imageData?.write(to: URL.init(fileURLWithPath: (self.album?.url)! + "/\(imageName)"), options: .atomicWrite)
                            self.folderUpdate()
                        }
                    }
                }
            })
        }
    }
    func folderUpdate() {
        
        guard let oldAlbum = album else { return }
        let updateAlbum = Album()
        updateAlbum.title = oldAlbum.title
        updateAlbum.id = oldAlbum.id
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.isFavorite = oldAlbum.isFavorite
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.url = oldAlbum.url
        updateAlbum.photoCount = oldAlbum.photoCount + 1
        
        let query = "id == \(updateAlbum.id)"
        RealmHelper.updateObject(data: updateAlbum, query: query)
        
    }
    
    
    func showSelectListVC() {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        //UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                        
                        
                        let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CapturedImageVC") as! CapturedImageVC
                        nvc.capturedImage = cameraImage
                        self.navigationController?.pushViewController(nvc, animated: false)
                        
                    }
                }
            })
        }
    }
    
}


