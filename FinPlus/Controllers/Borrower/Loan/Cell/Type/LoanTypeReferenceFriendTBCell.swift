//
//  LoanTypeReferenceFriendTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 1/2/19.
//  Copyright © 2019 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeReferenceFriendTBCell: LoanTypeBaseRelationTBCell {
    
    @IBOutlet weak var lblLoanPurposeTitle: UILabel?
    @IBOutlet weak var tfLoanPurpose: UITextField?
    
    
    var data: LoanBuilderMultipleData? {
        didSet {
            guard let data_ = data else { return }
            self.tfRelationPhone?.placeholder = data_.placeholder
            
            self.tfRelationPhone?.text = self.getDisplayPhone(relationPhone: data_.phoneNumber ?? "")
            
            let temp = DataManager.getTitleRelationShip(id: data_.type ?? -1, key: "referenceFriend")
            self.tfTypeRelation?.text = temp == "Người thân" ? "Người vay cùng" : temp.replacingOccurrences(of: "Người vay cùng", with: "...")
            
            self.setupUI()
            
            self.checkInvalidReferenceFriendData()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tfRelationPhone?.delegate = self
        self.tfNameRelation?.delegate = self
        if #available(iOS 11.0, *) {
            self.tfRelationPhone?.textContentType = .username
        }
        
        self.lblAddressRelationTitle?.font = FONT_CAPTION
        self.lblAddressRelationTitle?.textColor = TEXT_NORMAL_COLOR
    }
    
    private func setupUI() {

        self.tfNameRelation?.placeholder = "Nhập họ và tên"
        self.tfRelationPhone?.placeholder = "Nhập số điện thoại"
        
        self.lblAddressRelationTitle?.text = "Địa chỉ"
        
        if let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex, let name = DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].name, name.count > 0 {
            self.tfNameRelation?.text = name
        } else {
            self.tfNameRelation?.text = ""
        }
        
        if let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex, let add = DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].address, add.count > 0  {
            self.lblAddressRelation?.text = add
        } else {
            self.lblAddressRelation?.text = "Nhấn để chọn địa chỉ"
        }
        
        
    }
    
    
    /// Sang màn chọn địa chỉ
    private func gotoAddressVC(title: String, id: String) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        firstAddressVC.titleString = title
        firstAddressVC.id = id
        
        if let references = DataManager.shared.loanInfo.userInfo.referenceFriend, references.count > self.currentIndex {
            firstAddressVC.addressStringValue = DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].address
        }
        
        self.parentVC?.show(firstAddressVC, sender: nil)
    }
    
    
    //MARK: Actions
    
    @IBAction func btnAddressTapped(_ sender: Any) {
        self.parentVC?.view.endEditing(true)
        let title = self.lblAddressRelationTitle?.text ?? "Địa chỉ người thân \(self.currentIndex + 1)"
        let id = "ReferenceFriendAddress\(self.currentIndex + 1)"
        self.gotoAddressVC(title: title, id: id)
    }
    
    @IBAction func tfNameEditEnd(_ sender: Any) {
        
        guard let value = self.tfNameRelation?.text else { return }
        guard let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex else { return }
        DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].name = value

        self.checkInvalidReferenceFriendData()
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        guard let value = self.tfRelationPhone?.text else { return }
        
        let valueTemp = FinPlusHelper.updatePhoneNumber(phone: value)
        guard let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex else { return }
        DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].phoneNumber = valueTemp
        
        self.checkInvalidReferenceFriendData()
    }
    
    @IBAction func tfLoanPurposeEditEnd(_ sender: Any) {
        guard let value = self.tfLoanPurpose?.text else { return }
        guard let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex else { return }
        DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].loanPurpose = value
        self.checkInvalidReferenceFriendData()
    }
    
    @IBAction func btnTypeRelationTapped(_ sender: Any) {
        guard let data_ = self.data, let options = data_.options else { return }
        
        var dataSource: [LoanBuilderData] = []
        
        for op in options {
            var da = LoanBuilderData(object: NSObject())
            da.id = op.id
            da.title = op.title
            dataSource.append(da)
        }
        
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.indexRelationPhone = self.currentIndex
        popup.setDataSource(data: dataSource, type: .ReferenceFriend)
        popup.delegate = self
        
        popup.show()
    }
    
}


//MARK: TextField Delegate
extension LoanTypeReferenceFriendTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if self.currentIndex < DataManager.shared.loanInfo.userInfo.relationships.count {
//            if DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].type < 0 {
//                UIApplication.shared.topViewController()?.showToastWithMessage(message: "Vui lòng chọn người thân \(self.currentIndex + 1) để tiếp tục.")
//                return false
//            }
//        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        guard textField == self.tfRelationPhone else {
            if textField == self.tfNameRelation {
                if DataManager.shared.checkNameRelationInvalid(name: newString as String, index: self.currentIndex, key: "referenceFriend") {
                    self.tfNameRelation?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfNameRelation?.textColor = UIColor(hexString: "#DA3535")
                }
            } else if textField == self.tfLoanPurpose {
                if DataManager.shared.checkNameRelationInvalid(name: newString as String, index: self.currentIndex, key: "referenceFriend", subKey: "loanPurpose") {
                    self.tfLoanPurpose?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfLoanPurpose?.textColor = UIColor(hexString: "#DA3535")
                }
            }
            
            
            if newString.length > 50 { return false }
            
            return true
        }
        
        if DataManager.shared.missingReferenceFriend != nil {
            let phoneFormatted = FinPlusHelper.updatePhoneNumber(phone: newString as String)
            if self.currentIndex == 0 {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0, key: "referenceFriend", countItems: 3) {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            } else {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0, key: "referenceFriend", countItems: 3) {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            }
        }
        
        // Giới hạn ký tự nhập vào
        let maxLength = FinPlusHelper.getMaxLengthPhone1(phoneNumber: textField.text)
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    
}

//MARK: Data Selected from popup
extension LoanTypeReferenceFriendTBCell: DataSelectedFromPopupProtocol {
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.tfTypeRelation?.text = data.title!.replacingOccurrences(of: "Người vay cùng", with: "...")
        //self.tfRelationPhone?.placeholder = "Số điện thoại của " + data.title!
        
        DataManager.shared.checkAndInitReferenceFriend()
        guard let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex else { return }
        
        DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].type = data.id!
    }
    
    func multiDataSelected(value: String, listIndex: String) {
        
    }
    
}

//MARK: Address Delegate
extension LoanTypeReferenceFriendTBCell: AddressDelegate {
    func getAddress(address: Address, type: Int, title: String, id: String) {
        let add = address.street + KeySeparateAddressFormatString + address.commune + KeySeparateAddressFormatString + address.district + KeySeparateAddressFormatString + address.city
        
        DataManager.shared.checkAndInitReferenceFriend()
        guard let referenceFriend = DataManager.shared.loanInfo.userInfo.referenceFriend, referenceFriend.count > self.currentIndex else { return }
        DataManager.shared.loanInfo.userInfo.referenceFriend?[self.currentIndex].address = add
        self.lblAddressRelation?.text = add
        
        self.checkInvalidReferenceFriendData()
    }
}

//MARK: Check invalid Data
extension LoanTypeReferenceFriendTBCell {
    
    //MARK: Check invalid
    private func checkInvalidReferenceFriendData() {
        guard DataManager.shared.missingReferenceFriend != nil else { return }
        
        let bool1 = self.checkInvalidPhoneNumber()
        let bool2 = self.checkInvalidName()
        let bool3 = self.checkInvalidAddress()
        let bool4 = self.checkInvalidLoanPurpose()
        
        if self.currentIndex == 0 {
            if bool1, bool2, bool3, bool4 {
                DataManager.shared.isReferenceFriend1Invalid = false
            } else {
                DataManager.shared.isReferenceFriend1Invalid = true
            }
            
        } else if self.currentIndex == 1 {
            if bool1, bool2, bool3, bool4 {
                DataManager.shared.isReferenceFriend2Invalid = false
            } else {
                DataManager.shared.isReferenceFriend2Invalid = true
            }
        } else {
            if bool1, bool2, bool3, bool4 {
                DataManager.shared.isReferenceFriend3Invalid = false
            } else {
                DataManager.shared.isReferenceFriend3Invalid = true
            }
            
        }
        self.updateStatus()
    }
    
    
    /// Check invalid LoanPurpose
    ///
    /// - Returns: <#return value description#>
    private func checkInvalidLoanPurpose() -> Bool {
        guard let value = self.tfLoanPurpose?.text else { return true }
        
        if DataManager.shared.checkNameRelationInvalid(name: value, index: self.currentIndex, key: "referenceFriend", subKey: "loanPurpose") {
            self.tfLoanPurpose?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        
        self.tfLoanPurpose?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    
    /// Check invalid Phone
    ///
    /// - Returns: <#return value description#>
    private func checkInvalidPhoneNumber() -> Bool {
        guard let value = self.tfRelationPhone?.text, DataManager.shared.missingReferenceFriend != nil else { return true }
        
        let valueTemp = FinPlusHelper.updatePhoneNumber(phone: value)
        
        if valueTemp != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0, key: "referenceFriend", countItems: 3) {
            self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
            return true
        } else {
            self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
            return false
            
        }
    }
    
    
    /// Check invalid Name
    ///
    /// - Returns: <#return value description#>
    private func checkInvalidName() -> Bool {
        guard let value = self.tfNameRelation?.text else { return true }
        
        if DataManager.shared.checkNameRelationInvalid(name: value, index: self.currentIndex, key: "referenceFriend") {
            self.tfNameRelation?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        
        self.tfNameRelation?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    
    /// Check invalid Address
    ///
    /// - Returns: <#return value description#>
    private func checkInvalidAddress() -> Bool {
        guard let references = DataManager.shared.loanInfo.userInfo.referenceFriend, self.currentIndex < references.count, let add = references[self.currentIndex].address else { return true }
        
        if DataManager.shared.checkAddressRelationInvalid(address: add, index: self.currentIndex, key: "referenceFriend") {
            self.lblAddressRelation?.textColor = UIColor(hexString: "#08121E")
            return true
        }
        
        self.lblAddressRelation?.textColor = UIColor(hexString: "#DA3535")
        return false
    }
    
    
    func updateStatus() {
        if !DataManager.shared.isReferenceFriend1Invalid && !DataManager.shared.isReferenceFriend2Invalid && !DataManager.shared.isReferenceFriend3Invalid {
            self.delegateUpdateStatusInvalid?.update(isNeed: false)
            userDefault.set("", forKey: UserDefaultInValidRelationPhone)
            userDefault.synchronize()
        } else {
            self.delegateUpdateStatusInvalid?.update(isNeed: true)
        }
    }
    
    
}


