//
//  LoanTypeAddressTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeAddressTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    
    @IBOutlet var lblValue: UILabel?
    
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
            }
            
            if let value = field_.placeholder {
                self.lblValue?.text = value
            }
            
            //Update Data
            self.getData()
            
        }
    }
    
    private func getAddressFromMissingData(parentKey: String, key: String) -> String {
        guard let miss = DataManager.shared.missingLoanDataDictionary, let parent = miss[parentKey] as? JSONDictionary, let address = parent[key] as? JSONDictionary else { return "" }
        
        var value = ""
        if let street = address["street"] as? String {
            value.append(street)
        }
        
        if let commue = address["commune"] as? String {
            value.append(", \(commue)")
        }
        
        if let district = address["district"] as? String {
            value.append(", \(district)")
        }
        
        if let city = address["city"] as? String {
            value.append(", \(city)")
        }
        
        return value
    }
    
    private func checkMissingData(parentKey: String, key: String, currentValue: String) -> Bool {
        let missAddress = self.getAddressFromMissingData(parentKey: parentKey, key: key)
        if currentValue.contains(missAddress) {
            return true
        }
        
        return false
    }
    
    
    func getData() {
        
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        
        if id.contains("residentAddress") {
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.residentAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@, %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.userInfo.residentAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.userInfo.residentAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@, %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.userInfo.residentAddress = address
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "residentAddress") && self.checkMissingData(parentKey: "userInfo", key: "residentAddress", currentValue: value) {
                //Cap nhat thong tin khong hop le
                //self.updateInfoFalse(pre: title)
                
                if self.valueTemp == nil {
                    self.valueTemp = value
                }
                self.updateInfoFalse(pre: title)
                
            } else {
                userDefault.set("", forKey: UserDefaultInValidResidentAddress)
                userDefault.synchronize()
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("currentAddress") {
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.currentAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@, %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.userInfo.temporaryAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.userInfo.temporaryAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@, %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.userInfo.temporaryAddress = address
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "currentAddress") && self.checkMissingData(parentKey: "userInfo", key: "currentAddress", currentValue: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                }
                self.updateInfoFalse(pre: title)
                
            } else {
                userDefault.set("", forKey: UserDefaultInValidCurrentAddress)
                userDefault.synchronize()
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("jobAddress") {
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@, %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.jobInfo.jobAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.jobInfo.jobAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@, %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.jobAddress = address
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "jobAddress") && self.checkMissingData(parentKey: "jobInfo", key: "jobAddress", currentValue: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                }
                self.updateInfoFalse(pre: title)
                
            } else {
                userDefault.set("", forKey: UserDefaultInValidJobAddress)
                userDefault.synchronize()
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("academicAddress") {
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@, %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.jobInfo.academicAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@, %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.academicAddress = address
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "academicAddress") && self.checkMissingData(parentKey: "jobInfo", key: "academicAddress", currentValue: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                }
                self.updateInfoFalse(pre: title)
                
            } else {
                userDefault.set("", forKey: UserDefaultInValidAcademicAddress)
                userDefault.synchronize()
                if let need = self.isNeedUpdate, need {
                    self.isNeedUpdate = false
                }
            }
            
        } else if id.contains("academicName") {
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicName , data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicName.length() > 0 {
                value = DataManager.shared.loanInfo.jobInfo.academicName
            }
            
            if value.length() > 0 {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.academicName = value
            }
            
            
            if DataManager.shared.checkFieldIsMissing(key: "academicName", parentKey: "jobInfo", currentValue: value) {
                //Cap nhat thong tin khong hop le
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
    
}

