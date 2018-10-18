//
//  LoanInfoJobVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanInfoJobVC: LoanBaseViewController {
    
    override func viewDidLoad() {
        self.index = 1
        super.viewDidLoad()
        
        self.currentStep = 1
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
        
        if  !DataManager.shared.isLendingforStudent() {
            
            if DataManager.shared.loanInfo.jobInfo.jobTitle.count == 0 {
                self.showToastWithMessage(message: "Vui lòng chọn loại hình hoạt động")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicLevel < 0 {
                self.showToastWithMessage(message: "Vui lòng chọn trình độ học vấn")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.positionTitle.count == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập vị trí làm việc để tiếp tục.")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.company.count == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập nơi làm việc để tiếp tục.")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.experienceYear <= 0 {
                self.showToastWithMessage(message: "Vui lòng nhập số năm kinh nghiệm để tiếp tục.")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.salary == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập tổng thu nhập hàng tháng để tiếp tục.")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.jobAddress.city.count == 0 {
                self.showToastWithMessage(message: "Vui lòng chọn địa chỉ làm việc.")
                return
            }
            
            
        } else {
            
            
            if DataManager.shared.loanInfo.jobInfo.academicName.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập tên trường học để tiếp tục.")
                return
            }
            
            if DataManager.shared.loanInfo.jobInfo.strength < 0 {
                self.showToastWithMessage(message: "Vui lòng chọn học lực của bạn để tiếp tục.")
                return
            }
            
            
            if DataManager.shared.loanInfo.jobInfo.academicAddress.city.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng chọn địa trường học.")
                return
            }
        }
        
        
        if !DataManager.shared.checkDataInvalidChangedInStepJobInfo() {
            //For Missing Data
            self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
            return
        }

        
        
        completion()
    }
    
    
    //MARK: Actions

    @IBAction func btnContinueTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        self.updateDataForLoanAPI {
            
            if DataManager.shared.listKeyMissingLoanKey != nil && DataManager.shared.listKeyMissingLoanKey!.count > 0  {
                if !DataManager.shared.checkIndexLastStepHaveMissingData(index: 3) {
                    DataManager.shared.loanInfo.currentStep = 2
                    updateLoanStatusInvalidData()
                    return
                }
            }
            
            let loanWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "LIST_WALLET") as! ListWalletViewController
            loanWalletVC.walletAction = .LoanNation
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
        }
        
    }
    
}




