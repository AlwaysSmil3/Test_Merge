//
//  LoanTypeSocialTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/13/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import SDWebImage

class LoanTypeSocialTBCell: LoanTypeBaseTBCell {
    
    @IBOutlet var imgAvatar: UIImageView?
    @IBOutlet var lblDisplayName: UILabel?
    @IBOutlet var iconLeft: UIImageView?
    
    var socialData: FacebookInfo? {
        didSet {
            guard let data = self.socialData else { return }
            self.lblDisplayName?.text = data.fullName
            self.imgAvatar?.sd_setImage(with: URL(string: data.avatar), completed: nil)
            self.iconLeft?.image = #imageLiteral(resourceName: "option_icon")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}




