//
//  PayHistoryTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PayHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var statusDesLb: UILabel!
    @IBOutlet weak var payDateLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var imgBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
