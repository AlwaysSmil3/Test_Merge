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
        guard let field_ = self.field, let id = field_.id else { return }
        if id.contains("nationalIdAllImg") {
            
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdAllImg, data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.nationalIdAllImg.length() > 0 {
                value = DataManager.shared.loanInfo.nationalIdAllImg
            }
            
            if value.length() > 0 {
                self.activityIndicator.startAnimating()
                //self.imgValue?.sd_setImage(with: URL(string: hostLoan + value), completed: nil)
                //self.imgValue?.sd_setImage(with: URL(string: value), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), completed: nil)
                self.imgValue?.sd_setImage(with: URL(string: value), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), completed: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                DataManager.shared.loanInfo.nationalIdAllImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
        } else if id.contains("nationalIdFrontImg") {
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdFrontImg, data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.nationalIdFrontImg.length() > 0 {
                value = DataManager.shared.loanInfo.nationalIdFrontImg
            }
            
            if value.length() > 0 {
                self.activityIndicator.startAnimating()
                self.imgValue?.sd_setImage(with: URL(string: value), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), completed: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                DataManager.shared.loanInfo.nationalIdFrontImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
        } else if id.contains("nationalIdBackImg") {
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.nationalIdBackImg, data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.nationalIdBackImg.length() > 0 {
                value = DataManager.shared.loanInfo.nationalIdBackImg
            }
            
            if value.length() > 0 {
                self.activityIndicator.startAnimating()
                self.imgValue?.sd_setImage(with: URL(string: value), placeholderImage: #imageLiteral(resourceName: "imagefirstOnboard"), completed: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                DataManager.shared.loanInfo.nationalIdBackImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
        }
        
    }
    
}
