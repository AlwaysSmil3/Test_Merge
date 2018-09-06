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
    @IBOutlet var btnAgreeTerm: UIButton?

    
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
        LoanSummaryModel(name: "Ngân hàng / Ví", value: "", attributed: nil),
        LoanSummaryModel(name: "Chủ tài khoản", value: "", attributed: nil),
        LoanSummaryModel(name: "Số tài khoản", value: "", attributed: nil),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.tableFooterView = UIView()
        self.mainTBView.allowsSelection = false
        
        self.btnContinue?.dropShadow(color: MAIN_COLOR)

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
            LoanSummaryModel(name: "Mục đích vay", value: cate.title!, attributed: nil),
        ]
        // get loan bank
        let loanBankId = DataManager.shared.loanInfo.bankId
        if let userBanks = DataManager.shared.browwerInfo?.banks {
            for bank in userBanks {
                if let bankId = bank.id {
                    if bankId == loanBankId {
                        var accountNumber = ""
                        if let number = bank.accountBankNumber, number.count > 4 {
                             accountNumber = String(number.suffix(4))
                        } else {
                            accountNumber = bank.accountBankNumber ?? ""
                        }
                        accountNumber = "● ● ● ● \(accountNumber)"
                        let subtitleParameters = [NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 12)]
                        
                        dataSource.append(LoanSummaryModel(name: "Ngân hàng / Ví", value: "\(bank.bankName ?? "")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Chủ tài khoản", value: "\(bank.accountBankName ?? "None")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Số tài khoản", value: accountNumber, attributed: NSAttributedString(string: "● ● ● ●", attributes: subtitleParameters)))

                    }
                }
            }
        }
        
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
        
        let policyStr : String = "Tôi đã hiểu và đồng ý với điều khoản sử dụng."
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr, attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 15)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
        let myRange = (myMutableString.string as NSString).range(of: "Tôi đã hiểu và đồng ý với ")
        myMutableString.addAttribute(
            NSAttributedStringKey.link,
            value: "more://",
            range: (myMutableString.string as NSString).range(of: "điều khoản sử dụng."))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "#4D6678"), range: myRange)
        
//        let string2 = NSMutableAttributedString(string: " của Mony", attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
//
//        myMutableString.append(string2)
        
        
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
    
    //MARK: Actions
    
    @IBAction func btnAgreeTermTapped(_ sender: Any) {
        self.btnAgreeTerm!.isSelected = !self.btnAgreeTerm!.isSelected
    }
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        guard self.btnAgreeTerm!.isSelected else {
            self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: "Vui lòng đồng ý với điều khoản sử dụng của chúng tôi để tiếp tục", okTitle: "OK", cancelTitle: nil)
            
            return
        }
        
//        guard DataManager.shared.listKeyMissingLoanKey == nil || DataManager.shared.listKeyMissingLoanKey!.count == 0 else {
//            self.updateLoanStatus()
//            return
//        }
        

        let messeage = "Mã xác thực sẽ được gửi tới " + DataManager.shared.currentAccount + " qua tin nhắn SMS sau khi bạn đồng ý. Bạn có chắc chắn không?"
        self.showGreenBtnMessage(title: "Gửi đơn vay", message: messeage, okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ") { (status) in
            if status {
                self.loan()
            }
        }
        
    }
    
    private func updateLoanStatus() {
        DataManager.shared.loanInfo.status = DataManager.shared.loanInfo.status - 1
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                
                //Lay thong tin nguoi dung
                APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.browwerInfo = model
                        
                        self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: "Bạn đã cập nhật thông tin xong!", okTitle: "Về trang chủ", cancelTitle: nil) { (status) in
                            if status {
                                if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
                                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                                    if let window = UIApplication.shared.delegate?.window, let win = window {
                                        win.rootViewController = tabbarVC
                                    }
                                } else {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                        
                    }
                    .catch { error in
                        self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
            .catch { error in }
        
        
    }
    
}

extension LoanSummaryInfoVC: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "more" {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .termView
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


