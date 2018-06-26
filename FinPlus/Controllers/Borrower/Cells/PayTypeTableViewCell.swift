//
//  PayTypeTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PayTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var borrowingLb: UILabel!
    @IBOutlet weak var interestMoneyLb: UILabel!
    @IBOutlet weak var originMoneyLb: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    var cellData : PayType!
    var isSelectedCell: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
        self.selectionStyle = .none
        // Initialization code
    }

    func updateCellView() {
        if let cellData = cellData {
            self.titleLb.text = "Thanh toán tháng này"
            self.dateLb.text = "Hạn: \(Date().convertDateToDisplayFormat(cellData.expireDate))"

            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: cellData.originAmount as NSNumber) {
                self.originMoneyLb.text = formattedTipAmount
            } else {
                self.originMoneyLb.text = cellData.originAmount.toString()
            }

            if let formattedTipAmount = formatter.string(from: cellData.interestAmount as NSNumber) {
                self.interestMoneyLb.text = formattedTipAmount
            } else {
                self.interestMoneyLb.text = cellData.interestAmount.toString()
            }


            if let formattedTipAmount = formatter.string(from: cellData.sumAmount as NSNumber) {
                self.borrowingLb.text = formattedTipAmount
            } else {
                self.borrowingLb.text = cellData.sumAmount.toString()
            }

//            self.originMoneyLb.text = "Tiền gốc: \(cellData.originAmount)"
//            self.interestMoneyLb.text = "Tiền lãi: \(cellData.interestAmount)"
//            self.borrowingLb.text = "\(cellData.sumAmount)"
            if isSelectedCell == true {
                self.containView.layer.borderColor = MAIN_COLOR.cgColor
                self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
            } else {
                self.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
                self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
