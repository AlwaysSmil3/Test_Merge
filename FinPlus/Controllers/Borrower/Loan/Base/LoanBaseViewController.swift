//
//  LoanBaseViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/29/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanBaseViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateDataToServer() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .then(on: DispatchQueue.main) { model -> Void in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    
}
