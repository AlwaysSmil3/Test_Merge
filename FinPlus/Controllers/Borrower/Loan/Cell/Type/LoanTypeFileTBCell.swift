//
//  LoanTypeFileTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeFileTBCell: LoanTypeBaseTBCell {
    

    @IBOutlet var imgValue: UIImageView?
    @IBOutlet var imgAdd: UIImageView?
    @IBOutlet var lblDescription: UILabel?
    
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
            }
            
            if let desc = field_.descriptionValue {
                self.lblDescription?.text = desc
            }
            
        }
    }
    
}
