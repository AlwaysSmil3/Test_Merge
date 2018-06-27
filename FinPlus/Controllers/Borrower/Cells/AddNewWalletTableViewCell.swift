//
//  AddNewWalletTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class AddNewWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var containView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
        self.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        self.selectionStyle = .none

        // Initialization code
    }

    func updateCellView() {
        if (UserDefaults.standard.bool(forKey: APP_MODE) && UserDefaults.standard.bool(forKey: IS_INVESTOR)) {
            self.titleLb.textColor = DARK_SUBTEXT_COLOR
        } else {
            self.titleLb.textColor = LIGHT_BODY_TEXT_COLOR
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
