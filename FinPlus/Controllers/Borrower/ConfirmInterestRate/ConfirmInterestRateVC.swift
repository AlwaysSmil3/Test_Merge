//
//  ConfirmInterestRateVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/31/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class ConfirmInterestRateVC: BaseViewController {
    
    @IBOutlet var lblAmountLoan: UILabel!
    @IBOutlet var lblTimeLoan: UILabel!
    @IBOutlet var lblInterestRate: UILabel!
    @IBOutlet var lblServiceFee: UILabel!
    @IBOutlet var lblYearFee: UILabel!
    @IBOutlet var lblMounthPay: UILabel!
    @IBOutlet var lblPeriodPay: UILabel!
    @IBOutlet var lblDateReview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    private func updateUI() {
        
        guard let loan = DataManager.shared.browwerInfo?.activeLoan else { return }
        
        self.lblAmountLoan.text = FinPlusHelper.formatDisplayCurrency(Double(loan.amount!)) + " VND"
        self.lblTimeLoan.text = "\(loan.term!) ngày"
        
        if let interestRate = FinPlusHelper.getInterestRateFromLoanCategoryID(id: loan.loanCategoryId!) {
            self.lblInterestRate.text = "\(interestRate)%/Năm"
        }
        
        var serviceFee: Double = 0.0
        
        if let version = DataManager.shared.config {
            serviceFee = Double(loan.amount! * Int32(version.serviceFee!) / 100)
        }
        
        self.lblServiceFee.text = FinPlusHelper.formatDisplayCurrency(serviceFee) + " VND"
    }
    

    @IBAction func btnLoanAcceptTapped(_ sender: Any) {
        DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { [weak self] model in
                DataManager.shared.loanID = model.loanId!
                self?.showAlertView(title: MS_TITLE_ALERT, message: "", okTitle: "Trở về trang chủ", cancelTitle: nil, completion: { (status) in
                    if status {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                })
            }
            .catch { error in }
    }
    
}
