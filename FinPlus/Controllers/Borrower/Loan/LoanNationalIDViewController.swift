//
//  LoanNationalIDViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanNationalIDViewController: LoanBaseViewController {
    
    override func viewDidLoad() {
        self.index = 2
        super.viewDidLoad()
        
        self.updateDataToServer()
    
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }

    //MARK: Actions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        /*
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
        */
        
        let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
        
        self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
        
    }
}


