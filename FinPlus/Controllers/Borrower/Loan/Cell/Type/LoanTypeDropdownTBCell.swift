//
//  LoanTypeDropdownTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanTypeDropdownTBCell: UITableViewCell {
    
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblValue: UILabel?
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                self.lblTitle?.text = title
            }
            
            if let value = field_.selectorTitle {
                self.lblValue?.text = value
            }
            
        }
    }
    
    
}

