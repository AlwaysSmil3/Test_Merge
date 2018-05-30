//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Fusuma

class LoanOtherInfoVC: LoanBaseViewController {
    
    
    @IBOutlet var textOtherInfo: AnimatableTextView!
    @IBOutlet var imgOtherInfo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    
    //MARK: 
    
    private func setupFusuma() {
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = true
        fusuma.availableModes = [.library]
        
        fusumaSavesImage = true
        
        self.present(fusuma, animated: true, completion: nil)
    }
    
    
    
    //MARK: ACtions
    
    @IBAction func btnLoanImgOtherInfoTapped(_ sender: Any) {
        self.setupFusuma()
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        DataManager.shared.loanInfo.optionalText = self.textOtherInfo.text
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
    }
    

    
}

//MARK: Fusuma Delegate
extension LoanOtherInfoVC: FusumaDelegate {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
            
        case .library:
            
            print("Image selected from Camera Roll")
            
        default:
            
            print("Image selected")
        }
        
        //imageView.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        
        for image in images {
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
//            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
//
//                //self.imageView.image = image
//                print("w: \(image.size.width) - h: \(image.size.height)")
//            }
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

