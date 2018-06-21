//
//  LoanTypeTextFieldTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeTextFieldTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet var tfValue: UITextField?
    @IBOutlet var lblDOptional: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        self.tfValue?.delegate = self
        
        
    }
    
    var parent: String?
    
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
            
            if let id = field_.id, id.contains("nationalId") || id.contains("salary") || id.contains("companyPhoneNumber") {
                self.tfValue?.keyboardType = .numberPad
            }
            
            if let value = field_.placeholder {
                self.tfValue?.placeholder = value
            }
            
            if let _ = field_.suffix {
                self.lblDOptional?.isHidden = false
            } else {
                self.lblDOptional?.isHidden = true
            }
            
            self.getData()
            
        }
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        
        guard let field_ = self.field, let id = field_.id else { return }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                //thông tin khác
                DataManager.shared.loanInfo.optionalText = self.tfValue?.text ?? ""
            }
            return
        }
        
        if parent.contains("userInfo") {
            // thông tin user
            if id.contains("fullName") {
                DataManager.shared.loanInfo.userInfo.fullName = self.tfValue?.text ?? ""
            } else if id.contains("nationalId") {
                DataManager.shared.loanInfo.userInfo.nationalID = self.tfValue?.text ?? ""
            }
            
        } else if parent.contains("jobInfo") {
            // Thông tin nghề nghiêp
            if id.contains("company") {
                DataManager.shared.loanInfo.jobInfo.company = self.tfValue?.text ?? ""
            }  else if id.contains("salary") {
                DataManager.shared.loanInfo.jobInfo.salary = Int32(self.tfValue?.text ?? "") ?? 0
            } else if id.contains("companyPhoneNumber") {
                DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = self.tfValue?.text ?? ""
            }
        }
    }
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                //thông tin khác
                if let data = DataManager.shared.browwerInfo?.activeLoan?.optionalText {
                    self.tfValue?.text = data
                    DataManager.shared.loanInfo.optionalText = data
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
            }
            
            return
        }
        
        if parent.contains("userInfo") {
            // thông tin user
            if id.contains("fullName") {
                if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.fullName {
                    self.tfValue?.text = data
                    DataManager.shared.loanInfo.userInfo.fullName = data
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
                
            } else if id.contains("nationalId") {
                if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.nationalId {
                    self.tfValue?.text = data
                    DataManager.shared.loanInfo.userInfo.nationalID = data
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
            }
            
        } else if parent.contains("jobInfo") {
            // Thông tin nghề nghiêp
            if id.contains("company") {
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.company {
                    self.tfValue?.text = data
                    DataManager.shared.loanInfo.jobInfo.company = data
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
                
            }  else if id.contains("salary") {
                
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.salary {
                    self.tfValue?.text = "\(data)"
                    DataManager.shared.loanInfo.jobInfo.salary = Int32(data)
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
                
            } else if id.contains("companyPhoneNumber") {
                
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.companyPhoneNumber {
                    self.tfValue?.text = data
                    DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = data
                } else {
                    //Cap nhat thong tin thieu
                    self.updateInfoFalse(pre: title)
                    
                }
            }
        }
        
    }
    
    
    
    
}

//MARK: TextField Delegate
extension LoanTypeTextFieldTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 100
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
}


