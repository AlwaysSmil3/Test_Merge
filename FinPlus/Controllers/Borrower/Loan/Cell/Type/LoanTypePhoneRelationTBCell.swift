//
//  LoanTypeRelationPhoneTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypePhoneRelationTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var tfValue: UITextField?
    @IBOutlet var lblTypeRelation: UITextField?
    
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
                self.tfValue?.placeholder = value
            }
            
        }
    }
    
    
    @IBAction func btnDropdownTapped(_ sender: Any) {
        print("16666666656")
        
        guard let field_ = self.field, let data = field_.data else { return }
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.setDataSource(data: data)
        
        popup.show()
        
    }
    
    
    
    
}
