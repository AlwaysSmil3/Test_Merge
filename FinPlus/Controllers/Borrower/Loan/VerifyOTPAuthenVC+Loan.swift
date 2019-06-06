//
//  LoanOTPViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension VerifyOTPAuthenVC {
    
    //MARK: Verify Loan
    func verifyOTPLoan() {
        APIClient.shared.loanVerify(otp: self.otp, loanID: DataManager.shared.loanID ?? 0)
            .done(on: DispatchQueue.main) { [weak self] model in
                let successVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSendSuccessVC") as! LoanSendSuccessVC
                self?.navigationController?.pushViewController(successVC, animated: true)
                
            }
            .catch { error in }
    }
    
   
}
