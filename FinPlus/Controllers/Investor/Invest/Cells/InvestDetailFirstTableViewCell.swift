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
//        if let cellData = cellData {
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
            self.interestCircleLb.text = "\(cellData.interestRate)\n/năm"
            self.interestNameLb.text = "Lãi suất thấp/cao"
            self.interestDes.text = "\(cellData.interestRate)/năm, trả góp hàng tháng"
            // last block
            self.alreadyProgress.text = "\(cellData.alreadyAmount)%"
            self.alreadyNameLb.text = "Đã huy động"
            var avaiableAmountStr = ""
            let avaiableAmount = cellData.amount - (cellData.alreadyAmount / 100 * cellData.amount)
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
                avaiableAmountStr = "\(formattedTipAmount)"
            } else {
                avaiableAmountStr = "\(avaiableAmount)"
            }
            self.alreadyDesLb.text = "Đã huy động \(cellData.alreadyAmount)%, còn lại \(avaiableAmountStr)"
            
//        }

    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
