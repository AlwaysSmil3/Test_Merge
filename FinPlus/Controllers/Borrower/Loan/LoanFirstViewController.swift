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
    @IBOutlet var lblMaxAmounSlider: UILabel!
    @IBOutlet var lblMaxTermSlider: UILabel!
    
    @IBOutlet var lblMoneySlider: UILabel!
    @IBOutlet var lblTermSlider: UILabel!

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
        
        self.lblMinAmountSlider.text = "\(Int(loan.min!/MONEY_TERM_DISPLAY)) TRIỆU"
        self.lblMinTermSlider.text = "\(Int(loan.termMin!)) NGÀY"
        
        self.lblInterestRate.text = "\(loan.interestRate!)% năm"
        
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

        guard let version = DataManager.shared.version else { return }
        
        let fee = Double(Int(self.amountSlider.value) * version.serviceFee! * 1000000 / 100)
        
        self.lblTempFee.text = FinPlusHelper.formatDisplayCurrency(fee) + " VND"
        
        self.lblTempTotalAmount.text = FinPlusHelper.formatDisplayCurrency(fee + Double(self.amountSlider.value  * 1000000)) + " VND"
        
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
    
    @IBAction func showInfoFee(_ sender: Any) {
        self.showToastWithMessage(message: "Lãi xuất vay thực tế sẽ được quyết định vào thời điểm duyệt")
    }
    
    @IBAction func showInfoServiceFee(_ sender: Any) {
        self.showToastWithMessage(message: "Phí dịch vụ dự kiến")
    }
    
    
    
}
