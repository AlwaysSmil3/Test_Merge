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
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.residentAddress, let city = add.city, let district = add.district, let commune = add.commune {
                let addr = String(format: "%@ , %@, %@", commune, district, city)
                self.lblValue?.text = addr
                let address = Address(city: city, district: district, commune: commune, street: "", zipCode: "", long: 0, lat: 0)
                DataManager.shared.loanInfo.userInfo.residentAddress = address
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        } else if id.contains("currentAddress") {
            if let add = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.currentAddress, let city = add.city, let district = add.district, let commune = add.commune {
                let addr = String(format: "%@ , %@, %@", commune, district, city)
                self.lblValue?.text = addr
                let address = Address(city: city, district: district, commune: commune, street: "", zipCode: "", long: 0, lat: 0)
                DataManager.shared.loanInfo.userInfo.temporaryAddress = address
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        } else if id.contains("address") {
            if let add = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.address, let city = add.city, let district = add.district, let commune = add.commune {
                let addr = String(format: "%@ , %@, %@", commune, district, city)
                self.lblValue?.text = addr
                let address = Address(city: city, district: district, commune: commune, street: "", zipCode: "", long: 0, lat: 0)
                DataManager.shared.loanInfo.jobInfo.address = address
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        }
        
    }
    
}

