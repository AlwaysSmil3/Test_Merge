//
//  InvestDetailSecondTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestDetailSecondTableViewCell: UITableViewCell {
    var cellData : DemoLoanModel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dueMonthLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var alreadyAmountPercentLb: UILabel!
    @IBOutlet weak var interestLb: UILabel!
    @IBOutlet weak var amountAvaiableInvestLb: UILabel!
    @IBOutlet weak var loanTypeLb: UILabel!
    @IBOutlet weak var borrowerLb: UILabel!
    @IBOutlet weak var reliabilityLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
    }

    func updateCellView() {
//        if let cellData = cellData {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: cellData.amount as NSNumber) {
                amountLb.text = "\(formattedTipAmount)"
            } else {
                amountLb.text = "\(cellData.amount)"
            }

            alreadyAmountPercentLb.text = "\(cellData.alreadyAmount)%"
            let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
            if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
                amountAvaiableInvestLb.text = "\(formattedTipAmount)"
            } else {
                amountAvaiableInvestLb.text = "\(avaiableAmount)"
            }
            interestLb.text = "\(cellData.interestRate)%/năm"
            borrowerLb.text = "Vu Thanh Do"
            reliabilityLb.text = cellData.reliability.title
            loanTypeLb.text = cellData.name
            dueMonthLb.text = "\(cellData.dueMonth) tháng"
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
