//
//  LoanSummaryInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSummaryInfoVC: LoanBaseViewController {
    
    
    @IBOutlet var lblAccountName: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblAmountLoan: UILabel!
    @IBOutlet var lblTermLoan: UILabel!
    @IBOutlet var lblTempFee: UILabel!
    @IBOutlet var lblTempTotalAmount: UILabel!
    @IBOutlet var lblTempPayAMonth: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    private func updateUI() {
        
        self.lblAccountName.text = "Xin chào, " + DataManager.shared.loanInfo.userInfo.fullName
        self.lblPhoneNumber.text = "Số điện thoại: " + DataManager.shared.currentAccount
        
        self.lblAmountLoan.text = "Số tiền đăng ký vay: " +  FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + " VND"
        
        self.lblTermLoan.text = "Kỳ hạn vay: " + "\(DataManager.shared.loanInfo.term)"
        
    }
    
    
    private func loan() {
        APIClient.shared.loan()
            .done(on: DispatchQueue.main) { [weak self] model in
                
                let otpVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                otpVC.loanResponseModel = model
                otpVC.verifyType = .Loan
                self?.navigationController?.pushViewController(otpVC, animated: true)
                
            }
            .catch { error in }
    }
    
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        self.loan()
    }
    
    
    
}
