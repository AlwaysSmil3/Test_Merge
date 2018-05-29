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
        self.getLoanCategories()
        
    }
    
    // Lấy thông tin User
    private func getUserInfo() {
        
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .then(on: DispatchQueue.main) { model -> Void in
                print("User \(model)")
                
            }
            .catch { error in }
    }
    
    // Lấy danh sách các loại khoản vay
    private func getLoanCategories() {
        guard DataManager.shared.loanCategories.count == 0 else { return }
        
        APIClient.shared.getLoanCategories()
            .then(on: DispatchQueue.main) { model -> Void in
                DataManager.shared.loanCategories = model
            }
            .catch { error in }
    }
    
    
    //MARK: Actions
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[0]
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
        
    }
    
    
    
    
}
