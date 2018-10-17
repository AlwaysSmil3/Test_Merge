//
//  LoanTypeFileTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Kingfisher

class LoanTypeFileTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet weak var imgValue: UIImageView?
    @IBOutlet weak var imgAdd: UIImageView?
    @IBOutlet weak var lblDescription: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        self.imgValue?.layer.cornerRadius = 3
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
    
    func checkImgInValid(key: String, url: String) -> Bool {
        guard let list = DataManager.shared.listKeyMissingLoanKey else { return false }
        guard let data = DataManager.shared.missingLoanDataDictionary else { return false }
        
        let listFields = list.filter { $0 == key }
        
        if listFields.count == 0 {
            return false
        }
        
        if let invalidValue = data[key] as? String, url == invalidValue {
            return true
        }
        
        return false
    }
    
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
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
                
                self.imgValue?.kf.setImage(with: URL(string: value), placeholder: #imageLiteral(resourceName: "imagefirstOnboard"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                
                DataManager.shared.loanInfo.nationalIdAllImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "nationalIdAllImg") && self.checkImgInValid(key: "nationalIdAllImg", url: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
                
                if valueTemp != value {
                    self.isNeedUpdate = false
                }
                
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
                
                self.imgValue?.kf.setImage(with: URL(string: value), placeholder: #imageLiteral(resourceName: "imagefirstOnboard"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                
                DataManager.shared.loanInfo.nationalIdFrontImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "nationalIdFrontImg") && self.checkImgInValid(key: "nationalIdFrontImg", url: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
                
                if valueTemp != value {
                    self.isNeedUpdate = false
                }
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

                self.imgValue?.kf.setImage(with: URL(string: value), placeholder: #imageLiteral(resourceName: "imagefirstOnboard"), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: { (image, error, type, url) in
                    self.activityIndicator.stopAnimating()
                })
                
                DataManager.shared.loanInfo.nationalIdBackImg = value
                self.imgAdd?.isHidden = true
                self.lblDescription?.isHidden = true
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "nationalIdBackImg") && self.checkImgInValid(key: "nationalIdBackImg", url: value) {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
                
                if valueTemp != value {
                    self.isNeedUpdate = false
                }
            }
            
        }
        
    }
    
}
