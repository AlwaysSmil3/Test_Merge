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
    
    @IBOutlet weak var lblLeftDebt: UILabel?
    @IBOutlet weak var lblDebt: UILabel?
    @IBOutlet weak var originMoneyLb: UILabel!
    @IBOutlet weak var interestMoneyLb: UILabel!
    @IBOutlet weak var feeReturnBeforeDueDateLb: UILabel!
    
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    var cellData : PayAllBefore!
    var isSelectedCell = false
    
    var isDebt: Bool = false
    
    var paymentData: PaymentLiquidation? {
        didSet {
            guard let data = self.paymentData else { return }
            
            if !self.isDebt {
                self.lblDebt?.isHidden = true
                self.lblLeftDebt?.isHidden = true
                self.originMoneyLb.isHidden = true
                
                if data.interest! > 0 && data.fee! > 0 {
                    self.originMoneyLb.isHidden = false
                    self.originMoneyLb.text = "Tiền gốc phải trả: " + FinPlusHelper.formatDisplayCurrency(data.outstanding!) + "đ"
                    
                    self.interestMoneyLb?.text = "Tiền lãi cộng dồn trong kỳ: " + FinPlusHelper.formatDisplayCurrency(data.interest!) + "đ"
                    
                    self.feeReturnBeforeDueDateLb?.text = "Phí tất toán: " + FinPlusHelper.formatDisplayCurrency(data.fee!) + "đ"
                } else {
                    self.interestMoneyLb?.text = "Tiền gốc phải trả: " + FinPlusHelper.formatDisplayCurrency(data.outstanding!) + "đ"
                    if data.interest! > 0 {
                        self.feeReturnBeforeDueDateLb?.text = "Tiền lãi cộng dồn trong kỳ: " + FinPlusHelper.formatDisplayCurrency(data.interest!) + "đ"
                    }
                    
                    if data.fee! > 0 {
                        self.feeReturnBeforeDueDateLb?.text = "Phí tất toán: " + FinPlusHelper.formatDisplayCurrency(data.fee!) + "đ"
                    }
                }
                

            } else {
                self.lblDebt?.text = FinPlusHelper.formatDisplayCurrency(data.debt!) + "đ"
                 self.originMoneyLb.text = "Tiền gốc phải trả: " + FinPlusHelper.formatDisplayCurrency(data.outstanding!) + "đ"
                
                self.interestMoneyLb?.text = "Tiền lãi cộng dồn trong kỳ: " + FinPlusHelper.formatDisplayCurrency(data.interest!) + "đ"
                
                self.feeReturnBeforeDueDateLb?.text = "Phí tất toán: " + FinPlusHelper.formatDisplayCurrency(data.fee!) + "đ"
            }
            
            
            
            self.borrowingLb.text = FinPlusHelper.formatDisplayCurrency(data.debt! + data.fee! + data.outstanding! + data.interest!) + "đ"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
        // Initialization code
        self.titleLb.text = "Thanh toán trước toàn bộ"
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
