//
//  DebtScheduleTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class DebtScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
