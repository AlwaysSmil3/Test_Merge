//
//  BankPopupTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 11/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Kingfisher

class BankPopupTBCell: UITableViewCell {
    
    
    @IBOutlet weak var lblBankName: UILabel?
    @IBOutlet weak var lblBankCode: UILabel?
    @IBOutlet weak var iconBank: UIImageView?
    @IBOutlet weak var iconSelected: UIImageView?
    
    var data: Bank? {
        didSet {
            guard let d = data else { return }
            
            self.lblBankName?.text = d.displayName
            self.lblBankCode?.text = d.type
            self.iconBank?.kf.setImage(with: URL(string: d.image!))
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
}
