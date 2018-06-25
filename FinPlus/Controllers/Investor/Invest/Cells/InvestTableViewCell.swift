//
//  InvestTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestTableViewCell: UITableViewCell {
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!

    @IBOutlet weak var reliabilityLb: UILabel!
    @IBOutlet weak var alreadyAmountLb: UILabel!
    @IBOutlet weak var exporeTimeLb: UILabel!
    var cellData : DemoLoanModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        reliabilityLb.layer.cornerRadius = reliabilityLb.frame.size.width / 2
        reliabilityLb.layer.borderWidth = 2
        // Initialization code
    }

    func updateCellView() {
        reliabilityLb.text = cellData.reliability.title
        reliabilityLb.layer.borderColor = cellData.reliability.color.cgColor
        nameLb.text = cellData.name

        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: cellData.amount as NSNumber) {
            amountLb.text = "\(formattedTipAmount)"
        } else {
            amountLb.text = "\(cellData.amount)"
        }
        alreadyAmountLb.text = "Đã huy động: \(cellData.alreadyAmount)%"
        exporeTimeLb.text = "Lãi suất \(cellData.interestRate)%/năm - \(cellData.dueMonth) tháng"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
