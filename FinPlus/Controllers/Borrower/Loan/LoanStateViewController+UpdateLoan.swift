//
//  LoanStateViewController+UpdateLoan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/29/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension LoanStateViewController {
    
    // Hoan thien don
    @IBAction func update_loan()
    {
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        guard let info = DataManager.shared.browwerInfo else { return }
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[0]
        DataManager.shared.currentIndexCategoriesSelectedPopup = 0
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    
    
}
