//
//  LoanTypeDropdownTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanTypeDropdownTBCell: LoanTypeBaseTBCell, DataSelectedFromPopupProtocol, LoanTypeTBCellProtocol {
    

    @IBOutlet var lblValue: UILabel?
    
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
                
                if let id = field_.id, id.contains("birthday"), let temp = self.valueTemp {
                    if temp == value {
                        self.updateInfoFalse(pre: field_.title ?? "")
                    } else {
                        self.isNeedUpdate = false
                    }
                }
            }
            
            //Cap nhat Data
            self.getData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected else { return }
        
        guard let field_ = self.field, let data = field_.data, let id = field_.id else { return }
        
        if id.contains("position") || id.contains("jobType") || id.contains("strength") || id.contains("academicLevel") {
            let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
            
            if id.contains("position") {
                popup.setDataSource(data: data, type: .JobPosition)
            } else if id.contains("jobType") {
                popup.setDataSource(data: data, type: .Job)
            } else if id.contains("strength") {
                popup.setDataSource(data: data, type: .Strength)
            } else if id.contains("academicLevel") {
                popup.setDataSource(data: data, type: .AcademicLevel)
            }
            
            popup.delegate = self
            
            popup.show()
        }
        
    }
    
    
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.isSelected = false
        
        var value = data.title ?? ""
        if let textValue = data.textValue {
            value = textValue
        }
        
        
        self.lblValue?.text = value
        
        guard let field_ = self.field, let id = field_.id else { return }
        
        if let temp = self.valueTemp {
            if temp == value {
                self.updateInfoFalse(pre: field_.title ?? "")
            } else {
                self.isNeedUpdate = false
            }
        }
        
        if id.contains("jobType") {
            DataManager.shared.loanInfo.jobInfo.jobType = Int(data.id ?? 0)
            DataManager.shared.loanInfo.jobInfo.jobTitle = value
        } else if id.contains("position") {
            DataManager.shared.loanInfo.jobInfo.position = Int(data.id ?? 0)
            DataManager.shared.loanInfo.jobInfo.positionTitle = value
        } else if id.contains("academicLevel") {
            DataManager.shared.loanInfo.jobInfo.academicLevel = Int(data.id ?? 0)
        } else if id.contains("strength") {
            DataManager.shared.loanInfo.jobInfo.strength = Int(data.id ?? 0)
        }
        
    }
    
    //Update Data khi co khoan vay
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        
        if id.contains("jobType") {
            
            var value = ""
            var type = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobTitle, data.length() > 0 {
                value = data
                type = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobType ?? 0
            }
            
            if DataManager.shared.loanInfo.jobInfo.jobTitle.length() > 0 {
                value = DataManager.shared.loanInfo.jobInfo.jobTitle
                type = DataManager.shared.loanInfo.jobInfo.jobType
            }
            
            if value.length() > 0 {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.jobTitle = value
                DataManager.shared.loanInfo.jobInfo.jobType = type
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "jobTitle", parentKey: "jobInfo", currentValue: value) || DataManager.shared.checkFieldIsMissing(key: "jobType", parentKey: "jobInfo", currentValue: "", currentValueIndex: type) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
                
            }
            
        } else if id.contains("position") {
            
            var value = ""
            var idInt = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.positionTitle, data.count > 0 {
                value = data
                idInt = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.position ?? 0
            }
            
            if DataManager.shared.loanInfo.jobInfo.positionTitle.count > 0 {
                idInt = DataManager.shared.loanInfo.jobInfo.position
                value = DataManager.shared.loanInfo.jobInfo.positionTitle
            }
            
            if value.count > 0 {

                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.position = idInt
                DataManager.shared.loanInfo.jobInfo.positionTitle = value
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "positionTitle", parentKey: "jobInfo", currentValue: value) || DataManager.shared.checkFieldIsMissing(key: "position", parentKey: "jobInfo", currentValue: "", currentValueIndex: idInt) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("birthday") {
            
            var value = ""
            var dateTemp = Date()
            
            if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.birthday, data.length() > 0 {
                value = data
                dateTemp = Date.init(fromString: value, format: DateFormat.custom("yyyy-MM-dd HH:mm:ssZ"))
            }
            
            if DataManager.shared.loanInfo.userInfo.birthDay.length() > 0 {
                value = DataManager.shared.loanInfo.userInfo.birthDay
                dateTemp = Date.init(fromString: value, format: DateFormat.custom(ISO8601Format.DateTimeSec.rawValue))
            }
            
            if value.length() > 0 {
                //let date1 = Date.init(fromString: value, format: DateFormat.custom("yyyy-MM-dd HH:mm:ssZ"))
                
                let date = dateTemp.toString(.custom(kDisplayFormat))
                //DateTime ISO 8601
                
                //let timeISO8601 = dateTemp.toString(.iso8601(ISO8601Format.DateTimeSec))
                let timeISO8601 = dateTemp.toString(.custom(DATE_FORMATTER_WITH_SERVER))
                DataManager.shared.loanInfo.userInfo.birthDay = timeISO8601
                self.lblValue?.text = date
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "birthday") {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = self.lblValue?.text
                    self.updateInfoFalse(pre: title)
                }
                
                if let miss = DataManager.shared.missingLoanDataDictionary, let userInfo = miss["userInfo"] as? JSONDictionary, let birtDay = userInfo["birthday"] as? String, Date.init(fromString: birtDay, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER)).toString(.custom(kDisplayFormat)) == self.lblValue?.text {
                    self.updateInfoFalse(pre: title)
                } else {
                    self.isNeedUpdate = false
                }
                
            }
            
        } else if id.contains("gender") {
            if DataManager.shared.checkFieldIsMissing(key: "gender") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.gender, data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.userInfo.gender.length() > 0 {
                value = DataManager.shared.loanInfo.userInfo.gender
            }
            
            if value.length() > 0 {
                if value == "1" {
                    self.lblValue?.text = "Nam"
                } else {
                    self.lblValue?.text = "Nữ"
                }
                
                DataManager.shared.loanInfo.userInfo.gender = value
            }
        } else if id.contains("strength") {
            
            var idInt = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.strength {
                idInt = data
            }
            
            if DataManager.shared.loanInfo.jobInfo.strength >= 0 {
                idInt = DataManager.shared.loanInfo.jobInfo.strength
            }
            
            var value = ""
            if idInt >= 0 {
                
                if let data = field_.data {
                    for d in data {
                        if Int(d.id ?? 0) == idInt {
                            value = d.title ?? ""
                        }
                    }
                }
                
                
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.strength = idInt
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "strength", parentKey: "jobInfo", currentValue: value, currentValueIndex: idInt) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.updateInfoFalse(pre: title)
                }
                self.valueTemp = self.lblValue?.text
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
        } else if id.contains("academicLevel") {
            
            var idInt = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicLevel {
                idInt = data
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicLevel >= 0 {
                idInt = DataManager.shared.loanInfo.jobInfo.academicLevel
            }
            
            var value = ""
            if idInt >= 0 {
                
                if let data = field_.data {
                    for d in data {
                        if Int(d.id ?? 0) == idInt {
                            value = d.title ?? ""
                        }
                    }
                }
                
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.academicLevel = idInt
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "academicLevel", parentKey: "jobInfo", currentValue: value, currentValueIndex: idInt) {
                //Cap nhat thong tin khong hop le
                //self.updateInfoFalse(pre: title)
                if self.valueTemp == nil {
                    self.updateInfoFalse(pre: title)
                }
                self.valueTemp = self.lblValue?.text
            } else {
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
        }  else if id.contains("optionalText") {
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
                //self.lblValue?.text = value
                
                let dateTemp = Date.init(fromString: value, format: DateFormat.custom(ISO8601Format.DateTimeSec.rawValue))
                let date = dateTemp.toString(.custom(kDisplayFormat))
                //DateTime ISO 8601
                
                //let timeISO8601 = dateTemp.toString(.iso8601(ISO8601Format.DateTimeSec))
                let timeISO8601 = dateTemp.toString(.custom(DATE_FORMATTER_WITH_SERVER))
                DataManager.shared.loanInfo.optionalText[index] = timeISO8601
                self.lblValue?.text = date
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                //Cap nhat thong tin khong hop le
                
                if let arrayIndex = field_.arrayIndex, let data = DataManager.shared.missingOptionalText {
                    
                    if let text = data["\(arrayIndex)"] as? String, DataManager.shared.loanInfo.optionalText[index] == text {
                        //Cap nhat thong tin khong hop le
                        print("OptionalText \(text)")
                        if self.valueTemp == nil {
                            self.valueTemp = self.lblValue?.text
                        }
                        self.updateInfoFalse(pre: title)
                        
                    } else {
                        if let need = self.isNeedUpdate, need {
                            self.isNeedUpdate = false
                        }
                    }
                }
                
            }
        }
        
    }
        
    
    
    
    
    
}

