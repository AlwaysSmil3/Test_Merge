//
//  LoanTypeTextViewTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/26/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeTextViewTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    
    @IBOutlet var tfValue: AnimatableTextView?
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
            
            if let value = field_.placeholder {
                self.tfValue?.placeholderText = value
            }
            
            if let _ = field_.suffix {
                self.lblDOptional?.isHidden = false
            } else {
                self.lblDOptional?.isHidden = true
            }
            
            self.getData()
            
        }
    }
    
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
            if id.contains("optionalText") {
                //thông tin khác
                if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                    //Cap nhat thong tin khong hop le
                    self.updateInfoFalse(pre: title)
                }
                
                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.optionalText, data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.optionalText.length() > 0 {
                    value = DataManager.shared.loanInfo.optionalText
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.optionalText = value
                }
            }
            
        
    }

}

//MARK: AnimatedTextInputDelegate
extension LoanTypeTextViewTBCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let field_ = self.field, let id = field_.id else { return }
            if id.contains("optionalText") {
                //thông tin khác
                DataManager.shared.loanInfo.optionalText = self.tfValue?.text ?? ""
            }
        
    }
    
    
}





