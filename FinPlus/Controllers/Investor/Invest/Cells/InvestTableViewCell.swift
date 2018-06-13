//
//  InvestTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestTableViewCell: UITableViewCell {
    @IBOutlet weak var addInvestBtn: UIButton!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var investImg: UIImageView!

    @IBOutlet weak var alreadyAmountLb: UILabel!
    @IBOutlet weak var exporeTimeLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
