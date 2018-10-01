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
    
    @IBOutlet weak var lblOverInterest: UILabel?
    @IBOutlet weak var lblFeeOver: UILabel?
    
    var cellData : PayType!
    var isSelectedCell: Bool = false
    
    var dateExpire: String? {
        didSet {
            guard let date = self.dateExpire else { return }
            self.dateLb.text = date
        }
    }
    
    var isOnTime: Bool = true
    
    var paymentData: PaymentPaymentPeriod? {
        didSet {
            guard let data = self.paymentData else { return }
            
            self.borrowingLb?.text = FinPlusHelper.formatDisplayCurrency(data.principal! + data.feeOverdue! + data.interest! + data.overdue!) + "đ"
            
            if self.isOnTime {
                self.originMoneyLb.isHidden = true
                self.interestMoneyLb.isHidden = true
                
                self.lblOverInterest?.text = "Tiền gốc: " + FinPlusHelper.formatDisplayCurrency(data.principal!) + "đ"
                
                self.lblFeeOver?.text = "Tiền lãi: " + FinPlusHelper.formatDisplayCurrency(data.interest!) + "đ"
                
                return
            }
            self.originMoneyLb.isHidden = false
            
            self.originMoneyLb.text = "Tiền gốc: " + FinPlusHelper.formatDisplayCurrency(data.principal!) + "đ"
            self.interestMoneyLb.text = "Tiền lãi: " + FinPlusHelper.formatDisplayCurrency(data.interest!) + "đ"
//            self.lblOverInterest?.text = "Tiền lãi quá hạn: " + FinPlusHelper.formatDisplayCurrency(data.overdue!) + "đ"
            
//            self.lblFeeOver?.text = "Phí phạt quá hạn: " + FinPlusHelper.formatDisplayCurrency(data.feeOverdue!) + "đ"
            
            
            
            // create attributed string
            
            let attribute = [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:UIColor(hexString: "#DA3535")]
            
            let name = NSAttributedString(string: "\(FinPlusHelper.formatDisplayCurrency(data.overdue!))đ", attributes: attribute )
            let attrString = NSMutableAttributedString(string: "Tiền lãi quá hạn: ")
            attrString.append(name)
            self.lblOverInterest?.attributedText = attrString
            
            
            let name1 = NSAttributedString(string: "\(FinPlusHelper.formatDisplayCurrency(data.feeOverdue!))đ", attributes: attribute )
            let attrString1 = NSMutableAttributedString(string: "Phí phạt quá hạn: ")
            attrString1.append(name1)
            self.lblFeeOver?.attributedText = attrString1
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 8
        self.selectionStyle = .none
        // Initialization code
        self.originMoneyLb.isHidden = true
        self.titleLb.text = "Thanh toán tháng này"
        if let loan = DataManager.shared.browwerInfo?.activeLoan {
            self.dateLb.text = Date.init(fromString: loan.nextPaymentDate ?? "", format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER)).toString(.custom(kDisplayFormat))
        }
    }

    func updateCellView() {
        
        if isSelectedCell == true {
            self.containView.layer.borderColor = MAIN_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
        } else {
            self.containView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
