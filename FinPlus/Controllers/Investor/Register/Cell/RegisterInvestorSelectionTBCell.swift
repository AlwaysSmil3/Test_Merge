//
//  RegisterInvestorSelectionTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class RegisterInvestorSelectionTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var imgIcon: UIImageView!
    
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var icDisclosure: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgIcon.layer.cornerRadius = 5
        self.imgIcon.clipsToBounds = true
        
    }
    
    var dataRes: InvestorRegister? {
        didSet {
            guard let data = self.dataRes, let title = data.title, let value = data.value, let ic = data.icon else { return }
            
            self.lblTitle?.text = title
            self.lblValue?.text = value
            self.imgIcon?.image = ic
            
        }
    }
    
}



