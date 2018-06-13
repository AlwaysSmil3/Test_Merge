//
//  LoanTypeTextFieldTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeTextFieldTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var tfValue: UITextField?
    @IBOutlet var lblDOptional: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
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
                
                if title.contains("chứng minh thư") || title.contains("Thu nhập hàng tháng") || title.contains("Lương hàng tháng của bạn") || title.contains("SĐT cơ quan") {
                    self.tfValue?.keyboardType = .numberPad
                }
            }
            
            if let value = field_.placeholder {
                self.tfValue?.placeholder = value
            }
            
            if let _ = field_.suffix {
                self.lblDOptional?.isHidden = false
            } else {
                self.lblDOptional?.isHidden = true
            }
            
        }
    }
    
    @IBAction func tfEditEnd(_ sender: Any) {
        guard let field_ = self.field, let title = field_.title else { return }
        
        if title.contains("Họ và tên") {
            DataManager.shared.loanInfo.userInfo.fullName = self.tfValue?.text ?? ""
        }
        else if title.contains("chứng minh thư") {
            DataManager.shared.loanInfo.userInfo.nationalID = self.tfValue?.text ?? ""
        }
        
        else if title.contains("Tên cơ quan") {
            DataManager.shared.loanInfo.jobInfo.company = self.tfValue?.text ?? ""
        }
            
        else if title.contains("Thu nhập hàng tháng") {
            DataManager.shared.loanInfo.jobInfo.salary = Int32(self.tfValue?.text ?? "") ?? 0
        }
        
        else if title.contains("SĐT cơ quan") {
            DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = self.tfValue?.text ?? ""
        }
        
        else if title.contains("Lương hàng tháng của bạn") {
            DataManager.shared.loanInfo.optionalText = self.tfValue?.text ?? ""
        }
    }
    
    
    
}

