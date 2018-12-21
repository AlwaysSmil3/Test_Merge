//
//  LoanTypeInputTextMuiltilineTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol ShowTextInputMesseageViewDelegate {
    func showTextInput(indexPath: IndexPath)
}

class LoanTypeInputTextMuiltiLineTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    
    
    @IBOutlet var lblValue: UILabel?
    
    var showInputViewDelegate: ShowTextInputMesseageViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        
        lblValue?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        lblValue?.addGestureRecognizer(tapGesture)
        
    }
    
    var currentIndex: IndexPath?
    
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
                self.lblValue?.text = value
                self.lblValue?.textColor = UIColor(red: 194/255, green: 194/255, blue: 201/255, alpha: 1.0)
            }
            
            if let text = field_.textInputMuiltiline, text.count > 0 {
                self.lblValue?.text = text
                self.lblValue?.textColor = UIColor(hexString: "#08121E")
            }
            
            
            self.getData()
            
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        guard let index = self.currentIndex else { return }
        
        self.showInputViewDelegate?.showTextInput(indexPath: index)
        
    }
    
    
    /// Check Other Invalid
    ///
    /// - Parameters:
    ///   - indexArray: <#indexArray description#>
    ///   - currentValue: <#currentValue description#>
    /// - Returns: <#return value description#>
    func checkOtherInfoInvalid(indexArray: String, currentValue: String) -> Bool {
        guard let data = DataManager.shared.missingOptionalText else { return false }
        if let value = data[indexArray] as? String, value == currentValue {
            return true
        }

        return false
    }
    
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        if id.contains("optionalText") {
            
            var index = 0
            if let i = field_.arrayIndex {
                index = i
            }
            
            guard let data = DataManager.shared.browwerInfo?.activeLoan?.optionalText, data.count > index, DataManager.shared.loanInfo.optionalText.count > index else { return }
            
            var value = ""
            if data.count > 0 {
                value = data[index]
            }
            
            if DataManager.shared.loanInfo.optionalText[index].length() > 0 {
                value = DataManager.shared.loanInfo.optionalText[index]
            }
            
            if value.length() > 0 {
                self.lblValue?.text = value
                self.lblValue?.textColor = UIColor(hexString: "#08121E")
                DataManager.shared.loanInfo.optionalText[index] = value
            }
            
            //thông tin khác
            if DataManager.shared.checkFieldIsMissing(key: "optionalText") && self.checkOtherInfoInvalid(indexArray: "\(index)", currentValue: value) {
                //Cap nhat thong tin khong hop le
                if let arrayIndex = field_.arrayIndex, let data = DataManager.shared.missingOptionalText {
                    if let text = data["\(arrayIndex)"] as? String {
                        //Cap nhat thong tin khong hop le
                        print(text)
                        
                        if self.valueTemp == nil {
                            
                        }
                        self.updateInfoFalse(pre: title)
                        self.valueTemp = value
                    }
                }
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("jobDescription") {
            var valueTemp: String?
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobDescription, data.count > 0 {
                valueTemp = data
            }
            
            if let desc = DataManager.shared.loanInfo.jobInfo.jobDescription, desc.count > 0 {
                valueTemp = desc
            }
            guard let value = valueTemp else { return }
            self.lblValue?.textColor = UIColor(hexString: "#08121E")
            self.lblValue?.text = value
            DataManager.shared.loanInfo.jobInfo.jobDescription = value
            
            
            if DataManager.shared.checkFieldIsMissing(key: "jobDescription", parentKey: "jobInfo", currentValue: value) {
                //Cap nhat thong tin khong hop le
                //self.updateInfoFalse(pre: title)
                if self.valueTemp == nil {
                    
                }
                self.updateInfoFalse(pre: title)
                self.valueTemp = value
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
        }
        
        
    }

    
    
    
}

