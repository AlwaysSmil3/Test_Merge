//
//  LoanTypeRelationPhoneTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypePhoneRelationTBCell: LoanTypeBaseTBCell, DataSelectedFromPopupProtocol, LoanTypeTBCellProtocol {
    

    @IBOutlet var tfValue: UITextField?
    @IBOutlet var lblTypeRelation: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        self.tfValue?.delegate = self
    }
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                if field_.isRequired! {
                    self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
                } else {
                    self.lblTitle?.text = title
                }
            }
            
            if let value = field_.placeholder {
                self.tfValue?.placeholder = value
            }
            
            self.getData()
        }
    
    }
    
    
    @IBAction func btnDropdownTapped(_ sender: Any) {
        guard let field_ = self.field, let data = field_.data else { return }
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.setDataSource(data: data, type: .RelationShipPhone)
        popup.delegate = self
        
        popup.show()
    }
    
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.lblTypeRelation?.text = data.title!
        self.tfValue?.placeholder = "Số điện thoại của " + data.title!
        DataManager.shared.loanInfo.userInfo.relationships.type = data.id!
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        if let value = self.tfValue?.text {
            DataManager.shared.loanInfo.userInfo.relationships.phoneNumber = value
        }
    }
    
    func getData() {
        if DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships?.phoneNumber != nil {
            self.tfValue?.text = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships?.phoneNumber
        }else {
            //Cap nhat thong tin thieu
            guard let field_ = self.field, let title = field_.title else { return }
            self.updateInfoFalse(pre: title)
            
        }
    }
    
    
}

//MARK: TextField Delegate
extension LoanTypePhoneRelationTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    
}


