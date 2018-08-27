//
//  SlideTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 06/07/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class SlideTableViewCell: UITableViewCell {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var slider: VSSlider!
    @IBOutlet weak var topValueLabel: UILabel!
    @IBOutlet weak var bottomValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topTitleLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        topValueLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        bottomTitleLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SMALL)
        bottomValueLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SMALL)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
