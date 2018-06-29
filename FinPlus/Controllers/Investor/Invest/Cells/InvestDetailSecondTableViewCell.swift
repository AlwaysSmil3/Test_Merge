//
//  InvestDetailSecondTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestDetailSecondTableViewCell: UITableViewCell {
    var cellData : BrowwerActiveLoan!
    var loanCategories : [LoanCategories] = [LoanCategories]()

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
        borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
    }
    
    func updateCellView() {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: cellData.amount! as NSNumber) {
            amountLb.text = formattedTipAmount
            amountAvaiableInvestLb.text = formattedTipAmount
        } else {
            amountLb.text = "\(cellData.amount!)"
            amountAvaiableInvestLb.text = "\(cellData.amount!)"
        }
//        alreadyAmountPercentLb.text = cellData.alreadyAmount.toString() + "%"
//        let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
//        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
//            amountAvaiableInvestLb.text = formattedTipAmount
//        } else {
//            amountAvaiableInvestLb.text = avaiableAmount.toString()
//        }
        var rate = 0
        if let temp = cellData.intRate {
            rate = temp
        }
        interestLb.text = "\(rate)" + "%/năm"
        borrowerLb.text = cellData.userInfo?.fullName
        self.reliabilityLb.text = cellData.grade ?? "A1"

        var reliType : LoanReliability!
        switch reliabilityLb.text {
        case "A1":
            reliType = LoanReliability.A1
        case "A2":
            reliType = LoanReliability.A2
        case "A3":
            reliType = LoanReliability.A3
        case "B1":
            reliType = LoanReliability.B1
        case "B2":
            reliType = LoanReliability.B2
        case "B3":
            reliType = LoanReliability.B3
        case "C1":
            reliType = LoanReliability.C1
        case "C2":
            reliType = LoanReliability.C2
        case "C3":
            reliType = LoanReliability.C3
        case "D":
            reliType = LoanReliability.D
        default:
            reliType = LoanReliability.A1

        }
        reliabilityLb.text = reliType.rawValue

        if self.loanCategories.count > 0 {
            for loanCategoryDetail in self.loanCategories {
                if (loanCategoryDetail.id! == cellData.loanCategoryId) {
                    self.loanTypeLb.text = loanCategoryDetail.title
                }
            }
        }
        //        self.loanTypeNameLb.text = cellData.name
        var termStr = ""
        if cellData.loanCategoryId == 1 {
            termStr = "Thời hạn \(cellData.term!) ngày"
        } else {
            termStr = "Thời hạn \(cellData.term!/30) tháng"
        }
        self.dueMonthLb.text = termStr
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
            amountLb.textColor = DARK_SUBTEXT_COLOR
            alreadyAmountPercentLb.textColor = DARK_SUBTEXT_COLOR
            amountAvaiableInvestLb.textColor = DARK_SUBTEXT_COLOR
            interestLb.textColor = DARK_SUBTEXT_COLOR
            borrowerLb.textColor = DARK_SUBTEXT_COLOR
            reliabilityLb.textColor = DARK_SUBTEXT_COLOR
            loanTypeLb.textColor = DARK_SUBTEXT_COLOR
            dueMonthLb.textColor = DARK_SUBTEXT_COLOR

        } else {
//            self.contentView.backgroundColor = LIGHT_BACKGROUND_COLOR
            self.contentView.backgroundColor = UIColor.white
            amountTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            alreadyAmountPercentTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            amountAvaiableInvestTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            interestTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            borrowerTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            reliabilityTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            loanTypeTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            dueMonthTitleLb.textColor = LIGHT_BODY_TEXT_COLOR

            amountLb.textColor = LIGHT_SUBTEXT_COLOR
            alreadyAmountPercentLb.textColor = LIGHT_SUBTEXT_COLOR
            amountAvaiableInvestLb.textColor = LIGHT_SUBTEXT_COLOR
            interestLb.textColor = LIGHT_SUBTEXT_COLOR
            borrowerLb.textColor = LIGHT_SUBTEXT_COLOR
            reliabilityLb.textColor = LIGHT_SUBTEXT_COLOR
            loanTypeLb.textColor = LIGHT_SUBTEXT_COLOR
            dueMonthLb.textColor = LIGHT_SUBTEXT_COLOR

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
