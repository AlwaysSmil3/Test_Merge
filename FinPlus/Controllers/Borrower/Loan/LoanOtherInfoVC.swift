//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanOtherInfoVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK: ACtions
    
    
    @IBAction func btnLoanImgOtherInfoTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
    }
    
    
    
    
}
