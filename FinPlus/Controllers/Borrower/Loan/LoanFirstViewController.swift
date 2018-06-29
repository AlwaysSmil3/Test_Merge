//
//  LoanFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

/*
 Với khoản vay sinh viên chỉ cho vay 10-20-30 ngày nhé. Không phỉa từ 10-30 đâu.
 Các khoản khác 1-12 tháng. Không chia theo ngày

 */

class LoanFirstViewController: BaseViewController {
    
    @IBOutlet var lblCategoriesName: UILabel!
    
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
    @IBOutlet var lblLeftTempTotalAmount: UILabel!
    
    var loanCategory: LoanCategories? {
        didSet {
            self.setupInit()
        }
    }
    
    var listDataCategoriesForPopup: [LoanBuilderData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInit()
        self.updateData()
        
        self.termSlider?.setThumbImage(#imageLiteral(resourceName: "ic_elipse_slider"), for: UIControlState.normal)
        self.amountSlider?.setThumbImage(#imageLiteral(resourceName: "ic_elipse_slider"), for: UIControlState.normal)
        self.termSlider?.setThumbImage(#imageLiteral(resourceName: "ic_elipse_slider"), for: UIControlState.highlighted)
        self.amountSlider?.setThumbImage(#imageLiteral(resourceName: "ic_elipse_slider"), for: UIControlState.highlighted)
        
        for cate in DataManager.shared.loanCategories {
            var loan = LoanBuilderData(object: NSObject())
            loan.id = cate.id!
            loan.title = cate.title!
            self.listDataCategoriesForPopup.append(loan)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        super.viewWillAppear(animated)
        
    }
    
    
    /// Update data khi đã tạo 1 loan
    private func updateData() {
        var term: Float = 0
        var amount: Double = 0
        var cateID: Int16 = 0
        
        if let loan = DataManager.shared.browwerInfo?.activeLoan, let term_ = loan.term, term_ > 0 {
            term = Float(term_)
        }
        
        if let loan = DataManager.shared.browwerInfo?.activeLoan, let amount_ = loan.amount, amount_ > 0 {
            amount = Double(amount_)
        }
        
        if let loan = DataManager.shared.browwerInfo?.activeLoan, let cateId_ = loan.loanCategoryId, cateId_ > 0 {
            cateID = cateId_
        }
        
        if DataManager.shared.loanInfo.term > 0 {
            term = Float(DataManager.shared.loanInfo.term)
        }
        
        if DataManager.shared.loanInfo.amount > 0 {
            amount = Double(DataManager.shared.loanInfo.amount)
        }
        
        if DataManager.shared.loanInfo.loanCategoryID > 0 {
            cateID = DataManager.shared.loanInfo.loanCategoryID
        }
        
        if cateID > 0 {
            DataManager.shared.loanInfo.loanCategoryID = cateID
        }
        
        guard let cate = DataManager.shared.getCurrentCategory() else { return }
        
        self.loanCategory = cate
        //self.lblCategoriesName?.text = cate.title!
        
        if term > 0 {
            DataManager.shared.loanInfo.term = Int(term)
            self.updateTearmSlider(loan: cate, value: term)
        }
        
        if amount > 0 {
            DataManager.shared.loanInfo.amount = Int32(amount)
            self.updateAmountSlider(loan: cate, value: Float(amount))
        }
        
        self.updateTotalAmountMounth()
    }
    
    private func setupInit() {
        guard let loan = self.loanCategory else { return }
        self.lblCategoriesName?.text = loan.title!
        
        self.updateTearmSlider(loan: loan)
        self.updateAmountSlider(loan: loan)

        self.lblInterestRate?.text = "\(Int(loan.interestRate!))%/năm"
        self.lblTempTotalAmount?.text = "0đ"
    }
    
    
    /// Update Tearm Slider for Loan
    ///
    /// - Parameter loan: <#loan description#>
    private func updateTearmSlider(loan: LoanCategories, value: Float? = nil) {
        self.termSlider?.minimumValue = Float(loan.termMin!)
        self.termSlider?.maximumValue = Float(loan.termMax!)
        self.termSlider?.value = Float(loan.termMin!)
        
        if let value_ = value {
            self.termSlider?.value = value_
        }
        
        
        if loan.id == Loan_Student_Category_ID {
            self.lblTermSlider?.text = "\(Int(loan.termMin!))" + " Ngày"
            if let value_ = value {
                self.lblTermSlider?.text = "\(Int(value_))" + " Ngày"
            }
            
            self.lblMinTermSlider?.text = "\(Int(loan.termMin!)) NGÀY"
            self.lblMaxTermSlider?.text = "\(Int(loan.termMax!)) NGÀY"
            
            self.lblLeftTempTotalAmount?.text = "Thanh toán dự kiến"
        } else {
            self.lblTermSlider?.text = "\(Int(loan.termMin! / 30))" + " Tháng"
            if let value_ = value {
                self.lblTermSlider?.text = "\(Int(value_ / 30))" + " Tháng"
            }
            
            self.lblMinTermSlider?.text = "\(Int(loan.termMin! / 30)) THÁNG"
            self.lblMaxTermSlider?.text = "\(Int(loan.termMax! / 30)) THÁNG"
            
            self.lblLeftTempTotalAmount?.text = "Trả góp dự kiến hàng tháng"
        }
    }
    
    
    /// Update Amount Slider For Loan
    ///
    /// - Parameter loan: <#loan description#>
    private func updateAmountSlider(loan: LoanCategories, value: Float? = nil) {
        self.amountSlider?.minimumValue = Float(loan.min!/MONEY_TERM_DISPLAY)
        self.amountSlider?.maximumValue = Float(loan.max!/MONEY_TERM_DISPLAY)
        self.amountSlider?.value = Float(loan.min!/MONEY_TERM_DISPLAY)
        
        self.updateServiceFee(loan: loan)
        
         var amountDouble = Double(loan.min!)
        if let value_ = value {
            self.amountSlider?.value = Float(Int32(value_) / MONEY_TERM_DISPLAY)
            amountDouble = Double(value_)
        }
        
        self.lblMoneySlider?.text = FinPlusHelper.formatDisplayCurrency(amountDouble) + "đ"
        
        self.lblMinAmountSlider?.text = "\(Int(loan.min!/MONEY_TERM_DISPLAY)) TRIỆU"
        self.lblMaxAmounSlider?.text = "\(Int(loan.max!/MONEY_TERM_DISPLAY)) TRIỆU"
    }
    
    
    /// Update Service Fee
    ///
    /// - Parameter loan: <#loan description#>
    private func updateServiceFee(loan: LoanCategories) {
        if let config = DataManager.shared.config {
            let fee = Int(loan.min!) * config.serviceFee! / 100
            self.lblTempFee?.text = FinPlusHelper.formatDisplayCurrency(Double(fee)) + "đ"
        }
    }
    
    private func updateDataToLoanAPI(completion: () -> Void) {
        guard let loan = self.loanCategory else { return }
        
        DataManager.shared.loanInfo.loanCategoryID = loan.id!
        DataManager.shared.loanInfo.amount = Int32(Int32(self.amountSlider.value) * MONEY_TERM_DISPLAY)
        
        if loan.id == Loan_Student_Category_ID {
            DataManager.shared.loanInfo.term = Int(self.termSlider.value / 10) * 10
        } else {
            DataManager.shared.loanInfo.term = Int(self.termSlider.value / 30) * 30
        }
        
        completion()
    }
    
    //MARK: Actions
    
    @IBAction func btnGotoCaculatoFee(_ sender: Any) {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CALCULATE_PAY") as! CalPayViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnListCategoriesShow(_ sender: Any) {
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.setDataSource(data: listDataCategoriesForPopup, type: .Categories)
        popup.titleString = "Mục đích vay"
        popup.delegate = self
        
        popup.show()
    }
    
    
    @IBAction func moneySliderValueChaned(_ sender: Any) {
        //self.lblMoneySlider.text = "\(Int(self.amountSlider.value))" + " Triệu"
        let amountInt = Int(self.amountSlider.value) / Int(self.amountSlider.minimumValue) * 1000000
        let amountDouble = Double(amountInt)
        self.lblMoneySlider.text = FinPlusHelper.formatDisplayCurrency(amountDouble) + "đ"
        
        //Cho set step
        if let slider = sender as? UISlider {
            let fixed = roundf(Float(Int(slider.value)))
            self.amountSlider.setValue(fixed, animated: true)
        }
        self.updateTotalAmountMounth()
    }
    
    @IBAction func termSliderValueChanged(_ sender: Any) {
        guard let loan = self.loanCategory, let slider = sender as? UISlider else { return }
        //Cho set step
        if loan.id == Loan_Student_Category_ID {
            let fixed = roundf(slider.value / 10.0) * 10.0
            self.termSlider.setValue(fixed, animated: true)
            self.lblTermSlider.text = "\(Int(self.termSlider.value / 10) * 10)" + " Ngày"
        } else {
            let fixed = roundf(slider.value / 30.0) * 30.0
            self.termSlider.setValue(fixed, animated: true)
            self.lblTermSlider.text = "\(Int(self.termSlider.value / 30))" + " Tháng"
        }
        self.updateTotalAmountMounth()
    }
    
    //Update số tiền trả góp hàng tháng
    private func updateTotalAmountMounth() {
        guard let version = DataManager.shared.config, let loan = self.loanCategory else { return }
        
        let fee = Double(Int(self.amountSlider.value) * version.serviceFee! * 1000000 / 100)
        self.lblTempFee.text = FinPlusHelper.formatDisplayCurrency(fee) + "đ"
        let amountInt = Int(self.amountSlider.value) / Int(self.amountSlider.minimumValue) * 1000000
        var amountDouble = Double(amountInt)
        
        let term = self.termSlider.value
        amountDouble = FinPlusHelper.CalculateMoneyPayMonth(month: amountDouble, term: Double(term/30), rate: loan.interestRate!)
        
        self.lblTempTotalAmount.text = FinPlusHelper.formatDisplayCurrency(amountDouble) + "đ"
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.updateDataToLoanAPI {
            let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
            
            self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
        }
        
    }
    
    @IBAction func showInfoFee(_ sender: Any) {
        let interestRateVC = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "InfoInterestRatePopupVC") as! InfoInterestRatePopupVC
        
        interestRateVC.titleString = "Thông tin lãi xuất"
        interestRateVC.show()
    }
    
    @IBAction func showInfoServiceFee(_ sender: Any) {
        self.showToastWithMessage(message: "Khoản phí được thu khi khoản vay được giải ngân thành công")
    }
    
}

extension LoanFirstViewController: DataSelectedFromPopupProtocol {
    func dataSelected(data: LoanBuilderData) {
        DataManager.shared.loanInfo.loanCategoryID = data.id!
        self.loanCategory = DataManager.shared.getCurrentCategory()
    }
}
