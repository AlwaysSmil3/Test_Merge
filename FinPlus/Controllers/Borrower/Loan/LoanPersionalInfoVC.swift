//
//  LoanPersionalInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import APAddressBook

class LoanPersionalInfoVC: LoanBaseViewController {
    
    let addressBook = APAddressBook()
    var aPContacts = [APContact]() {
        didSet {
            if self.aPContacts.count == 0 {
                return
            }
            
            self.aPContacts.forEach { (apContact) in
                self.contacts.append(self.updateContact(apContact: apContact))
            }
        }
    }
    var contacts = [Contact]()
    var isLoadedContact = false
    var isCheckPermission = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = [APContactField.default, APContactField.thumbnail]
        addressBook.sortDescriptors = [NSSortDescriptor(key: "name.firstName", ascending: true),
                                       NSSortDescriptor(key: "name.lastName", ascending: true)]
        addressBook.filterBlock =
            {
                (contact: APContact) -> Bool in
                if let phones = contact.phones {
                    return phones.count > 0
                }
                return false
        }
        addressBook.startObserveChanges
            {
                [unowned self] in
                self.loadContacts {
                    
                }
        }
    }
    
    override func viewDidLoad() {
        self.index = 0
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = false
//        self.setupTitleView(title: "Test", subTitle: "test")
        self.currentStep = 1
        FinPlusHelper.checkContactPermission { (status) in
            self.loadContacts {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        super.viewWillAppear(animated)
    }
    
    private func checkPermissionAndLoadContact() {
        if !self.isCheckPermission {
            self.isCheckPermission = true
            FinPlusHelper.checkContactPermission { (status) in
                self.loadContacts {
                    
                }
            }
        } else {
            self.loadContacts {
                
            }
        }
    }
    
    //MARK: Contacts
    /// Load Contact
    
    func loadContacts(completion: @escaping() -> Void) {
        addressBook.loadContacts
            {
                [unowned self] (contacts: [APContact]?, error: Error?) in
                if let contacts = contacts {
                    self.aPContacts = contacts
                    self.isLoadedContact = true
                    completion()
                    return
                }
                
                guard error != nil else {
                    return
                }
                
                let message = "Đang không có quyền truy cập danh bạ. Để thực hiện tạo đơn vay, bạn vui lòng vào: Cài đặt -> Mony -> và cho phép danh bạ."
                
                self.showAlertView(title: "Danh bạ", message: message, okTitle: "Huỷ", cancelTitle: "Đồng ý", completion: { (bool) in
                    
                    guard !bool else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                UIApplication.shared.openURL(settingsUrl)
                            }
                        }
                    }
                })
        }
    }
    
    /// Get Account Name Contact
    func updateContact(apContact: APContact) -> Contact {
        //self.contact.initData()
        let tempContact: Contact = Contact()
        
        if let phone = apContact.phones {
            if let number = phone.first?.number {
                let numberTemp = number.trimmingCharacters(in: CharacterSet.whitespaces)
                var numberPhone = numberTemp.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
                if numberPhone.contains("+84") {
                    numberPhone = numberPhone.replacingOccurrences(of: "+84", with: "0")
                }
                tempContact.phoneNumber = FinPlusHelper.updatePhoneNumber(phone: numberPhone)
            }
        }
        
        if let avatar = apContact.thumbnail {
            tempContact.avatar = avatar
        }
        
        if let name = apContact.name {
            guard let lastName = name.lastName, let firstName = name.firstName else {
                if let lastName = name.lastName {
                    tempContact.lastName = lastName
                    tempContact.nameDisplay = lastName
                }
                
                if let firstName = name.firstName {
                    tempContact.firstName = firstName
                    tempContact.nameDisplay = firstName
                }
                
                return tempContact
            }
            
            tempContact.fullName = (firstName + " " + lastName).trimmingCharacters(in: .whitespacesAndNewlines)
            tempContact.nameDisplay = (firstName + " " + lastName).trimmingCharacters(in: .whitespacesAndNewlines)
            return tempContact
        }
        return tempContact
    }
    
    //Buoc dau tạo loan
    private func createLoan() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .POST)
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    
    /// Update format relationPhone to server
    private func updateRelationPhone(relationPhone: String) -> String {
        var phone = relationPhone
        if relationPhone.contains("_") {
            let array = relationPhone.components(separatedBy: "_")
            if array.count > 0 {
                phone = array[0]
            }
        }
        
        if phone.contains("+84") {
            phone = phone.replacingOccurrences(of: "+84", with: "0")
        }
        
        if !self.isLoadedContact {
            //Khong cung cap quyen danh ba
            return "\(phone)_2_UNKNOWN"
        }
        
        let list = self.contacts.filter { ($0.phoneNumber ?? "") == phone }
        
        if list.count > 0 {
            return "\(phone)_1_\(list[0].nameDisplay ?? "")"
        }
        
        return "\(phone)_0_UNKNOWN"
    }
    
    private func checkPersionalRelationInfo() -> Bool {
        
        guard DataManager.shared.loanInfo.userInfo.relationships.count > 0 else { return true }
        
        if DataManager.shared.loanInfo.userInfo.relationships[0].type < 0 {
            self.showToastWithMessage(message: "Vui lòng chọn người thân 1 để tiếp tục.")
            return false
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân 1 để tiếp tục.")
            return false
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships[0].name == nil || (DataManager.shared.loanInfo.userInfo.relationships[0].name ?? "").count == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập họ tên người thân 1 để tiếp tục.")
            return false
        }
        
        guard DataManager.shared.loanInfo.userInfo.relationships.count > 1 else { return true }
        
        if let builders = DataManager.shared.getCurrentCategory()?.builders, builders.count > 0, let fieldDis = builders[0].fieldsDisplay, fieldDis.count > 4, let relationData = fieldDis[4].multipleData, relationData.count > 1 {
            if DataManager.shared.loanInfo.userInfo.relationships[1].type < 0 {
                self.showToastWithMessage(message: "Vui lòng chọn người thân 2 để tiếp tục.")
                return false
            }
            
            if DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber.length() == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập số điện thoại người thân 2 để tiếp tục.")
                return false
            }
            
            if DataManager.shared.loanInfo.userInfo.relationships[1].name == nil || (DataManager.shared.loanInfo.userInfo.relationships[1].name ?? "").count == 0 {
                self.showToastWithMessage(message: "Vui lòng nhập họ tên người thân 2 để tiếp tục.")
                return false
            }
        }
        
        return true
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
        
        guard self.checkPersionalRelationInfo() else { return }
        
        if DataManager.shared.loanInfo.userInfo.residentAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập địa chỉ thường trú của bạn để tiếp tục.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.temporaryAddress.city.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập địa chỉ tạm trú của bạn để tiếp tục.")
            return
        }
        
        if !DataManager.shared.checkDataInvalidChangedInStepPersionalInfo() {
            self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
            return
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships.count == 1 {
            let phone1 = DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber
            DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber = self.updateRelationPhone(relationPhone: phone1)
        } else if DataManager.shared.loanInfo.userInfo.relationships.count > 1 {
            let phone1 = DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber
            let phone2 = DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber
            
            DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber = self.updateRelationPhone(relationPhone: phone1)
            DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber = self.updateRelationPhone(relationPhone: phone2)
        }
        
        completion()
    }
    
    private func updateLoanData() {
        self.updateDataForLoanAPI {
            
            if DataManager.shared.listKeyMissingLoanKey != nil && DataManager.shared.listKeyMissingLoanKey!.count > 0  {
                if !DataManager.shared.checkIndexLastStepHaveMissingData(index: 2) {
                    DataManager.shared.loanInfo.currentStep = 1
                    updateLoanStatusInvalidData()
                    return
                }
            }
            
            self.updateDataToServer(step: 1, completion: {
                let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
                
                self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
            })
            
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        self.view.endEditing(true)
//        guard self.isLoadedContact else {
//            self.loadContacts {
//                self.updateLoanData()
//            }
//            return
//        }
        self.updateLoanData()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let relationships = DataManager.shared.loanInfo.userInfo.relationships
        
        var isReloadRelationData = false
        for data in relationships {
            if data.phoneNumber.count == 0 {
                isReloadRelationData = true
                break
            }
            
            if data.type == -1 {
                isReloadRelationData = true
                break
            }
        }
        
        if isReloadRelationData, relationships.count > 0 {
            for i in 0...relationships.count - 1 {
                DataManager.shared.loanInfo.userInfo.relationships[i].type = -1
                DataManager.shared.loanInfo.userInfo.relationships[i].phoneNumber = ""
            }
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
