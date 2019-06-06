//
//  NotificationTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
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
