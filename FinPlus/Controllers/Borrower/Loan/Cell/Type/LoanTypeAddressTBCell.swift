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
    
    func getData() {
        
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        
        if id.contains("residentAddress") {
            if DataManager.shared.checkFieldIsMissing(key: "residentAddress") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.residentAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@ , %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.userInfo.residentAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.userInfo.residentAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@ , %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.userInfo.residentAddress = address
            }
            
        } else if id.contains("currentAddress") {
            if DataManager.shared.checkFieldIsMissing(key: "currentAddress") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.currentAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@ , %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.userInfo.temporaryAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.userInfo.temporaryAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@ , %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.userInfo.temporaryAddress = address
            }
            
        } else if id.contains("jobAddress") {
            
            if DataManager.shared.checkFieldIsMissing(key: "jobAddress") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@ , %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.jobInfo.jobAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.jobInfo.jobAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@ , %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.jobAddress = address
            }
            
        } else if id.contains("academicAddress") {
            
            if DataManager.shared.checkFieldIsMissing(key: "academicAddress") {
                //Cap nhat thong tin khong hop le
                self.updateInfoFalse(pre: title)
            }
            
            var value = ""
            var addressTemp: Address?
            if let add = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.academicAddress, let city = add.city, let district = add.district, let commune = add.commune, let street = add.street, city.length() > 0 {
                value = String(format: "%@ , %@, %@, %@",street, commune, district, city)
                addressTemp = Address(city: city, district: district, commune: commune, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if DataManager.shared.loanInfo.jobInfo.academicAddress.city.length() > 0 {
                let add = DataManager.shared.loanInfo.jobInfo.academicAddress
                addressTemp = Address(city: add.city, district: add.district, commune: add.commune, street: add.street, zipCode: "", long: 0, lat: 0)
                value = String(format: "%@ , %@, %@, %@",
                               add.street, add.commune, add.district, add.city)
            }
            
            if value.length() > 0, let address = addressTemp {
                self.lblValue?.text = value
                DataManager.shared.loanInfo.jobInfo.academicAddress = address
            }
            
        }
        
    }
    
}

