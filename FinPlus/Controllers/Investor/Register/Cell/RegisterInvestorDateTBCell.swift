//
//  RegisterInvestorDateTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class RegisterInvestorDateTBCell: UITableViewCell {
    
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblValue: UILabel!
    
    var dataRes: InvestorRegister? {
        didSet {
            guard let data = self.dataRes, let title = data.title, let value = data.value else { return }
            
            self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
            self.lblValue?.text = value
        }
    }
    
    
}
