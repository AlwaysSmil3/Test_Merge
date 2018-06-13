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
    
    // Dropdown DataSource
    let relationPhoneNumberDropdownDataSource = ["Vợ", "Chồng", "Bố", "Mẹ"]
    
    
    //Relationship PhoneNumber
    let relationPhoneNumberDropdown = DropDown()
    var relationPhoneNumberType: RelationPhoneNumber = .Wife
    
    // Address
    var residentAddress: Address?
    var temporatyAddress: Address?
    
    override func viewDidLoad() {
        self.index = 0
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    private func updateDataForLoanAPI(completion: () -> Void) {
        /*
        guard let birthDay = self.birthDay, let residentAddr = self.residentAddress, let tempAddr = self.temporatyAddress else { return }
        
        DataManager.shared.loanInfo.userInfo.fullName = self.tfFullName.text!
        DataManager.shared.loanInfo.userInfo.gender = "\(self.gender.rawValue)"
        DataManager.shared.loanInfo.userInfo.birthDay = "\(birthDay.timeIntervalSince1970)"
        print("\(birthDay.timeIntervalSince1970)")
        DataManager.shared.loanInfo.userInfo.nationalID = self.tfNationalID.text!
        
        DataManager.shared.loanInfo.userInfo.residentAddress = residentAddr
        DataManager.shared.loanInfo.userInfo.temporaryAddress = tempAddr
        
        DataManager.shared.loanInfo.userInfo.relationships.phoneNumber = self.tfRelationPhone.text!
        DataManager.shared.loanInfo.userInfo.relationships.type = self.relationPhoneNumberType.rawValue
        */
        
        
        if DataManager.shared.loanInfo.userInfo.fullName.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập tên")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.gender.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn giới tính")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.birthDay.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn ngày sinh")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.nationalID.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số chứng minh nhân dân")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships.phoneNumber.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.residentAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn địa chỉ thường chú")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.temporaryAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn địa chỉ tạm chú")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.gender.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng chọn địa chỉ tạm chú")
            return
        }
        
        completion()
    }
    
    //MARK: Actions
    @IBAction func btnRelationCallTapped(_ sender: Any) {
        self.relationPhoneNumberDropdown.show()
        
    }
    
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.updateDataForLoanAPI {
            let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
            
            self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
        }
    }
    
    
    
}






