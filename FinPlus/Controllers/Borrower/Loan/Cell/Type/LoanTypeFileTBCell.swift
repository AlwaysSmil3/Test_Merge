//
//  LoanTypeFileTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeFileTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet var imgValue: UIImageView?
    @IBOutlet var imgAdd: UIImageView?
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        self.imgValue?.layer.cornerRadius = 3
    }
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                self.lblTitle?.text = title
                
                if let need = self.isNeedUpdate, need {
                    self.updateInfoFalse(pre: title)
                }
            }
            
            if let desc = field_.descriptionValue {
                self.lblDescription?.text = desc
            }
            
            //Update Data
            self.getData()
            
        }
    }
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        if id.contains("nationalIdAllImg") {
            
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdAllImg, data.length() > 0 {
                self.imgValue?.sd_setImage(with: URL(string: hostLoan + data), completed: nil)
                DataManager.shared.loanInfo.nationalIdAllImg = data
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        } else if id.contains("nationalIdFrontImg") {
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdFrontImg, data.length() > 0 {
                self.imgValue?.sd_setImage(with: URL(string: hostLoan + data), completed: nil)
                DataManager.shared.loanInfo.nationalIdFrontImg = data
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        } else if id.contains("nationalIdBackImg") {
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdBackImg, data.length() > 0 {
                self.imgValue?.sd_setImage(with: URL(string: hostLoan + data), completed: nil)
                DataManager.shared.loanInfo.nationalIdBackImg = data
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            } else {
                //Cap nhat thong tin thieu
                self.updateInfoFalse(pre: title)
                
            }
            
        }
        
    }
    
}
