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
            
            if let keyboard = field_.keyboard, keyboard.contains("money") || keyboard.contains("numeric") || keyboard.contains("phone_pad") {
                self.tfValue?.keyboardType = .numberPad
            } else {
                self.tfValue?.keyboardType = .default
            }
            
            if #available(iOS 11.0, *) {
                self.tfValue?.textContentType = .username
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
                if self.isNeedUpdate == true {
                    self.isNeedUpdate = false
                }
                
            } else {
                //self.isNeedUpdate = true
                self.updateInfoFalse(pre: self.field?.title ?? "")
            }
        }
        
        guard let field_ = self.field, let id = field_.id else { return }
        guard let parent = self.parent else {
            if id.contains("optionalText") {
                //thông tin khác
                if let index = field_.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                    if let keyboard = self.field?.keyboard, keyboard.contains("money") {
                        let temp = (self.tfValue?.text ?? "").replacingOccurrences(of: ",", with: "")
                        let temp1 = temp.replacingOccurrences(of: ".", with: "")
                        DataManager.shared.loanInfo.optionalText[index] = temp1
                    } else {
                        DataManager.shared.loanInfo.optionalText[index] = self.tfValue?.text ?? ""
                    }
                    
                }
                
            } else if id.contains("totalAmountLoaned") {
                
                DataManager.shared.loanInfo.totalBorrowedAmount = self.getAmountMoney()
                
            }
            return
        }
        
        if parent.contains("userInfo") {
            // thông tin user
            if id.contains("fullName") {
                DataManager.shared.loanInfo.userInfo.fullName = self.tfValue?.text ?? ""
            } else if id.contains("nationalId") {
                DataManager.shared.loanInfo.userInfo.nationalID = self.tfValue?.text ?? ""
            } else if id.contains("phoneUsageTime") {
                if let text = self.tfValue?.text, text.count > 0 {
                    DataManager.shared.loanInfo.userInfo.phoneUsageTime = Int(text)
                }
                
            }
            
        } else if parent.contains("jobInfo") {
            // Thông tin nghề nghiêp
            if id == "company" {
                DataManager.shared.loanInfo.jobInfo.company = self.tfValue?.text ?? ""
            }  else if id == "salary" {
                let tempAmount1 = self.tfValue?.text?.replacingOccurrences(of: ",", with: "") ?? ""
                let tempAmount2 = tempAmount1.replacingOccurrences(of: ".", with: "")
                DataManager.shared.loanInfo.jobInfo.salary = Double(tempAmount2) ?? 0
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
                    
                    if let keyboard = self.field?.keyboard, keyboard.contains("money") {
                        if !value.contains(",") && !value.contains(".") {
                            let temp = value
                            DataManager.shared.loanInfo.optionalText[index] = temp
                            value = self.formatDisplayCurrency(Double(temp) ?? 0)
                            self.tfValue?.text = value
                            
                        } else {
                            self.tfValue?.text = value
                            let temp = value.replacingOccurrences(of: ",", with: "")
                            let temp1 = temp.replacingOccurrences(of: ".", with: "")
                            DataManager.shared.loanInfo.optionalText[index] = temp1
                        }
                    } else {
                        self.tfValue?.text = value
                        let temp = value.replacingOccurrences(of: ",", with: "")
                        let temp1 = temp.replacingOccurrences(of: ".", with: "")
                        DataManager.shared.loanInfo.optionalText[index] = temp1
                    }
                    
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                    //Cap nhat thong tin khong hop le
                    if let arrayIndex = field_.arrayIndex, let data = DataManager.shared.missingOptionalText {
                        
                        if let text = data["\(arrayIndex)"] as? String, text == DataManager.shared.loanInfo.optionalText[index] {
                            //Cap nhat thong tin khong hop le
                            print("OptionalText \(text)")
                            if self.valueTemp == nil {
                                self.valueTemp = value
                            }
                            self.updateInfoFalse(pre: title)
                            
                        } else {
                            if let need = self.isNeedUpdate, need {
                                self.isNeedUpdate = false
                            }
                        }
                    }
                }
            } else if id.contains("totalAmountLoaned") {
                var valueTemp: Double?
                if let data = DataManager.shared.browwerInfo?.activeLoan?.totalBorrowedAmount {
                    valueTemp = data
                }
                
                if let total = DataManager.shared.loanInfo.totalBorrowedAmount {
                    valueTemp = total
                }
                
                guard let value = valueTemp else { return }
                
                self.tfValue?.text = self.formatDisplayCurrency(Double(value))
                DataManager.shared.loanInfo.totalBorrowedAmount = value
                
                if DataManager.shared.checkFieldIsMissing(key: "totalAmountLoaned") {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = self.formatDisplayCurrency(Double(value))
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
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
                    
                    if self.valueTemp == nil {
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = value
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
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
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = value
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
                }
            } else if id.contains("phoneUsageTime") {
                var valueInt: Int = -1
                if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.phoneUsageTime {
                    valueInt = data
                }
                
                if let uses = DataManager.shared.loanInfo.userInfo.phoneUsageTime {
                    valueInt = uses
                }
                
                if valueInt > 0 {
                    self.tfValue?.text = "\(valueInt)"
                    DataManager.shared.loanInfo.userInfo.phoneUsageTime = valueInt
                } else {
                    self.tfValue?.text = ""
                }
                if DataManager.shared.checkFieldIsMissing(key: "phoneUsageTime", parentKey: "userInfo", currentValueIndex: valueInt) {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        self.updateInfoFalse(pre: title)
                    }
                    self.valueTemp = "\(Int(valueInt))"
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
                }
            } else {
                self.tfValue?.text = ""
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
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = value
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
                }
                
            }  else if id == "salary" {
                
                var value: Double = 0
                if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.salary, data > 0 {
                    value = data
                }
                
                if DataManager.shared.loanInfo.jobInfo.salary > 0 {
                    value = DataManager.shared.loanInfo.jobInfo.salary
                }
                
                if value > 0 {
                    self.tfValue?.text = self.formatDisplayCurrency(Double(value))
                    DataManager.shared.loanInfo.jobInfo.salary = value
                }
                
                if DataManager.shared.checkFieldIsMissing(key: "salary") {
                    //Cap nhat thong tin khong hop le
                    //self.updateInfoFalse(pre: title)
                    if self.valueTemp == nil {
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = self.formatDisplayCurrency(Double(value))
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
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
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = value
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
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
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = "\(Int(valueFloat))"
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
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
                        
                    }
                    self.updateInfoFalse(pre: title)
                    self.valueTemp = value
                } else {
                    if let need = self.isNeedUpdate, need {
                        self.isNeedUpdate = false
                    }
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
    
    
    /// Lấy số tiền double
    ///
    /// - Returns: <#return value description#>
    private func getAmountMoney() -> Double {
        let tempAmount1 = self.tfValue?.text?.replacingOccurrences(of: ",", with: "") ?? ""
        let tempAmount2 = tempAmount1.replacingOccurrences(of: ".", with: "")
        return Double(tempAmount2) ?? 0
    }
    
     func formatDisplayCurrency(_ value: Double) -> String {
        let valueNumber = value as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0;
        
        let stringFormatVND = formatter.string(from: valueNumber)!
        //let stringFormatVNDResult = stringFormatVND.replacingOccurrences(of: ",", with: ".")
        
        return stringFormatVND
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
                    totalTextWithoutGroupingSeparators = String(totalTextWithoutGroupingSeparators.dropLast())
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
                DataManager.shared.loanInfo.jobInfo.salary = Double(tempAmount2) ?? 0
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
        
        var maxLength = 50
        
        if let length = self.field?.maxLenght {
            maxLength = length
        }
        
        return maxLength
    }
}


