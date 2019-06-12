//
//  LoanNationalIDViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import AVFoundation

class LoanNationalIDViewController: LoanBaseViewController {
    
    override func viewDidLoad() {
        self.index = 2
        super.viewDidLoad()
        self.currentStep = 4
        //self.updateDataToServer()
    
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
        
        FinPlusHelper.checkCameraPermission { (status) in
            self.requestInitPermissionCamera()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func requestInitPermissionCamera() {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                } else {
                    //access denied
                }
            })
            return
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        if !Platform.isSimulator {
            if DataManager.shared.loanInfo.nationalIdAllImg.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng chụp ảnh bạn đang cầm CMND mặt trước")
                return
            }
            
            if DataManager.shared.loanInfo.nationalIdFrontImg.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng chụp ảnh CMND mặt trước")
                return
            }
            
            if DataManager.shared.loanInfo.nationalIdBackImg.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng chụp ảnh CMND mặt sau")
                return
            }
            
            if !DataManager.shared.checkDataInvalidChangedInStepNationalID() {
                //For Missing Data
                self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
                return
            }
        }
        
        if DataManager.shared.listKeyMissingLoanKey != nil && DataManager.shared.listKeyMissingLoanKey!.count > 0  {
            if !DataManager.shared.checkIndexLastStepHaveMissingData(index: 5) {
                DataManager.shared.loanInfo.currentStep = 4
                updateLoanStatusInvalidData()
                return
            }
        }
        
        self.updateDataToServer(step: 4) {
            let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
            self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
        }
    }
    
}
