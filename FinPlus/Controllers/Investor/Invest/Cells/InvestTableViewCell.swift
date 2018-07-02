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
    @IBOutlet weak var nextImg: UIImageView!

    var loanCategories : [LoanCategories] = [LoanCategories]()
    @IBOutlet weak var reliabilityLb: UILabel!
    @IBOutlet weak var alreadyAmountLb: UILabel!
    @IBOutlet weak var exporeTimeLb: UILabel!
    var cellData : BrowwerActiveLoan!
    override func awakeFromNib() {
        super.awakeFromNib()
        reliabilityLb.layer.cornerRadius = reliabilityLb.frame.size.width / 2
        reliabilityLb.layer.borderWidth = 2
        // Initialization code
    }

    func updateCellView() {

//        reliabilityLb.text = cellData.reliability.title
//        reliabilityLb.layer.borderColor = cellData.reliability.color.cgColor
//        nameLb.text = cellData.name
        reliabilityLb.text = cellData.grade ?? "A1"
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
        reliabilityLb.layer.borderColor = reliType.color.cgColor


        // get 

        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: cellData.amount! as NSNumber) {
            amountLb.text = formattedTipAmount
        } else {
            amountLb.text = Float(cellData.amount!).toString()
        }
        var funed : Float = 25
        if let temp = cellData.funed {
            funed = temp
        }
        alreadyAmountLb.text = "Đã huy động: " + "\(funed)" + "%"
        var termStr = ""
        if cellData.loanCategoryId == 1 {
            termStr = "\(cellData.term!) ngày"
        } else {
            termStr = "\(cellData.term!/30) tháng"
        }
        var rate : Float = 20
        if let temp = cellData.inRate {
            rate = temp
        }
        exporeTimeLb.text = "Lãi suất " + rate.toString() + "%/năm - " + termStr
        // update mode
//        DataManager.shared.loanCate
                    if self.loanCategories.count > 0 {
                        for loanCategoryDetail in loanCategories {
                            if (loanCategoryDetail.id! == cellData.loanCategoryId) {
                                self.nameLb.text = loanCategoryDetail.title
                            }
                        }
                    }
        self.updateViewMode()
    }

    func updateViewMode() {
        var mode = false
        mode = UserDefaults.standard.bool(forKey: APP_MODE)
        if (mode)
        {
            self.contentView.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            self.nameLb.textColor = DARK_BODY_TEXT_COLOR
            self.reliabilityLb.textColor = UIColor.white
            self.exporeTimeLb.textColor = DARK_BODY_TEXT_COLOR
            self.alreadyAmountLb.textColor = DARK_SUBTEXT_COLOR
            self.amountLb.textColor = DARK_BODY_TEXT_COLOR
            nextImg.image = #imageLiteral(resourceName: "ic_right_dark")
        }
        else
        {
            self.contentView.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            self.nameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.reliabilityLb.textColor = UIColor.black
            self.exporeTimeLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.alreadyAmountLb.textColor = LIGHT_SUBTEXT_COLOR
            self.amountLb.textColor = LIGHT_BODY_TEXT_COLOR
            nextImg.image = #imageLiteral(resourceName: "ic_right")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
