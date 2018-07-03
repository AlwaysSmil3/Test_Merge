//
//  RegisterInvestorTFTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class RegisterInvestorTFTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
    
    @IBOutlet var tfValue: UITextField?
    
    var dataRes: InvestorRegister? {
        didSet {
            guard let data = self.dataRes, let title = data.title, let place = data.placeHolder else { return }
            
            self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
            self.tfValue?.placeholder = place
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    
    
}
