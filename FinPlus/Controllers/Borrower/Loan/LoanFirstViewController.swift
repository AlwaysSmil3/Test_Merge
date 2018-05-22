//
//  LoanFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanFirstViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Actions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
        
        self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
    }
    
    
    
    
}
