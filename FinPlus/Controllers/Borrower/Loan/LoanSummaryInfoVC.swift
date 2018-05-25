//
//  LoanSummaryInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSummaryInfoVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func loan() {
        APIClient.shared.loan()
            .then(on: DispatchQueue.main) { model -> Void in
                
                let otpVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOTPViewController") as! LoanOTPViewController
                otpVC.loanResponseModel = model
                self.navigationController?.pushViewController(otpVC, animated: true)
                
            }
            .catch { error in }
    }
    
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        self.loan()
    }
    
    
    
}
