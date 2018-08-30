//
//  LoanTypePhoneRelationSubTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol UpdateStatusInvalidRelationPhoneDelegate {
    func update(isNeed: Bool)
}

class LoanTypePhoneRelationSubTBCell: UITableViewCell {
    
    
    @IBOutlet weak var tfTypeRelation: UITextField?
    
    @IBOutlet weak var tfRelationPhone: UITextField?
    
    var currentIndex: Int = 0
    
    var delegateUpdateStatusInvalid: UpdateStatusInvalidRelationPhoneDelegate?
    
    var data: LoanBuilderMultipleData? {
        didSet {
            guard let data_ = data else { return }
            self.tfRelationPhone?.placeholder = data_.placeholder
            self.tfRelationPhone?.text = data_.phoneNumber
            
            self.tfTypeRelation?.text = DataManager.getTitleRelationShip(id: data_.type ?? -1)
            
            if self.currentIndex == 0 {
                if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup1 {
                    if let options = data_.options, current < options.count {
                        self.tfRelationPhone?.text = options[current].title
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
                        self.tfRelationPhone?.text = options[current].title
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
    
    
    //MARK: Actions
    
    @IBAction func tfEditEnd(_ sender: Any) {
        if let value = self.tfRelationPhone?.text {
            //guard let data_ = data, let placeHolder = data_.placeholder else { return }
            if self.currentIndex == 0 {
                if DataManager.shared.loanInfo.userInfo.relationships.count > 0 {
                    DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber = value
                }
                
                if DataManager.shared.missingRelationsShip != nil {
                    if value != DataManager.shared.getPhoneInValid(index: "0") {
                        DataManager.shared.isRelationPhone1Invalid = false
                        self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                    }
                    self.updateStatus()
                }

                
            } else {
                if DataManager.shared.loanInfo.userInfo.relationships.count > 1 {
                    DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber = value
                }
                
                if DataManager.shared.missingRelationsShip != nil {
                    if value != DataManager.shared.getPhoneInValid(index: "1") {
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
        popup.setDataSource(data: dataSource, type: .RelationShipPhone)
        popup.indexRelationPhone = self.currentIndex
        popup.delegate = self
        
        popup.show()
    }
    

}

//MARK: TextField Delegate
extension LoanTypePhoneRelationSubTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        
        if DataManager.shared.missingRelationsShip != nil {
            if self.currentIndex == 0 {
                if textField.text != DataManager.shared.getPhoneInValid(index: "0") {
                    DataManager.shared.isRelationPhone1Invalid = false
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                    
                } else {
                    DataManager.shared.isRelationPhone1Invalid = true
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            } else {
                if textField.text != DataManager.shared.getPhoneInValid(index: "1") {
                    DataManager.shared.isRelationPhone2Invalid = false
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#08121E")
                } else {
                    DataManager.shared.isRelationPhone2Invalid = true
                    self.tfRelationPhone?.textColor = UIColor(hexString: "#DA3535")
                }
            }
            self.updateStatus()
        }
        
        
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
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
        //DataManager.shared.loanInfo.userInfo.relationships.type = data.id!
        
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
    

}





