//
//  LoanInfoJobVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import DropDown

class LoanInfoJobVC: LoanBaseViewController {
    
    override func viewDidLoad() {
        self.index = 1
        super.viewDidLoad()
        
        self.updateDataToServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
    
    //MARK: Get API
    
    private func updateDataForLoanAPI(completion: () -> Void) {

        if DataManager.shared.loanInfo.jobInfo.jobType.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn nghề nghiệp")
            return
        }
        
        if DataManager.shared.loanInfo.jobInfo.position.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn cấp bậc")
            return
        }
        
        if DataManager.shared.loanInfo.jobInfo.company.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập tên cơ quan để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.jobInfo.salary == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mức thu nhập hàng tháng để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.jobInfo.address.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn địa chỉ cơ quan.")
            return
        }
        
//        if DataManager.shared.loanInfo.jobInfo.companyPhoneNumber.length() == 0 {
//            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại cơ quan.")
//            return
//        }
        
        completion()
    }
    
    
    //MARK: Actions

    @IBAction func btnContinueTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.updateDataForLoanAPI {
            let loanWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "LIST_WALLET") as! ListWalletViewController
            loanWalletVC.walletAction = .LoanNation
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
        }
        
    }
    
}




