//
//  AlertConfirmCreateLoanPopup.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/9/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol AlertAggreeCreateLoanDelegate {
    func confirmAggree()
}

class AlertConfirmCreateLoanPopup: BasePopup {
    
    
    
    @IBOutlet weak var btnChecked: UIButton!
    var loanCategory: LoanCategories?
    
    var delegate: AlertAggreeCreateLoanDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: Actions
    
    @IBAction func btnAggreeTapped(_ sender: Any) {
        self.hide {
            if !self.btnChecked.isSelected {
                userDefault.set("1", forKey: kUserDefault_Aler_Popup_Confirm_Loan)
                userDefault.synchronize()
            }
            self.delegate?.confirmAggree()
            
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        self.btnChecked.isSelected = !self.btnChecked.isSelected
        
    }
    
    
}
