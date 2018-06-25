//
//  InvestorSelectTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectIcon: UIImageView!
    @IBOutlet weak var fieldLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
