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
            self.originMoneyLb.text = "Tiền gốc: \(cellData.originAmount)"
            self.interestMoneyLb.text = "Tiền lãi: \(cellData.interestAmount)"
            self.feeReturnBeforeDueDateLb.text = "Phí trả nợ trước hạn: \(cellData.feeToPayBefore)"
            self.borrowingLb.text = "\(cellData.sumAmount)"
            if isSelectedCell == true {
                self.containView.layer.borderColor = MAIN_COLOR.cgColor
                self.selectImg.image = #imageLiteral(resourceName: "cellSelectedImg")
            } else {
                self.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
                self.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")

            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
