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
    
    @IBOutlet var amountSlider: VSSlider!
    @IBOutlet var termSlider: VSSlider!
    
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

        
        for cate in DataManager.shared.loanCategories {
            var loan = LoanBuilderData(object: NSObject())
            loan.id = cate.id!
            loan.title = cate.title!
            loan.subTitle = "\(cate.min! / MONEY_TERM_DISPLAY)-\(cate.max! / MONEY_TERM_DISPLAY) triệu"
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
        //self.lblTempTotalAmount?.text = "0đ"
        self.updateTotalAmountMounth()
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
            self.termSlider?.increment = 10
            
            self.lblMinTermSlider?.text = "\(Int(loan.termMin!)) NGÀY"
            self.lblMaxTermSlider?.text = "\(Int(loan.termMax!)) NGÀY"
            
            self.lblLeftTempTotalAmount?.text = "Thanh toán dự kiến"
        } else {
            self.lblTermSlider?.text = "\(Int(loan.termMin! / 30))" + " Tháng"
            if let value_ = value {
                self.lblTermSlider?.text = "\(Int(value_ / 30))" + " Tháng"
            }
            self.termSlider?.increment = 30
            
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
        
        self.updateTotalAmountMounth()
    }
    
    @IBAction func termSliderValueChanged(_ sender: Any) {
        guard let loan = self.loanCategory else { return }
        //Cho set step
        if loan.id == Loan_Student_Category_ID {
            self.lblTermSlider.text = "\(Int(self.termSlider.value / 10) * 10)" + " Ngày"
        } else {
            self.lblTermSlider.text = "\(Int(self.termSlider.value / 30))" + " Tháng"
        }
        self.updateTotalAmountMounth()
    }
    
    
    //Update số tiền trả góp hàng tháng
    private func updateTotalAmountMounth() {
        guard let version = DataManager.shared.config, let loan = self.loanCategory, self.amountSlider != nil, self.termSlider != nil else { return }
        
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
            if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
                //Cập nhật
                let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
                
                self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
            } else {
                //chua có thì tạo
                APIClient.shared.loan(isShowLoandingView: true, httpType: .POST)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.loanID = model.loanId!
                        
                        //Lay thong tin nguoi dung
                        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                            .done(on: DispatchQueue.main) { model in
                                DataManager.shared.browwerInfo = model
                                
                                let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
                                
                                self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
                                
                            }
                            .catch { error in
                                self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }
                    .catch { error in }
            }
            
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
