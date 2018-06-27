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
    @IBOutlet weak var amountTitleLb: UILabel!
    @IBOutlet weak var dueMonthLb: UILabel!
    @IBOutlet weak var alreadyAmountPercentTitleLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var alreadyAmountPercentLb: UILabel!
    @IBOutlet weak var borrowerTitleLb: UILabel!
    @IBOutlet weak var amountAvaiableInvestTitleLb: UILabel!
    @IBOutlet weak var dueMonthTitleLb: UILabel!
    @IBOutlet weak var loanTypeTitleLb: UILabel!
    @IBOutlet weak var reliabilityTitleLb: UILabel!
    @IBOutlet weak var interestTitleLb: UILabel!
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
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: cellData.amount as NSNumber) {
            amountLb.text = formattedTipAmount
        } else {
            amountLb.text = cellData.amount.toString()
        }

        alreadyAmountPercentLb.text = cellData.alreadyAmount.toString() + "%"
        let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            amountAvaiableInvestLb.text = formattedTipAmount
        } else {
            amountAvaiableInvestLb.text = avaiableAmount.toString()
        }
        interestLb.text = cellData.interestRate.toString() + "%/năm"
        borrowerLb.text = "Vu Thanh Do"
        reliabilityLb.text = cellData.reliability.title
        loanTypeLb.text = cellData.name
        dueMonthLb.text = "\(cellData.dueMonth) tháng"

        self.updateCellMode()
    }

    func updateCellMode() {
        if UserDefaults.standard.bool(forKey: APP_MODE) == true {
            amountTitleLb.textColor = DARK_BODY_TEXT_COLOR
            alreadyAmountPercentTitleLb.textColor = DARK_BODY_TEXT_COLOR
            amountAvaiableInvestTitleLb.textColor = DARK_BODY_TEXT_COLOR
            interestTitleLb.textColor = DARK_BODY_TEXT_COLOR
            borrowerTitleLb.textColor = DARK_BODY_TEXT_COLOR
            reliabilityTitleLb.textColor = DARK_BODY_TEXT_COLOR
            loanTypeTitleLb.textColor = DARK_BODY_TEXT_COLOR
            dueMonthTitleLb.textColor = DARK_BODY_TEXT_COLOR

            self.contentView.backgroundColor = DARK_FOREGROUND_COLOR
            amountLb.textColor = DARK_BODY_TEXT_COLOR
            alreadyAmountPercentLb.textColor = DARK_BODY_TEXT_COLOR
            amountAvaiableInvestLb.textColor = DARK_BODY_TEXT_COLOR
            interestLb.textColor = DARK_BODY_TEXT_COLOR
            borrowerLb.textColor = DARK_BODY_TEXT_COLOR
            reliabilityLb.textColor = DARK_BODY_TEXT_COLOR
            loanTypeLb.textColor = DARK_BODY_TEXT_COLOR
            dueMonthLb.textColor = DARK_BODY_TEXT_COLOR

        } else {
            self.contentView.backgroundColor = LIGHT_BACKGROUND_COLOR
            amountTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            alreadyAmountPercentTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            amountAvaiableInvestTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            interestTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            borrowerTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            reliabilityTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            loanTypeTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            dueMonthTitleLb.textColor = LIGHT_BODY_TEXT_COLOR

            amountLb.textColor = LIGHT_BODY_TEXT_COLOR
            alreadyAmountPercentLb.textColor = LIGHT_BODY_TEXT_COLOR
            amountAvaiableInvestLb.textColor = LIGHT_BODY_TEXT_COLOR
            interestLb.textColor = LIGHT_BODY_TEXT_COLOR
            borrowerLb.textColor = LIGHT_BODY_TEXT_COLOR
            reliabilityLb.textColor = LIGHT_BODY_TEXT_COLOR
            loanTypeLb.textColor = LIGHT_BODY_TEXT_COLOR
            dueMonthLb.textColor = LIGHT_BODY_TEXT_COLOR

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
