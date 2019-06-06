//
//  ProfileTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.tintColor = MAIN_COLOR
        
        nameLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        desLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
