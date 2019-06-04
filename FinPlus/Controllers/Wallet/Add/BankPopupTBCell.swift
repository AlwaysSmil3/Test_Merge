//
//  BankPopupTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 11/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import SDWebImage

class BankPopupTBCell: UITableViewCell {
    
    
    @IBOutlet weak var lblBankName: UILabel?
    @IBOutlet weak var lblBankCode: UILabel?
    @IBOutlet weak var iconBank: UIImageView?
    @IBOutlet weak var iconSelected: UIImageView?
    
    var data: Bank? {
        didSet {
            guard let data = data else { return }
            
            self.lblBankName?.text = data.displayName
            self.lblBankCode?.text = data.type
//            self.iconBank?.kf.setImage(with: URL(string: d.image!))
            if let image = data.image {
                self.iconBank?.sd_setImage(with: URL(string: image))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
}
