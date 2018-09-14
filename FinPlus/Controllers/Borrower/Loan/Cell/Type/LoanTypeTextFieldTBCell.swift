//
//  LoanTypeTextFieldTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol TextFieldEditDidBeginDelegate {
    func textFieldEditDidBegin()
}

class LoanTypeTextFieldTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet var tfValue: UITextField?
    @IBOutlet var lblDOptional: UILabel?
    
    var delegateTextField: TextFieldEditDidBeginDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        self.tfValue?.delegate = self
        
        
    }
    
    var parent: String?
    
//    var valueTemp: String?
    
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
            
            if let id = field_.id {
                if id.contains("salary") || id.contains("companyPhoneNumber") || id.contains("experienceYear") {
                    self.tfValue?.keyboardType = .numberPad
                }
            }
            
            if let keyboard = field_.keyboard, keyboard.contains("money") || keyboard.contains("numeric") {
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
    
    @IBAction func tfDidBegin(_ sender: Any) {
        self.delegateTextField?.textFieldEditDidBegin()
    }
    
    
    @IBAction func tfEditEnd(_ sender: Any) {
        
        if let temp = self.valueTemp {
            if self.tfValue?.text! != temp {
                self.isNeedUpdate = false
            } else {
                self.isNeedUpdate = true
            }
        }
        
        guard let field_ = self.field, let id = field_.id else { return }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                //thông tin khác
//                let tempAmount1 = self.tfValue?.text?.replacingOccurrences(of: ",", with: "") ?? ""
//                let tempAmount2 = tempAmount1.replacingOccurrences(of: ".", with: "")
                
                if let index = field_.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                    DataManager.shared.loanInfo.optionalText[index] = self.tfValue?.text ?? ""
                }
                
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
            if id == "company" {
                DataManager.shared.loanInfo.jobInfo.company = self.tfValue?.text ?? ""
            }  else if id == "salary" {
                let tempAmount1 = self.tfValue?.text?.replacingOccurrences(of: ",", with: "") ?? ""
                let tempAmount2 = tempAmount1.replacingOccurrences(of: ".", with: "")
                DataManager.shared.loanInfo.jobInfo.salary = Int32(tempAmount2) ?? 0
            } else if id == "companyPhoneNumber"  {
                DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = self.tfValue?.text ?? ""
            } else if id == "experienceYear"  {
                DataManager.shared.loanInfo.jobInfo.experienceYear = Float(self.tfValue?.text ?? "") ?? 0
            } else if id == "studentId"  {
                DataManager.shared.loanInfo.jobInfo.studentId = self.tfValue?.text ?? ""
            } else if id == "academicName" {
                DataManager.shared.loanInfo.jobInfo.academicName = self.tfValue?.text ?? ""
            }
        }
    }
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                
                //thông tin khác
                
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
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.optionalText[index] = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                    //Cap nhat thong tin khong hop le
                    if let arrayIndex = field_.arrayIndex, let data = DataManager.shared.missingOptionalText {
                        
                        if let text = data["\(arrayIndex)"] as? String {
                            //Cap nhat thong tin khong hop le
                            print("OptionalText \(text)")
                            if self.valueTemp == nil {
                                self.updateInfoFalse(pre: title)
                            }
                            
                            self.valueTemp = value
                        }
                    }
                    
                }
            }
            
            return
        }
        
        if parent.contains("userInfo") {
            // thông tin user
            if id.contains("fullName") {

                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.fullName, data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.userInfo.fullName.length() > 0 {
                    value = DataManager.shared.loanInfo.userInfo.fullName
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.userInfo.fullName = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "fullName", parentKey: "userInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
                
            } else if id.contains("nationalId") {

                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.nationalId, data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.userInfo.nationalID.length() > 0 {
                    value = DataManager.shared.loanInfo.userInfo.nationalID
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.userInfo.nationalID = value
                }
                if DataManager.shared.checkFieldIsMissing(key: "nationalId", parentKey: "userInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
            }
            
        } else if parent.contains("jobInfo") {
            // Thông tin nghề nghiêp
            if id == "company" {
                
                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.company, data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.company.length() > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.company
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.jobInfo.company = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "company", parentKey: "jobInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
                
            }  else if id == "salary" {
                
                var value: Int32 = 0
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.salary, data > 0 {
                    value = Int32(data)
                }
                
                if DataManager.shared.loanInfo.jobInfo.salary > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.salary
                }
                
                if value > 0 {
                    self.tfValue?.text = FinPlusHelper.formatDisplayCurrency(Double(value))
                    DataManager.shared.loanInfo.jobInfo.salary = Int32(value)
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "salary") {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = FinPlusHelper.formatDisplayCurrency(Double(value))
                }
                
            } else if id == "companyPhoneNumber" {
                
                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.companyPhoneNumber , data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.companyPhoneNumber.length() > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.companyPhoneNumber
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "companyPhoneNumber", parentKey: "jobInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
            } else if id == "experienceYear" {
                
                var valueFloat: Float = 0
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.experienceYear , data > 0 {
                    valueFloat = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.experienceYear > 0 {
                    valueFloat = DataManager.shared.loanInfo.jobInfo.experienceYear
                }
                
                if valueFloat > 0 {
                    self.tfValue?.text = "\(Int(valueFloat))"
                    DataManager.shared.loanInfo.jobInfo.experienceYear = valueFloat
                }
                if DataManager.shared.checkFieldIsMissing(key: "experienceYear") {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = "\(Int(valueFloat))"
                }
            } else if id == "studentId" {
                
                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.studentId , data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.studentId.length() > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.studentId
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.jobInfo.studentId = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "studentId", parentKey: "jobInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
            } else if id == "academicName" {
                
                var value = ""
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicName , data.length() > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.academicName.length() > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.academicName
                }
                
                if value.length() > 0 {
                    self.tfValue?.text = value
                    DataManager.shared.loanInfo.jobInfo.academicName = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "academicName", parentKey: "jobInfo", currentValue: value) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = value
                }
            }
        }
        
    }
    
    
    
    
}

//MARK: TextField Delegate
extension LoanTypeTextFieldTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        
        let maxLength = self.getMaxLength()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if let temp = self.valueTemp {
            if newString as String != temp {
                self.isNeedUpdate = false
            } else {
                //self.isNeedUpdate = true
                self.updateInfoFalse(pre: self.field?.title ?? "")
            }
        }
        
        if newString.length > maxLength { return false }
        
        if let field_ = self.field, let id = field_.id {
            
            var bool = false
            if let parent = self.parent, parent.contains("jobInfo") ,id.contains("salary") {
                bool = true
            }
            
            if let keyboard = field_.keyboard, keyboard.contains("money") {
                bool = true
            }
            
            if bool {
                return self.formatTFSalary(textField, shouldChangeCharactersIn: range, replacementString: string)
            }
        }
        
        self.updateCurrentAmount(textField: textField)
        
        return true
    }
    
    fileprivate func formatTFSalary(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Uses the number format corresponding to your Locale
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        
        
        // Uses the grouping separator corresponding to your Locale
        // e.g. "," in the US, a space in France, and so on
        if let groupingSeparator = formatter.groupingSeparator {
            
            if string == groupingSeparator {
                self.updateCurrentAmount(textField: textField)
                return true
            }
            
            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string == "" { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.characters.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                    textField.text = formattedText
                    self.updateCurrentAmount(textField: textField)
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    fileprivate func updateCurrentAmount(textField: UITextField) {
        let tempAmount1 = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
        let tempAmount2 = tempAmount1.replacingOccurrences(of: ".", with: "")
        
        if let field_ = self.field, let id = field_.id {
            if let parent = self.parent, parent.contains("jobInfo") ,id.contains("salary") {
                DataManager.shared.loanInfo.jobInfo.salary = Int32(tempAmount2) ?? 0
                return
            }
            
            if id.contains("optionalText") {
                if let index = field_.arrayIndex, index < DataManager.shared.loanInfo.optionalText.count {
                    DataManager.shared.loanInfo.optionalText[index] = tempAmount2
                }
                
            }
        }

    }
    
    fileprivate func getMaxLength() -> Int {
        var maxLength = 100
        guard let field_ = self.field, let id = field_.id else { return maxLength }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                maxLength = 50
            }
            
            return maxLength
        }
        
        if parent.contains("userInfo") {
            // thông tin user
            if id.contains("fullName") {
                maxLength = 50
            } else if id.contains("nationalId") {
                maxLength = 15
            }
            
        } else if parent.contains("jobInfo") {
            // Thông tin nghề nghiêp
            if id.contains("salary") {
                maxLength = 13
            } else if id.contains("companyPhoneNumber") {
                maxLength = 11
            } else if id.contains("experienceYear") {
                maxLength = 3
            } else if id.contains("studentId") {
                maxLength = 12
            }
        }
        
        
        return maxLength
    }
}


