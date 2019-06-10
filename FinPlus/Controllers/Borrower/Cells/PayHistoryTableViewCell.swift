//
//  PayHistoryTableViewswift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PayHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var statusDesLb: UILabel!
    @IBOutlet weak var payDateLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var imgBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainBackgroundView.layer.cornerRadius = 8
        mainBackgroundView.layer.borderWidth = 1
        imgBackgroundView.layer.cornerRadius = 15
        imgBackgroundView.layer.borderWidth = 1
    }

    func displayCell(cellData: CollectionPay, index: Int) {
        let time = Date(fromString: cellData.dueDatetime!, format: .iso8601(ISO8601Format.DateTimeSec))
        let timeDisplay = time.toString(DateFormat.custom(kDisplayFormat))
        timeLb.text = "Đợt \(index)"
        payDateLb.text = timeDisplay
        
        amountLb.text = FinPlusHelper.formatDisplayCurrency(cellData.principal! + cellData.interest! + cellData.overdue! + cellData.feeOverdue! + cellData.borrowerManagingFee! ) + "đ"
        
        // set theme cell
        switch cellData.status! {
        case 0:
            //chưa phát sinh
            self.notYetCellView()
        case 1:
            //Chưa thanh toán
            amountLb.text = FinPlusHelper.formatDisplayCurrency((cellData.principal! + cellData.interest! + cellData.overdue! + cellData.feeOverdue! + cellData.borrowerManagingFee! ) - (cellData.repayFeeOverdue! + cellData.repayOverdue! + cellData.repayInterest! + cellData.repayPrincipal! + cellData.repayBorrowerManagingFee!)) + "đ"
            self.needToPayCellView()
        case 2:
            //Đã thanh toán
            amountLb.text = "0 đ"
            self.paidViewCell()
        case 3:
            // Trễ thanh toán
            self.needToPayNowViewCell()
        default:
            break
        }
    }

    func notYetCellView() {
        statusDesLb.text = "Chưa đến đợt"
        statusDesLb.textColor = UIColor.black
        timeLb.textColor = UIColor.black
        payDateLb.textColor = UIColor.black
        amountLb.textColor = UIColor(hexString: "#4D6678")
        mainBackgroundView.backgroundColor = UIColor.init(hexString: "#F1F5F8")
        imgBackgroundView.backgroundColor = UIColor.init(hexString: "#F1F5F8")
        statusImg.image = #imageLiteral(resourceName: "notYet")
        imgBackgroundView.layer.borderColor = UIColor.init(hexString: "#F1F5F8").cgColor
        mainBackgroundView.layer.borderColor = UIColor.init(hexString: "#F1F5F8").cgColor
    }

    func needToPayCellView() {
        statusDesLb.text = "Cần thanh toán"
        statusDesLb.textColor = UIColor.black
        timeLb.textColor = UIColor.black
        payDateLb.textColor = UIColor.black
        amountLb.textColor = UIColor(hexString: "#3EAA5F")
        mainBackgroundView.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor
        mainBackgroundView.backgroundColor = UIColor.clear
        imgBackgroundView.backgroundColor = UIColor.clear
        imgBackgroundView.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor
        mainBackgroundView.layer.borderColor = UIColor.init(hexString: "#3EAA5F").cgColor
        statusImg.image = #imageLiteral(resourceName: "needToPay")
    }

    func needToPayNowViewCell() {
        statusDesLb.text = "Cần thanh toán ngay"
        statusDesLb.textColor = UIColor.black
        timeLb.textColor = UIColor.black
        payDateLb.textColor = UIColor.black
        amountLb.textColor = UIColor(hexString: "#DA3535")
        mainBackgroundView.layer.borderColor = UIColor(hexString: "#DA3535").cgColor
        mainBackgroundView.backgroundColor = UIColor.clear
        imgBackgroundView.backgroundColor = UIColor.clear
        imgBackgroundView.layer.borderColor = UIColor(hexString: "#DA3535").cgColor
        statusImg.image = #imageLiteral(resourceName: "needToPayNow")
    }

    func paidViewCell() {
        statusDesLb.text = "Đã thanh toán"
        statusDesLb.textColor = UIColor.white
        timeLb.textColor = UIColor.white
        payDateLb.textColor = UIColor.white
        amountLb.textColor = UIColor.white
        mainBackgroundView.backgroundColor = UIColor(hexString: "#94D4AB")
        imgBackgroundView.backgroundColor = UIColor(hexString: "#94D4AB")
        mainBackgroundView.layer.borderColor = UIColor(hexString: "#94D4AB").cgColor
        imgBackgroundView.layer.borderColor = UIColor(hexString: "#94D4AB").cgColor
        statusImg.image = #imageLiteral(resourceName: "paid")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
