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
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                self.lblTitle?.text = title
            }
            
            if let value = field_.placeholder {
                self.tfValue?.placeholder = value
            }
            
        }
    }
    
}
