//
//  PayBtnTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/19/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PayBtnTableViewCell: UITableViewCell {
    
    @IBOutlet weak var payBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
