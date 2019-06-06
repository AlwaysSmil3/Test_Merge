//
//  PayTypeOverdueTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/28/19.
//  Copyright © 2019 Cao Van Hai. All rights reserved.
//

import Foundation

class PayTypeOverdueTBCell: UITableViewCell {
    
    @IBOutlet weak var containerView: AnimatableView?
    @IBOutlet weak var iconSelected: UIImageView?
    
    @IBOutlet weak var lblDeadlinePayment: UILabel?
    @IBOutlet weak var lblBorrowerManagingFee: UILabel?
    @IBOutlet weak var lblPrincipal: UILabel?
    @IBOutlet weak var lblInterest: UILabel?
    @IBOutlet weak var lblAmountInTerm: UILabel?
    
    //Qúa hạn
    @IBOutlet weak var lblBorrowerManagingFeeOverDue: UILabel?
    @IBOutlet weak var lblPrincipalOverDue: UILabel?
    @IBOutlet weak var lblInterestOverDue: UILabel?
    @IBOutlet weak var lblFeeOverdue: UILabel?
    @IBOutlet weak var lblOverdue: UILabel?
    @IBOutlet weak var lblTotalOverdue: UILabel?
    
    @IBOutlet weak var lblTotalPay: UILabel?
    
    var isSelectedCell: Bool = false
    
    var dateExpire: String? {
        didSet {
            guard let date = self.dateExpire else { return }
            self.lblDeadlinePayment?.text = date
        }
    }
    
    var data: PaymentPaymentPeriod? {
        didSet {
            guard let d = self.data else { return }
            
            self.lblBorrowerManagingFee?.text = FinPlusHelper.formatDisplayCurrency(d.borrowerManagingFee!) + "đ"
            self.lblPrincipal?.text = FinPlusHelper.formatDisplayCurrency(d.principal!) + "đ"
            self.lblInterest?.text = FinPlusHelper.formatDisplayCurrency(d.interest!) + "đ"
            
            let totalAmountInTerm = d.borrowerManagingFee! + d.principal! + d.interest!
            self.lblAmountInTerm?.text = FinPlusHelper.formatDisplayCurrency(totalAmountInTerm) + "đ"
            
            self.lblBorrowerManagingFeeOverDue?.text = FinPlusHelper.formatDisplayCurrency(d.borrowerManagingFeeOverdue!) + "đ"
            self.lblPrincipalOverDue?.text = FinPlusHelper.formatDisplayCurrency(d.principalOverdue!) + "đ"
            self.lblInterestOverDue?.text = FinPlusHelper.formatDisplayCurrency(d.interestOverdue!) + "đ"
            self.lblOverdue?.text = FinPlusHelper.formatDisplayCurrency(d.overdue!) + "đ"
            self.lblFeeOverdue?.text = FinPlusHelper.formatDisplayCurrency(d.feeOverdue!) + "đ"
            
            let totalOverdue = d.borrowerManagingFeeOverdue! + d.principalOverdue! + d.interestOverdue! + d.overdue! + d.feeOverdue!
            self.lblTotalOverdue?.text = FinPlusHelper.formatDisplayCurrency(totalOverdue) + "đ"
            
            
            self.lblTotalPay?.text = FinPlusHelper.formatDisplayCurrency(totalOverdue + totalAmountInTerm) + "đ"
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    
    func updateCellView() {
        
        if isSelectedCell == true {
            self.containerView?.layer.borderColor = MAIN_COLOR.cgColor
            self.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_on")
        } else {
            self.containerView?.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            self.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_off")
        }
        
    }

    
    
}
