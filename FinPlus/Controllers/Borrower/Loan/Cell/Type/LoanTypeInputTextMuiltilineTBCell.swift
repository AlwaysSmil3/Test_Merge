//
//  LoanTypeInputTextMuiltilineTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol ShowTextInputMesseageViewDelegate {
    func showTextInput(indexPath: IndexPath)
}

class LoanTypeInputTextMuiltiLineTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    
    
    @IBOutlet var lblValue: UILabel?
    
    var showInputViewDelegate: ShowTextInputMesseageViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        
        lblValue?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        lblValue?.addGestureRecognizer(tapGesture)
        
    }
    
    var currentIndex: IndexPath?
    
    var parent: String?
    
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
                self.lblValue?.textColor = UIColor(red: 194/255, green: 194/255, blue: 201/255, alpha: 1.0)
            }
            
            if let text = field_.textInputMuiltiline, text.count > 0 {
                self.lblValue?.text = text
                self.lblValue?.textColor = UIColor(hexString: "#08121E")
            }
            
            
            self.getData()
            
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        guard let index = self.currentIndex else { return }
        //NotificationCenter.default.post(name: .showMuiltiLineInputText, object: nil)
        self.showInputViewDelegate?.showTextInput(indexPath: index)
        
    }
    
    
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        if id.contains("optionalText") {
            
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
                self.lblValue?.text = value
                self.lblValue?.textColor = UIColor(hexString: "#08121E")
                DataManager.shared.loanInfo.optionalText[index] = value
            }
            
        }
        
        
    }

    
    
    
}

