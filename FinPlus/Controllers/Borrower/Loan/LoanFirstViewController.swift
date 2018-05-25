//
//  LoanFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanFirstViewController: BaseViewController {
    
    @IBOutlet var amountSlider: UISlider!
    @IBOutlet var termSlider: UISlider!
    
    @IBOutlet var lblMinAmountSlider: UILabel!
    @IBOutlet var lblMinTermSlider: UILabel!
    
    @IBOutlet var lblMoneySlider: UILabel!
    @IBOutlet var lblTermSlider: UILabel!
    @IBOutlet var lblAmountLoan: UILabel!
    @IBOutlet var lblLoanTerm: UILabel!
    @IBOutlet var lblInterestRate: UILabel!
    @IBOutlet var lblTempFee: UILabel!
    @IBOutlet var lblTempTotalAmount: UILabel!
    
    var loanCategory: LoanCategories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupInit() {
        
        guard let loan = self.loanCategory else { return }
        
        self.amountSlider.minimumValue = Float(loan.min!/MONEY_TERM_DISPLAY)
        self.amountSlider.maximumValue = Float(loan.max!/MONEY_TERM_DISPLAY)
        self.amountSlider.value = Float(loan.min!/MONEY_TERM_DISPLAY)
        
        self.termSlider.minimumValue = Float(loan.termMin!)
        self.termSlider.maximumValue = Float(loan.termMax!)
        self.termSlider.value = Float(loan.termMin!)
        
        self.lblMoneySlider.text = "\(Int(loan.max!/MONEY_TERM_DISPLAY))" + " Triệu VND"
        self.lblTermSlider.text = "\(Int(loan.termMax!))" + " Ngày"
        
        self.lblMinAmountSlider.text = "\(Int(loan.min!/MONEY_TERM_DISPLAY))"
        self.lblMinTermSlider.text = "\(Int(loan.termMin!))"
        
        
    }
    
    private func updateDataToLoanAPI(completion: () -> Void) {
        guard let loan = self.loanCategory else { return }
        
        DataManager.shared.loanInfo.loanCategoryID = loan.id!
        
        DataManager.shared.loanInfo.amount = Int32(Int(self.amountSlider.value) * MONEY_TERM_DISPLAY)
        DataManager.shared.loanInfo.term = Int(self.termSlider.value)
        
        completion()
    }
    
    
    
    //MARK: Actions
    @IBAction func moneySliderValueChaned(_ sender: Any) {
        self.lblMoneySlider.text = "\(Int(self.amountSlider.value))" + " Triệu VND"
        
    }
    
    @IBAction func termSliderValueChanged(_ sender: Any) {
        self.lblTermSlider.text = "\(Int(self.termSlider.value))" + " Ngày"
        
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.updateDataToLoanAPI {
            let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
            
            self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
        }
        
    }
    
    
    
    
}
