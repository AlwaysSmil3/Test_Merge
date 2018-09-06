//
//  GuideCaptureViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol GuideCaptureDelegate {
    func showCamera()
}

class GuideCaptureViewController: BaseViewController {
    
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var btnDisplayAgain: UIButton!
    
    var delegate: GuideCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnDisplayAgain.isSelected = true
        
        if userDefault.value(forKey: UserDefaultShowGuideCameraView) == nil  {
            userDefault.set(true, forKey: UserDefaultShowGuideCameraView)
        }
        
        if let value = userDefault.value(forKey: UserDefaultShowGuideCameraView) as? Bool, !value {
            userDefault.set(true, forKey: UserDefaultShowGuideCameraView)
        }
        
    }
    
    @IBAction func btnClosedTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShowCameraTapped(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.delegate?.showCamera()
        }
        
    }
    
    @IBAction func btnDisplayAgainTapped(_ sender: Any) {
        self.btnDisplayAgain.isSelected = !self.btnDisplayAgain.isSelected
        userDefault.set(self.btnDisplayAgain.isSelected, forKey: UserDefaultShowGuideCameraView)
    }
    
    
}
