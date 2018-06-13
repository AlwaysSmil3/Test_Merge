//
//  LoanTypeFileTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeFileTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var imgValue: UIImageView?
    @IBOutlet var imgAdd: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
    }
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                self.lblTitle?.text = title
            }
            
            
        }
    }
    
}
