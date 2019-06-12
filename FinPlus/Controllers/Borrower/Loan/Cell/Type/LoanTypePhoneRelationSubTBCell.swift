//
//  LoanTypePhoneRelationSubTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol UpdateStatusInvalidRelationPhoneDelegate: class {
    func update(isNeed: Bool)
}

class LoanTypePhoneRelationSubTBCell: LoanTypeBaseRelationTBCell {
    
    var data: LoanBuilderMultipleData? {
        didSet {
            guard let data_ = data else { return }
            self.tfRelationPhone?.placeholder = data_.placeholder
            self.tfRelationPhone?.text = self.getDisplayPhone(relationPhone: data_.phoneNumber ?? "")
            self.tfTypeRelation?.text = DataManager.getTitleRelationShip(id: data_.type ?? -1)
            self.setupUI(id: data_.type ?? -1)
            self.checkInvalidPersionalRelationData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tfRelationPhone?.delegate = self
        self.tfNameRelation?.delegate = self
        if #available(iOS 11.0, *) {
            self.tfRelationPhone?.textContentType = .username
        }
//        self.lblAddressRelationTitle?.font = FONT_CAPTION
//        self.lblAddressRelationTitle?.textColor = TEXT_NORMAL_COLOR
    }
    
    private func setupUI(id: Int) {
        let number = self.getTitleTypeRelation(id: id)
        let text = number == "1" || number == "2" ? "người thân \(number)" : "của \(number)"
        
        self.lblTitlePhone?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: "Số điện thoại liên lạc \(text)")
        self.lblNameRelationTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: "Họ và tên \(text)")
        self.tfNameRelation?.placeholder = "Nhập họ và tên \(text)"
        self.tfRelationPhone?.placeholder = "Số điện thoại của \(text)"
        
        //self.lblAddressRelationTitle?.text = "Địa chỉ \(text)"
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex, let name = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].name, name.count > 0 {
            self.tfNameRelation?.text = name
        }
        
        /*
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex, let add = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address, add.count > 0  {
            self.lblAddressRelation?.text = add
        } else {
            self.lblAddressRelation?.text = "Nhấn để chọn địa chỉ \(text)"
        }
        */
    }
    
    //MARK: Check invalid
    private func checkInvalidPersionalRelationData() {
        guard DataManager.shared.missingRelationsShip != nil else { return }
        
        let bool1 = self.checkInvalidPhoneNumber()
        let bool2 = self.checkInvalidName()
        //let bool3 = self.checkInvalidAddress()
        
        if self.currentIndex == 0 {
            if bool1, bool2 {
                DataManager.shared.isRelationPhone1Invalid = false
            } else {
                DataManager.shared.isRelationPhone1Invalid = true
            }
        } else {
            if bool1, bool2 {
                DataManager.shared.isRelationPhone2Invalid = false
            } else {
                DataManager.shared.isRelationPhone2Invalid = true
            }
        }
        self.updateStatus()
    }
    
    /// Check invalid Phone
    private func checkInvalidPhoneNumber() -> Bool {
        guard let value = self.tfRelationPhone?.text, DataManager.shared.missingRelationsShip != nil else { return true }
        let valueTemp = FinPlusHelper.updatePhoneNumber(phone: value)
        if valueTemp != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
            self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    /// Check invalid Name
    private func checkInvalidName() -> Bool {
        guard let value = self.tfNameRelation?.text else { return true }
        if DataManager.shared.checkNameRelationInvalid(name: value, index: self.currentIndex) {
            self.tfNameRelation?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        self.tfNameRelation?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    /// Check invalid Address
    private func checkInvalidAddress() -> Bool {
        guard self.currentIndex < DataManager.shared.loanInfo.userInfo.relationships.count else { return true }
        let add = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address ?? ""
        if DataManager.shared.checkAddressRelationInvalid(address: add, index: self.currentIndex) {
            self.lblAddressRelation?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        self.lblAddressRelation?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    func updateStatus() {
        if !DataManager.shared.isRelationPhone1Invalid && !DataManager.shared.isRelationPhone2Invalid {
            self.delegateUpdateStatusInvalid?.update(isNeed: false)
            userDefault.set("", forKey: UserDefaultInValidRelationPhone)
            userDefault.synchronize()
        } else {
            self.delegateUpdateStatusInvalid?.update(isNeed: true)
        }
    }
    
    /*
    /// Sang màn chọn địa chỉ
    private func gotoAddressVC(title: String, id: String) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        firstAddressVC.titleString = title
        firstAddressVC.id = id
        
        if self.currentIndex < DataManager.shared.loanInfo.userInfo.relationships.count {
            firstAddressVC.addressStringValue = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address
        }
        
        
        self.parentVC?.show(firstAddressVC, sender: nil)
    }
    */
    
    //MARK: Actions
    
    /*
    @IBAction func btnAddressTapped(_ sender: Any) {
        self.parentVC?.view.endEditing(true)
        let title = self.lblAddressRelationTitle?.text ?? "Địa chỉ người thân \(self.currentIndex + 1)"
        let id = "RelationAddress\(self.currentIndex + 1)"
        self.gotoAddressVC(title: title, id: id)
    }
    */
    
    @IBAction func tfNameEditEnd(_ sender: Any) {
        guard let value = self.tfNameRelation?.text else { return }
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex {
            DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].name = value
        }
        self.checkInvalidPersionalRelationData()
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        if let value = self.tfRelationPhone?.text {
            let valueTemp = FinPlusHelper.updatePhoneNumber(phone: value)
            if DataManager.shared.loanInfo.userInfo.relationships.count > 0 {
                DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].phoneNumber = valueTemp
            }
            self.checkInvalidPersionalRelationData()
        }
    }
    
    @IBAction func btnTypeRelationTapped(_ sender: Any) {
        guard let data_ = self.data, let options = data_.options else { return }
        var dataSource: [LoanBuilderData] = []
        var otherSelection: Int?
        
        if self.currentIndex == 0 {
            if let value = DataManager.shared.currentIndexRelationPhoneSelectedPopup2 {
                otherSelection = value
            }
        } else {
            if let value = DataManager.shared.currentIndexRelationPhoneSelectedPopup1 {
                otherSelection = value
            }
        }
        
        for op in options {
            if let other = otherSelection, Int16(other) == op.id {
                
            } else {
                var da = LoanBuilderData(object: NSObject())
                da.id = op.id
                da.title = op.title
                dataSource.append(da)
            }
        }
        
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.indexRelationPhone = self.currentIndex
        popup.setDataSource(data: dataSource, type: .RelationShipPhone)
        popup.delegate = self
        popup.show()
    }
    
}

//MARK: TextField Delegate
extension LoanTypePhoneRelationSubTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.currentIndex < DataManager.shared.loanInfo.userInfo.relationships.count {
            if DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].type < 0 {
                UIApplication.shared.topViewController()?.showToastWithMessage(message: "Vui lòng chọn người thân \(self.currentIndex + 1) để tiếp tục.")
                return false
            }
        }
        
        let newString = (textField.text ?? "") + string
    
        guard textField == self.tfRelationPhone else {
            
            if DataManager.shared.checkNameRelationInvalid(name: newString as String, index: self.currentIndex) {
                self.tfNameRelation?.textColor = UIColor(hexString: "#08121E")
            } else {
                self.tfNameRelation?.textColor = UIColor(hexString: "#DA3535")
            }
            return newString.count <= 50
        }
        
        if DataManager.shared.missingRelationsShip != nil {
            let phoneFormatted = FinPlusHelper.updatePhoneNumber(phone: newString as String)
            if self.currentIndex == 0 {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            } else {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            }
        }
        
        // Giới hạn ký tự nhập vào
        let maxLength = FinPlusHelper.getMaxLengthPhone1(phoneNumber: textField.text)
        return newString.count <= maxLength
    }
    
}

//MARK: Data Selected from popup
extension LoanTypePhoneRelationSubTBCell: DataSelectedFromPopupProtocol {
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.tfTypeRelation?.text = data.title!
        self.tfRelationPhone?.placeholder = "Số điện thoại của " + data.title!
        self.setupUI(id: Int(data.id ?? -1))
        
        //guard let data_ = self.data, let placeHolder = data_.placeholder else { return }
        if self.currentIndex == 0 {
            if DataManager.shared.loanInfo.userInfo.relationships.count > 0 {
                DataManager.shared.loanInfo.userInfo.relationships[0].type = data.id!
            }
        } else {
            if DataManager.shared.loanInfo.userInfo.relationships.count > 1 {
                DataManager.shared.loanInfo.userInfo.relationships[1].type = data.id!
            }
        }
    }
    
    func multiDataSelected(value: String, listIndex: String) {
        
    }
    
}

/*
//MARK: Address Delegate
extension LoanTypePhoneRelationSubTBCell: AddressDelegate {
    func getAddress(address: Address, type: Int, title: String, id: String) {
        let add = address.street + KeySeparateAddressFormatString + address.commune + KeySeparateAddressFormatString + address.district + KeySeparateAddressFormatString + address.city
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex {
            DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address = add
            self.lblAddressRelation?.text = add
        }
        
        self.checkInvalidPersionalRelationData()
    }
}

*/



