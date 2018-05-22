//
//  LoanNationalIDViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanNationalIDViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    //MARK: Actions
    
    @IBAction func btnLoadCMNDImgFrontTapped(_ sender: Any) {
    }
    
    @IBAction func btnLoadCMNDImgHideTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
        
        self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
        
        
    }
    
    
    
    
}
