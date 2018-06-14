//
//  LoanPersionalInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import DropDown

class LoanPersionalInfoVC: LoanBaseViewController {
    
    override func viewDidLoad() {
        self.index = 0
        super.viewDidLoad()
        
        self.updateDataToServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func updateDataForLoanAPI(completion: () -> Void) {
        
        
        if DataManager.shared.loanInfo.userInfo.fullName.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập họ và tên của bạn để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.gender.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn giới tính.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.birthDay.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn ngày sinh.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.nationalID.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số chứng minh nhân dân của bạn để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships.phoneNumber.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.residentAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập địa chỉ thường trú của bạn để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.temporaryAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập địa chỉ tạm trú của bạn để tiếp tục.")
            return
        }
        
        
        completion()
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.updateDataForLoanAPI {
            let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
            
            self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
        }
    }
    
    
    
}






