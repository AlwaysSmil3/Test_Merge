//
//  LoanPersionalInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanPersionalInfoVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: Actions
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
        
        self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
        
    }
    
    
    
}
