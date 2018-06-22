//
//  BankAccountTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BankAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var accountNumberLb: UILabel!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var walletImg: UIImageView!
    var cellData : Wallet!
    var isSelectedCell = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
    }

    func updateCellView() {
        if cellData.walletType == 1 {
            self.walletImg.image = #imageLiteral(resourceName: "momo")
        } else {
            self.walletImg.image = #imageLiteral(resourceName: "paypal")
        }
        self.walletNameLb.text = cellData.walletName
        self.accountNumberLb.text = cellData.walletNumber
        if isSelectedCell == true {
            self.containView.layer.borderColor = MAIN_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
        } else {
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")
            self.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
