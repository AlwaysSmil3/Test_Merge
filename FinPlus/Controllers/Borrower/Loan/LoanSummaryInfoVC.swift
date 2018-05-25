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
                
                print("\(model)")
                
            }
            .catch { error in }
        
        
    }
    
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        self.loan()
    }
    
    
    
}
