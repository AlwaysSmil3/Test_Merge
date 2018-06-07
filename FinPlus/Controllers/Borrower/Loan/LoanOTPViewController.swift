//
//  LoanOTPViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanOTPViewController: BaseViewController {
    
    @IBOutlet var tfOTP: UITextField!
    
    var loanResponseModel: LoanResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func verify() {
        
        guard let loan = self.loanResponseModel else { return }
        
        if tfOTP.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mã xác thực")
            return
        }
        
        APIClient.shared.loanVerify(otp: self.tfOTP.text!, loanID: loan.loanId!)
            .done(on: DispatchQueue.main) { [weak self] model in
                
                self?.navigationController?.popToRootViewController(animated: true)
                self?.showToastWithMessage(message: model.returnMsg!)
                
            }
            .catch { error in }
        
    }
    
    
    //MARK: Actions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        self.verify()
        
    }
    
    
}
