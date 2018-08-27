//
//  InvestFilterTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 05/07/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var separateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        typeView.layer.borderWidth = 2
        typeView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        typeView.layer.cornerRadius = typeView.frame.size.width/2
        
        typeLabel.font = UIFont(name: FONT_FAMILY_MEDIUM, size: FONT_SIZE_SEMIMALL)
        desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
        rateLabel.font = UIFont(name: FONT_FAMILY_MEDIUM, size: FONT_SIZE_SEMIMALL)
        statusLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
        moneyLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
