//
//  LoanNationalIDViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Fusuma

enum NATIONALID_TYPE_IMG: Int {
    case ALL = 0
    case FRONT
    case BACK
}

class LoanNationalIDViewController: LoanBaseViewController {
    
    @IBOutlet var imgNationalIDAll: UIImageView!
    @IBOutlet var imgNationalIDFront: UIImageView!
    @IBOutlet var imgNationalIDBack: UIImageView!
    
    var type: NATIONALID_TYPE_IMG = .ALL
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    private func setupFusuma() {
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = true
        fusuma.availableModes = [.camera]

        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    private func uploadData(img: UIImage) {
        
        let dataImg = UIImagePNGRepresentation(img)
        
        let loanID = DataManager.shared.loanID ?? 0
        guard let data = dataImg else { return }
        let endPoint = "loans/" + "\(loanID)/" + "file"
        
        self.handleLoadingView(isShow: true)
        APIClient.shared.upload(type: .NATIONALID_BACK, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { (response) in
            self.handleLoadingView(isShow: false)
            print("Upload \(response)")
            self.showToastWithMessage(message: "Upload success")
            
        }) { (error) in
            self.handleLoadingView(isShow: false)
            
            if let error = error {
                self.showToastWithMessage(message: error.localizedDescription)
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func btnLoadCMNDImgALLTapped(_ sender: Any) {
        self.setupFusuma()
        self.type = .ALL
    }
    
    @IBAction func btnLoadCMNDImgFrontTapped(_ sender: Any) {
        self.setupFusuma()
        self.type = .FRONT
    }
    
    @IBAction func btnLoadCMNDImgBackTapped(_ sender: Any) {
        self.setupFusuma()
        self.type = .BACK
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
        
        self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
        
    }
}

//MARK: Fusuma Delegate
extension LoanNationalIDViewController: FusumaDelegate {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
        
        switch source {
        case .camera:
            print("Image captured from Camera")
            switch self.type {
            case .ALL:
                self.imgNationalIDAll.image = img
                break
            case .FRONT:
                self.imgNationalIDFront.image = img
                break
            case .BACK:
                self.imgNationalIDBack.image = img
                break
            }
            
            self.uploadData(img: img)
            break
        case .library:
            
            print("Image selected from Camera Roll")
            break
        default:
            
            print("Image selected")
        }
        
        //imageView.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        
        for image in images {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                
                //self.imageView.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("video completed and output to file: \(fileURL)")
        //self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Called just after dismissed FusumaViewController using Camera")
            
        case .library:
            
            print("Called just after dismissed FusumaViewController using Camera Roll")
            
        default:
            
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController,
            let presented = vc.presentedViewController else {
                
                return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
    }
    
    
    
}




