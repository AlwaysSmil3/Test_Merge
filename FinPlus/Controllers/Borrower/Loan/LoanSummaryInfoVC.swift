//
//  LoanSummaryInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSummaryInfoVC: BaseViewController {
    
    @IBOutlet var mainTBView: UITableView!
    
    let currentCategory: LoanCategories? = DataManager.shared.getCurrentCategory()
    
    var dataSource: [LoanSummaryModel] = [
        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount),
        LoanSummaryModel(name: "Ngày tạo đơn", value: "Date"),
        LoanSummaryModel(name: "Số tiền vay", value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ"),
        LoanSummaryModel(name: "Kỳ hạn vay", value: "\(DataManager.shared.loanInfo.term) Ngày"),
        LoanSummaryModel(name: "Lãi xuất dự kiến", value: ""),
        LoanSummaryModel(name: "Phí dịch vụ", value: ""),
        LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: ""),
        LoanSummaryModel(name: "Mục đích vay", value: ""),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.tableFooterView = UIView()
        self.mainTBView.allowsSelection = false

        DataManager.shared.loanInfo.currentStep = 5
        
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func setupData() {
        guard let cate = self.currentCategory else { return }
        
        var fee: Double = 0
        if let version = DataManager.shared.config {
            fee = Double(Int(DataManager.shared.loanInfo.amount) * version.serviceFee! / 100)
        }
        let feeStr = FinPlusHelper.formatDisplayCurrency(fee) + "đ"
        
        let date = Date().toString(DateFormat.custom(kDisplayFormat))
        
        var labelStudentLoan = ""
        var amountDouble = Double(DataManager.shared.loanInfo.amount)
        
        let term = DataManager.shared.loanInfo.term
        amountDouble = FinPlusHelper.CalculateMoneyPayMonth(month: amountDouble, term: Double(term/30), rate: cate.interestRate!)
        
        if cate.id == Loan_Student_Category_ID {
            labelStudentLoan = "Thanh toán dự kiến"
        } else {
            labelStudentLoan = "Trả góp dự kiến hàng tháng"
        }

        
        dataSource = [
        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount),
        LoanSummaryModel(name: "Ngày tạo đơn", value: date),
        LoanSummaryModel(name: "Số tiền vay", value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ"),
        LoanSummaryModel(name: "Kỳ hạn vay", value: "\(DataManager.shared.loanInfo.term) Ngày"),
        LoanSummaryModel(name: "Lãi xuất dự kiến", value: "\(Int(cate.interestRate!))% năm"),
        LoanSummaryModel(name: "Phí dịch vụ", value: feeStr),
        LoanSummaryModel(name: labelStudentLoan, value: FinPlusHelper.formatDisplayCurrency(amountDouble) + "đ"),
        LoanSummaryModel(name: "Mục đích vay", value: cate.title!)
        
        ]
        
        
    }
    
    
    private func loan() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.main) { [weak self] model in
                DataManager.shared.loanID = model.loanId!
                
                let otpVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                otpVC.loanResponseModel = model
                otpVC.verifyType = .Loan
                self?.navigationController?.pushViewController(otpVC, animated: true)
            }
            .catch { error in }
        
    }
    
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        let messeage = "Mã xác thực sẽ được gửi tới " + DataManager.shared.currentAccount + " qua tin nhắn SMS sau khi bạn đồng ý. Bạn có chắc chắn không?"
        
        self.showGreenBtnMessage(title: "Gửi đơn vay", message: messeage, okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ") { (status) in
            
            if status {
                self.loan()
            }
        }
        
    }
    
}

extension LoanSummaryInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        let model = self.dataSource[indexPath.row]
        
        cell.lblValue.text = model.name
        cell.lblSubTitle.text = model.value
        
        if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6 {
            cell.lblSubTitle.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: 17)
        } else {
            cell.lblSubTitle.font = UIFont(name: FONT_FAMILY_REGULAR, size: 17)
        }
        
        return cell
    }
    
    
    
}


