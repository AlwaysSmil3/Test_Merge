//
//  CameraViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/7/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import AVFoundation

protocol DataImageFromCameraCaptureDelegate {
    func getImage(image: UIImage, type: FILE_TYPE_IMG?)
}

class CameraViewController: BaseViewController {
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var btnCapture: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnExits: UIButton!
    @IBOutlet var imgBackgound: UIImageView!
    @IBOutlet var btnUsePhoto: UIButton!
    @IBOutlet var btnExitsRight: UIButton!
    @IBOutlet var btnSwitchCamera: UIButton!
    
    @IBOutlet var contentCurrentImageAll: UIView!
    @IBOutlet var imgCurrentCaptureAll: UIImageView!
    
    @IBOutlet var contentCurrentImageOther: UIView!
    @IBOutlet var imgCurrentCaptureOther: UIImageView!
    
    @IBOutlet var btnRetakeOhter: UIButton!
    @IBOutlet var btnCaptureOhter: UIButton!
    @IBOutlet var lblDescriptionOther: UILabel!
    
    // Kiểu File Img
    var typeImgFile: FILE_TYPE_IMG?
    var currentPhoto: UIImage?
    var descriptionText: String?
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var delegateCamera: DataImageFromCameraCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentCurrentImageAll.isHidden = true
        
        self.initCamera()
    }
    
    override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = view.bounds
        if let previewLayer = videoPreviewLayer ,(previewLayer.connection?.isVideoOrientationSupported)! {
            previewLayer.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation ?? .portrait
        }
    }
    
    //MARK: Camera
    private func initCamera() {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                } else {
                    //access denied
                    let message = "Đang không có quyền truy cập Camera. Vui lòng vào: Cài đặt -> Mony -> và cho phép Camera."
                    
                    self.showAlertView(title: "Camera", message: message, okTitle: "Huỷ", cancelTitle: "Đồng ý", completion: { (bool) in
                        
                        guard !bool else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                        }
                        
                    })
                }
            })
            
            return
        }
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devcie on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            //captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()
            
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
        
        self.lblDescriptionOther.isHidden = true
        
        if let type = self.typeImgFile {
            if type == .ALL {
                self.setTypeCamera(position: .front)
            } else if type == .BACK {
                self.imgBackgound.image = #imageLiteral(resourceName: "img_nationalID_Back")
                self.setTypeCamera(position: .back)
                self.lblDescription.isHidden = true
                self.btnExits.isHidden = true
                self.btnExitsRight.isHidden = false
                self.btnCaptureOhter.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.btnRetakeOhter.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.lblDescriptionOther.isHidden = false
                self.lblDescriptionOther.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.lblDescriptionOther.text = self.descriptionText
            } else if type == .FRONT {
                self.imgBackgound.image = #imageLiteral(resourceName: "img_nationalID_Front")
                self.setTypeCamera(position: .back)
                self.lblDescription.isHidden = true
                self.btnExits.isHidden = true
                self.btnExitsRight.isHidden = false
                self.lblDescriptionOther.isHidden = false
                self.btnCaptureOhter.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.btnRetakeOhter.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.lblDescriptionOther.transform = CGAffineTransform(rotationAngle: .pi/2)
                self.lblDescriptionOther.text = self.descriptionText
            } else {
                self.btnSwitchCamera.isHidden = false
                self.setTypeCamera(position: .back)
                self.lblDescription.isHidden = false
                self.lblDescription.text = self.descriptionText
                self.imgBackgound.isHidden = true
            }
        }
        
        
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    func changeCamera() {
        //Change camera source
        if let session = captureSession {
            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            
            session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            
            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription)")
            } else {
                session.addInput(newVideoInput)
            }
            
            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }
    
    private func setTypeCamera(position: AVCaptureDevice.Position) {
        //Change camera source
        if let session = captureSession {
            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            
            session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            newCamera = cameraWithPosition(position: position)
            
            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription)")
            } else {
                session.addInput(newVideoInput)
            }
            
            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }
    
    @IBAction func btnSwitchCameraTapped(_ sender: Any) {
        self.changeCamera()
        
    }
    
    @IBAction func btnCaptureTapped(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func btnExitsTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func btnUsePhotoTapped(_ sender: Any) {
        if let img = self.currentPhoto {
            if self.typeImgFile == FILE_TYPE_IMG.Optional {
                SVProgressHUD.show(withStatus: "Mony...")
            }
            self.dismiss(animated: true) {
                if self.typeImgFile == FILE_TYPE_IMG.Optional {
                    SVProgressHUD.dismiss()
                }
                self.delegateCamera?.getImage(image: img, type: self.typeImgFile)
            }
        }
    }
    
    @IBAction func btnRetakeTapped(_ sender: Any) {
        if !self.contentCurrentImageAll.isHidden {
            //self.contentCurrentImageAll.isHidden = true
            self.animationShowHideView(isHidden: true, currentView: self.contentCurrentImageAll) {
                
            }
        }
        
        if !self.contentCurrentImageOther.isHidden {
            //self.contentCurrentImageOther.isHidden = true
            self.animationShowHideView(isHidden: true, currentView: self.contentCurrentImageOther) {
                
            }
        }
        
    }
    
    private func animationShowHideView(isHidden: Bool, currentView: UIView, completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            currentView.isHidden = isHidden
            self.view.layoutIfNeeded()
        }) { (status) in
            completion()
        }
    }
    
    
    
}

//MARK: AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        
        
        if let image = capturedImage {
            // Save our captured image to photos album
            print("image capture succeess")
            
            if let type = self.typeImgFile, type == .FRONT || type == .BACK {
                self.currentPhoto = image.rotate(radians: .pi * 3/2)
                
                if self.contentCurrentImageOther.isHidden {
                    //self.contentCurrentImageOther.isHidden = false
                    self.imgCurrentCaptureOther.image = image.rotate(radians: .pi * 2)
                    self.animationShowHideView(isHidden: false, currentView: self.contentCurrentImageOther) {
                    }
                    
                }
            
            } else {
                self.currentPhoto = image
                
                if self.contentCurrentImageAll.isHidden {
                    //self.contentCurrentImageAll.isHidden = false
                    self.imgCurrentCaptureAll.image = image
                    self.animationShowHideView(isHidden: false, currentView: self.contentCurrentImageAll) {
                        
                    }
                    
                }
                
            }
            
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}


