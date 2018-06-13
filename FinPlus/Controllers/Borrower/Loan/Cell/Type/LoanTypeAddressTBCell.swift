//
//  LoanTypeAddressTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeAddressTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
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
            
        }
    }
    
}

