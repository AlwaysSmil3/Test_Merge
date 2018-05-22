//
//  BorrowHomeViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BorrowHomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .then(on: DispatchQueue.main) { model -> Void in
                
                
            }
            .catch { error in
                
            }
        
    }
    
    //MARK: Actions
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
        
        
    }
    
    
    
    
}
