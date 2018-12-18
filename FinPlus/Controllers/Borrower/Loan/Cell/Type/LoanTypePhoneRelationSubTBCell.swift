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

class LoanTypePhoneRelationSubTBCell: UITableViewCell {
    
    
    @IBOutlet weak var tfTypeRelation: UITextField?
    
    @IBOutlet weak var lblTitlePhone: UILabel?
    @IBOutlet weak var tfRelationPhone: UITextField?
    
    @IBOutlet weak var lblNameRelationTitle: UILabel?
    @IBOutlet weak var tfNameRelation: UITextField?
    
    @IBOutlet weak var lblAddressRelationTitle: UILabel?
    @IBOutlet weak var lblAddressRelation: UILabel?
    
    
    var currentIndex: Int = 0
    
    weak var parentVC: LoanBaseViewController?
    
    weak var delegateUpdateStatusInvalid: UpdateStatusInvalidRelationPhoneDelegate?
    
    var data: LoanBuilderMultipleData? {
        didSet {
            guard let data_ = data else { return }
            self.tfRelationPhone?.placeholder = data_.placeholder
            //self.tfRelationPhone?.text = data_.phoneNumber
            self.tfRelationPhone?.text = self.getDisplayPhone(relationPhone: data_.phoneNumber ?? "")
            
            self.tfTypeRelation?.text = DataManager.getTitleRelationShip(id: data_.type ?? -1)
            self.setupUI(id: data_.type ?? -1)
            
            if self.currentIndex == 0 {
                if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup1 {
                    if let options = data_.options, current < options.count {
                        //self.tfRelationPhone?.text = options[current].title
                    }
                }
                
                if DataManager.shared.isRelationPhone1Invalid {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                }
                
            } else {
                if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup2 {
                    if let options = data_.options, current < options.count {
                        //self.tfRelationPhone?.text = options[current].title
                    }
                }
                
                if DataManager.shared.isRelationPhone2Invalid {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                } else {
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tfRelationPhone?.delegate = self
        if #available(iOS 11.0, *) {
            self.tfRelationPhone?.textContentType = .username
        }
        
        self.lblAddressRelationTitle?.font = FONT_CAPTION
        self.lblAddressRelationTitle?.textColor = TEXT_NORMAL_COLOR
    }
    
    private func setupUI(id: Int) {
        let number = self.getTitleTypeRelation(id: id)
        let text = number == "1" || number == "2" ? "người thân \(number)" : "của \(number)"
        
        self.lblTitlePhone?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: "Số điện thoại liên lạc \(text)")
        self.lblNameRelationTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: "Họ và tên \(text)")
        self.tfNameRelation?.placeholder = "Nhập họ và tên \(text)"
        
        self.lblAddressRelationTitle?.text = "Địa chỉ \(text)"
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex, let name = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].name, name.count > 0 {
            self.tfNameRelation?.text = name
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex, let add = DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address, add.count > 0  {
            self.lblAddressRelation?.text = add
        } else {
            self.lblAddressRelation?.text = "Nhấn để chọn địa chỉ \(text)"
        }
        
        
    }
    
    private func getTitleTypeRelation(id: Int) -> String {
        let text = self.currentIndex == 0 ? "1" : "2"
        guard let cate = DataManager.shared.getCurrentCategory(), (cate.builders?.count ?? 0) > 0, let fields = cate.builders![0].fieldsDisplay else { return text }
        
        var field: LoanBuilderFields?
        for f in fields {
            if f.id == "relationships" {
                field = f
                break
            }
        }
        
        guard let muiltiData = field?.multipleData else { return text }
        
        for mu in muiltiData {
            if let options = mu.options {
                for op in options {
                    if id == Int(op.id ?? 0) {
                        return op.title ?? text
                    }
                }
            }
        }
        
        return text
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
    
    private func getDisplayPhone(relationPhone: String) -> String {
        var phone = relationPhone
        if relationPhone.contains("_") {
            let array = relationPhone.components(separatedBy: "_")
            if array.count > 0 {
                phone = array[0]
            }
        }
        return FinPlusHelper.updatePhoneNumber(phone:phone)
    }
    
    /// Sang màn chọn địa chỉ
    private func gotoAddressVC(title: String, id: String) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        firstAddressVC.titleString = title
        firstAddressVC.id = id
        
        self.parentVC?.show(firstAddressVC, sender: nil)
    }
    
    
    //MARK: Actions
    
    @IBAction func btnAddressTapped(_ sender: Any) {
        let title = self.lblAddressRelationTitle?.text ?? "Địa chỉ người thân \(self.currentIndex + 1)"
        let id = "RelationAddress\(self.currentIndex + 1)"
        self.gotoAddressVC(title: title, id: id)
    }
    
    @IBAction func tfNameEditEnd(_ sender: Any) {
        
        guard let value = self.tfNameRelation?.text else { return }
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex {
            DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].name = value
        }
        
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        if let value = self.tfRelationPhone?.text {
            //guard let data_ = data, let placeHolder = data_.placeholder else { return }
            let valueTemp = FinPlusHelper.updatePhoneNumber(phone: value)
            
            if self.currentIndex == 0 {
                if DataManager.shared.loanInfo.userInfo.relationships.count > 0 {
                    DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber = valueTemp
                }
                
                if DataManager.shared.missingRelationsShip != nil {
                    if valueTemp != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                        DataManager.shared.isRelationPhone1Invalid = false
                        self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                    }
                    self.updateStatus()
                }

                
            } else {
                if DataManager.shared.loanInfo.userInfo.relationships.count > 1 {
                    DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber = valueTemp
                }
                
                if DataManager.shared.missingRelationsShip != nil {
                    if valueTemp != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                        DataManager.shared.isRelationPhone2Invalid = false
                        self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                    }
                    self.updateStatus()
                }
                
            }
            
        }
    }
    
    @IBAction func btnTypeRelationTapped(_ sender: Any) {
        guard let data_ = self.data, let options = data_.options else { return }
        
        var dataSource: [LoanBuilderData] = []
        for i in options {
            var da = LoanBuilderData(object: NSObject())
            da.id = i.id
            da.title = i.title
            dataSource.append(da)
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
        
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if DataManager.shared.missingRelationsShip != nil {
            let phoneFormatted = FinPlusHelper.updatePhoneNumber(phone: newString as String)
            if self.currentIndex == 0 {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                    DataManager.shared.isRelationPhone1Invalid = false
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                    
                } else {
                    DataManager.shared.isRelationPhone1Invalid = true
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            } else {
                if phoneFormatted != DataManager.shared.getPhoneInValid(type: self.data?.type ?? 0) {
                    DataManager.shared.isRelationPhone2Invalid = false
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    DataManager.shared.isRelationPhone2Invalid = true
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            }
            self.updateStatus()
        }
        
        // Giới hạn ký tự nhập vào
        let maxLength = FinPlusHelper.getMaxLengthPhone1(phoneNumber: textField.text)
        
        if newString.length > maxLength { return false }
        
        return true
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

//MARK: Address Delegate
extension LoanTypePhoneRelationSubTBCell: AddressDelegate {
    func getAddress(address: Address, type: Int, title: String, id: String) {
        let add = address.street + ", " + address.commune + ", " + address.district + ", " + address.city
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > self.currentIndex {
            DataManager.shared.loanInfo.userInfo.relationships[self.currentIndex].address = add
            self.lblAddressRelation?.text = add
        }
        
        
    }
}





