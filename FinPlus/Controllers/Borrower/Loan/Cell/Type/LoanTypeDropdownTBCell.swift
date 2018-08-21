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
            if DataManager.shared.checkFieldIsMissing(key: "jobType") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
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
        } else if id.contains("position") {
            if DataManager.shared.checkFieldIsMissing(key: "position") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
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
        } else if id.contains("birthday") {
            if DataManager.shared.checkFieldIsMissing(key: "birthday") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
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
                let timeISO8601 = dateTemp.toString(.custom("yyyy-MM-dd'T'HH:mm:ssXXX"))
                DataManager.shared.loanInfo.userInfo.birthDay = timeISO8601
                self.lblValue?.text = date
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
            if DataManager.shared.checkFieldIsMissing(key: "strength") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var idInt = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.strength {
                idInt = data
            }
            
            if DataManager.shared.loanInfo.jobInfo.strength >= 0 {
                idInt = DataManager.shared.loanInfo.jobInfo.strength
            }
            
            if idInt >= 0 {
                var value = ""
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
        } else if id.contains("academicLevel") {
            if DataManager.shared.checkFieldIsMissing(key: "academicLevel") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var idInt = -1
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicLevel {
                idInt = data
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicLevel >= 0 {
                idInt = DataManager.shared.loanInfo.jobInfo.academicLevel
            }
            
            if idInt >= 0 {
                var value = ""
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
        }  else if id.contains("optionalText") {
            //thông tin khác
            if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
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
                let timeISO8601 = dateTemp.toString(.custom("yyyy-MM-dd'T'HH:mm:ssXXX"))
                DataManager.shared.loanInfo.optionalText[index] = timeISO8601
                self.lblValue?.text = date
            }
        }
        
    }
        
    
    
    
    
    
}

