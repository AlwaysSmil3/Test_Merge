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
        
        if id.contains("position") || id.contains("jobType") {
            let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
            
            if id.contains("position") {
                popup.setDataSource(data: data, type: .JobPosition)
            } else {
                popup.setDataSource(data: data, type: .Job)
            }
            popup.delegate = self
            
            popup.show()
        }
        
    }
    
    
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.lblValue?.text = data.title
        
        guard let field_ = self.field, let id = field_.id else { return }
        
        if id.contains("jobType") {
            DataManager.shared.loanInfo.jobInfo.jobType = data.title!
        } else if id.contains("position") {
            DataManager.shared.loanInfo.jobInfo.position = data.title!
        }
        
    }
    
    //Update Data khi co khoan vay
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        
        if id.contains("jobType") {
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.jobType, data.length() > 0 {
                self.lblValue?.text = data
                DataManager.shared.loanInfo.jobInfo.jobType = data
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
            }
        } else if id.contains("position") {
            if let data = DataManager.shared.browwerInfo?.activeLoan?.jobInfo?.position, data.length() > 0 {
                self.lblValue?.text = data
                DataManager.shared.loanInfo.jobInfo.position = data
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
            }
        }
        
    }
    
    
}

