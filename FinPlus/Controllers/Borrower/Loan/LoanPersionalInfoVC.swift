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
        
//        self.navigationController?.isNavigationBarHidden = false
//        
//        self.setupTitleView(title: "Test", subTitle: "test")
        
        self.currentStep = 0
        
        if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
            //Cập nhật
            self.updateDataToServer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        super.viewWillAppear(animated)
        
    }
    
    //Buoc dau tạo loan
    private func createLoan() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .POST)
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
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
        
        if DataManager.shared.loanInfo.userInfo.relationships.count < 2 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[0].type < 0 {
            self.showToastWithMessage(message: "Vui lòng chọn người thân 1 để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân 1 để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[1].type < 0 {
            self.showToastWithMessage(message: "Vui lòng chọn người thân 2 để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân 2 để tiếp tục.")
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






