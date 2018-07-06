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
    @IBOutlet var footerTextView: UITextView!
    
    let currentCategory: LoanCategories? = DataManager.shared.getCurrentCategory()
    
    var dataSource: [LoanSummaryModel] = [
        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
        LoanSummaryModel(name: "Ngày tạo đơn", value: "Date", attributed: nil),
        LoanSummaryModel(name: "Số tiền vay", value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ", attributed: nil),
        LoanSummaryModel(name: "Kỳ hạn vay", value: "\(DataManager.shared.loanInfo.term) Ngày", attributed: nil),
        LoanSummaryModel(name: "Lãi xuất dự kiến", value: "", attributed: nil),
        LoanSummaryModel(name: "Phí dịch vụ", value: "", attributed: nil),
        LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: "", attributed: nil),
        LoanSummaryModel(name: "Mục đích vay", value: "", attributed: nil),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.tableFooterView = UIView()
        self.mainTBView.allowsSelection = false

        DataManager.shared.loanInfo.currentStep = 5
        
        self.footerTextView.delegate = self
        self.footerTextView.isSelectable = true
        self.footerTextView.isEditable = false
        
        self.setupData()
        self.setupTextView()
        
        self.updateDataLoan()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
    
    private func setupData() {
        guard let cate = self.currentCategory else { return }
        
        var fee: Double = 0
        if let version = DataManager.shared.config {
            fee = Double(Int(DataManager.shared.loanInfo.amount) * version.serviceFee! / 100)
        }
        let feeStr = FinPlusHelper.formatDisplayCurrency(fee) + "đ"
        
        let date = Date().toString(DateFormat.custom(kDisplayFormat))
        
        let term = DataManager.shared.loanInfo.term
        
        var labelStudentLoan = ""
        var termDisplay = ""
        if cate.id == Loan_Student_Category_ID {
            labelStudentLoan = "Thanh toán dự kiến"
            termDisplay = "\(term) Ngày"
        } else {
            labelStudentLoan = "Trả góp dự kiến hàng tháng"
            termDisplay = "\(term / 30) Tháng"
        }
        
        var amountDouble = Double(DataManager.shared.loanInfo.amount)
        
        
        amountDouble = FinPlusHelper.CalculateMoneyPayMonth(month: amountDouble, term: Double(term/30), rate: cate.interestRate!)
        
        
        dataSource = [
            LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
            LoanSummaryModel(name: "Ngày tạo đơn", value: date, attributed: nil),
            LoanSummaryModel(name: "Số tiền vay", value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ", attributed: nil),
            LoanSummaryModel(name: "Kỳ hạn vay", value: termDisplay, attributed: nil),
            LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(Int(cate.interestRate!))%/năm", attributed: nil),
            LoanSummaryModel(name: "Phí dịch vụ", value: feeStr, attributed: nil),
            LoanSummaryModel(name: labelStudentLoan, value: FinPlusHelper.formatDisplayCurrency(amountDouble) + "đ", attributed: nil),
            LoanSummaryModel(name: "Mục đích vay", value: cate.title!, attributed: nil)
        ]
        
    }
    
    private func updateDataLoan() {
        DataManager.shared.loanInfo.currentStep = 5
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!

            }
            .catch { error in }
    }
    
    
    /// Set link cho UITextView
    private func setupTextView() {
        
        let policyStr : String = "Bằng cách ấn nút gửi 'Gửi đơn vay' ở trên tôi đã hiểu và đồng ý với điều khoản sử dụng"
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr, attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
        let myRange = (myMutableString.string as NSString).range(of: "Bằng cách ấn nút gửi 'Gửi đơn vay' ở trên tôi đã hiểu và đồng ý với ")
        myMutableString.addAttribute(
            NSAttributedStringKey.link,
            value: "more://",
            range: (myMutableString.string as NSString).range(of: "điều khoản sử dụng"))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "#4D6678"), range: myRange)
        
        let string2 = NSMutableAttributedString(string: " của FinSmart", attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])

        myMutableString.append(string2)
        
        
        UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#3EAA5F")]
        
        self.footerTextView.attributedText = myMutableString
        
    }
    
    
    private func loan() {
        APIClient.shared.getLoanOTP(loanID: DataManager.shared.loanID ?? 0)
            .done(on: DispatchQueue.main) { [weak self] model in

                let otpVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
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

extension LoanSummaryInfoVC: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "more" {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .aboutView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        else {
            return true
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


