//
//  InvestDetailFirstTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import QuartzCore

class InvestDetailFirstTableViewCell: UITableViewCell {
    var cellData : DemoLoanModel!

    @IBOutlet weak var alreadyAmountCircleProgressView: UICircularProgressRingView!
    @IBOutlet weak var realibilityCircleLb: UILabel!
    @IBOutlet weak var realibilityNameLb: UILabel!
    @IBOutlet weak var realibilityDesLb: UILabel!

    @IBOutlet weak var loanTypeImg: UIImageView!
    @IBOutlet weak var loanTypeNameLb: UILabel!
    @IBOutlet weak var loanExpireMonth: UILabel!

    @IBOutlet weak var interestCircleLb: UILabel!
    @IBOutlet weak var interestNameLb: UILabel!
    @IBOutlet weak var interestDes: UILabel!

    @IBOutlet weak var alreadyProgress: UILabel!
    @IBOutlet weak var alreadyNameLb: UILabel!
    @IBOutlet weak var alreadyDesLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.realibilityCircleLb.clipsToBounds = true
        self.realibilityCircleLb.layer.cornerRadius = 22

        self.interestCircleLb.clipsToBounds = true
        self.interestCircleLb.layer.cornerRadius = 22

        self.interestCircleLb.backgroundColor = UIColor(hexString: "#F7F7F7")
    }

    func updateCellView() {
        // first block
        self.realibilityCircleLb.layer.cornerRadius = 22
        self.interestCircleLb.layer.cornerRadius = 22
        self.realibilityCircleLb.backgroundColor = cellData.reliability.color
        self.realibilityCircleLb.text = cellData.reliability.title
        self.realibilityNameLb.text = "Tín dụng hạng " + cellData.reliability.title
        self.realibilityDesLb.text = "Có độ an toàn cao nhất nhưng lãi suất không cao"
        // second block
        self.loanTypeNameLb.text = cellData.name
        self.loanExpireMonth.text = "Thời hạn \(cellData.dueMonth) tháng"
        // third block
        // add attribute string
        let interestCircleStr = cellData.interestRate.toString() + "\n%/năm"
        let myRange = NSRange(location: interestCircleStr.length() - 5, length: 5)
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: interestCircleStr)
        myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SF Pro Display", size: 8)!, range: myRange)
        self.interestCircleLb.attributedText = myMutableString
        switch cellData.reliability {
        case .positive1, .positive2, .positive3, .positive4:
            self.interestNameLb.text = "Lãi suất thấp"
        default:
            self.interestNameLb.text = "Lãi suất cao"
        }
        self.interestDes.text = cellData.interestRate.toString() + "/năm, trả góp hàng tháng"
        // last block
        let alreadyStr = cellData.alreadyAmount.toString() + "%"
        let range2 = NSRange(location: alreadyStr.length() - 1, length: 1)
        var alreadyMutableStr = NSMutableAttributedString()
        alreadyMutableStr = NSMutableAttributedString(string: alreadyStr)
        alreadyMutableStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SF Pro Display", size: 11)!, range: range2)
        self.alreadyProgress.attributedText = alreadyMutableStr
        self.alreadyNameLb.text = "Đã huy động"
        var avaiableAmountStr = ""
        let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
        alreadyAmountCircleProgressView.innerRingColor =  cellData.reliability.color
        alreadyAmountCircleProgressView.minValue = 0
        alreadyAmountCircleProgressView.maxValue = 100
        alreadyAmountCircleProgressView.value = CGFloat(cellData.alreadyAmount)
        alreadyAmountCircleProgressView.font = UIFont(name: "SFProDisplay-Semibold", size: 17)!
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = avaiableAmount.toString()
        }
        self.alreadyDesLb.text = "Đã huy động " + cellData.alreadyAmount.toString() + "%, còn lại " +  avaiableAmountStr
        // set up cell mode
        self.updateCellMode()
    }

    func updateCellMode() {
        if UserDefaults.standard.bool(forKey: APP_MODE) == true {
            self.contentView.backgroundColor = DARK_BACKGROUND_COLOR
            // first block
            self.realibilityNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.realibilityDesLb.textColor = DARK_SUBTEXT_COLOR
            // second block
            self.loanTypeNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.loanExpireMonth.textColor = DARK_SUBTEXT_COLOR
            // third block
            self.interestNameLb.textColor = DARK_BODY_TEXT_COLOR
            self.interestDes.textColor = DARK_SUBTEXT_COLOR
            // last block
            self.alreadyNameLb.textColor = DARK_SUBTEXT_COLOR
            self.alreadyDesLb.textColor = DARK_SUBTEXT_COLOR
            alreadyAmountCircleProgressView.fontColor = DARK_SUBTEXT_COLOR
        } else {
            self.contentView.backgroundColor = LIGHT_BACKGROUND_COLOR
            // first block
            self.realibilityNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.realibilityDesLb.textColor = LIGHT_SUBTEXT_COLOR
            // second block
            self.loanTypeNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.loanExpireMonth.textColor = LIGHT_SUBTEXT_COLOR
            // third block
            self.interestNameLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.interestDes.textColor = LIGHT_SUBTEXT_COLOR
            // last block
            self.alreadyNameLb.textColor = LIGHT_SUBTEXT_COLOR
            self.alreadyDesLb.textColor = LIGHT_SUBTEXT_COLOR
            alreadyAmountCircleProgressView.fontColor = LIGHT_SUBTEXT_COLOR
        }
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
