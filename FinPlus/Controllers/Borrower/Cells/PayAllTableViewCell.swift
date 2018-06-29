//
//  PayAllTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PayAllTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var borrowingLb: UILabel!
    @IBOutlet weak var feeReturnBeforeDueDateLb: UILabel!
    @IBOutlet weak var interestMoneyLb: UILabel!
    @IBOutlet weak var originMoneyLb: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    var cellData : PayAllBefore!
    var isSelectedCell = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
        // Initialization code
    }

    func updateCellView() {
        if let cellData = cellData {
            self.titleLb.text = "Thanh toán trước toàn bộ"

            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: cellData.originAmount as NSNumber) {
                self.originMoneyLb.text = "Tiền gốc: " + formattedTipAmount
            } else {
                self.originMoneyLb.text = "Tiền gốc: " + cellData.originAmount.toString()
            }

            if let formattedTipAmount = formatter.string(from: cellData.interestAmount as NSNumber) {
                self.interestMoneyLb.text = "Tiền lãi: " + formattedTipAmount
            } else {
                self.interestMoneyLb.text = "Tiền lãi: " + cellData.interestAmount.toString()
            }

            if let formattedTipAmount = formatter.string(from: cellData.feeToPayBefore as NSNumber) {
                self.feeReturnBeforeDueDateLb.text = "Phí trả nợ trước hạn: " + formattedTipAmount
            } else {
                self.feeReturnBeforeDueDateLb.text = "Phí trả nợ trước hạn: " + cellData.feeToPayBefore.toString()
            }


            if let formattedTipAmount = formatter.string(from: cellData.sumAmount as NSNumber) {
                self.borrowingLb.text = formattedTipAmount
            } else {
                self.borrowingLb.text = cellData.sumAmount.toString()
            }

            if isSelectedCell == true {
                self.containView.layer.borderColor = MAIN_COLOR.cgColor
                self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
            } else {
                self.containView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
                self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")

            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
