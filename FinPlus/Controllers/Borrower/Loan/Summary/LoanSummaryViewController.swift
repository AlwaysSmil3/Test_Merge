//
//  LoanSummaryViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/13/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSummaryViewController: BaseViewController {
    
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblFooterText: UILabel!
    @IBOutlet var btnNext: UIButton!
    
    var dataSource: [LoanSummaryModel] = []
    var activeLoan: BrowwerActiveLoan?
    var userInfo: BrowwerInfo!
    
    var bottom_state: BOTTOM_STATE!
    
    let cellIdentifier = "cell"
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard var loan = DataManager.shared.browwerInfo?.activeLoan else { return }
        
        var titleCate = "Khoản vay"
        if self.activeLoan != nil {
            loan = self.activeLoan!
        }
        
        var serviceFee: Double = 0
        if let config = DataManager.shared.config {
            serviceFee = Double(Int(loan.amount ?? 0) * (config.serviceFee ?? 0 ) / 100)
        }
        
        var rate = 0
        var payMounthTitle = "Trả góp hàng tháng"
        var term = "\((loan.term ?? 0)/30) tháng"
        
        if (loan.loanCategoryId == Loan_Student_Category_ID) && (loan.term ?? 0) <= 30 {
            payMounthTitle = "Thanh toán dự kiến"
            term = "\((loan.term ?? 0)) ngày"
        }
        
        titleCate = loan.loanCategory?.title ?? ""
        
        //Lãi suất
        if let inRate = loan.inRate, inRate > 0 {
            rate = Int(inRate)
        }
        
        let amountString = FinPlusHelper.formatDisplayCurrency(Double((loan.amount ?? 0)!)) + "đ"
        
        //Số tiên thanh toán hàng tháng
        let payMounth = FinPlusHelper.CalculateMoneyPayMonth(month: Double(loan.amount ?? 0), term: Double((loan.term ?? 0)/30), rate: Double(rate))
        let payMounthString = FinPlusHelper.formatDisplayCurrency(payMounth) + "đ"
        
        
        //Ngày tạo đơn
        var dateString = " "
        if let date_ = loan.createdAt, date_.length() > 0 {
            let date = Date.init(fromString: date_, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
            dateString = date.toString(.custom(kDisplayFormat))
            
        } else {
            dateString = Date().toString(.custom(kDisplayFormat))
        }
        
        //Số tiền huy động được
        let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
        var serviceFeeFunded: Double = 0
        
        var payMounthStringWithFunded = "0đ"
        
        if let config = DataManager.shared.config, let fun = loan.funded, fun > 0 {
            serviceFeeFunded = Double(Int(fun) * (config.serviceFee ?? 0 ) / 100)
            
            
            let payMounthWithFunded = FinPlusHelper.CalculateMoneyPayMonth(month: Double(fun), term: Double((loan.term ?? 0)/30), rate: Double(rate))
            payMounthStringWithFunded = FinPlusHelper.formatDisplayCurrency(payMounthWithFunded) + "đ"
            
        }
        /*
        //Ngay thanh toán tiếp theo
        var nextPaymentDate = "Đang cập nhật"
        if let nextDateString = loan.nextPaymentDate {
            let nextDate = Date(fromString: nextDateString, format: .iso8601(ISO8601Format.DateTimeSec))
            nextPaymentDate = nextDate.toString(DateFormat.custom(kDisplayFormat))
        }
        
        //số tháng đã thanh toán
        var paidMonth = "0 tháng"
        if let paid = loan.paidMonth {
            paidMonth = "\(paid) tháng"
        }
        */
        //Ngày huy động còn lại
        var acceptedDate = "30"
        var acceptedDateTemp = 0
        //var limitFunding = "Đang cập nhật"
        
        if let acceptedDateStr = loan.acceptedAt {
            let calendar = NSCalendar.current
            let d1 = Date()
            let date1 = calendar.startOfDay(for: d1)
            let d2 = Date(fromString: acceptedDateStr, format: .iso8601(ISO8601Format.DateTimeSec))
            let date2 = calendar.startOfDay(for: d2)
            
            if d1 > d2 {
                let components = calendar.dateComponents([.day], from: date2, to: date1)
                acceptedDateTemp = components.day!
            }
        }
        
        if let rasingCapital = DataManager.shared.config?.dateLimit?.rAISINGCAPITAL {
            let raisingDay = self.convertHourToDay(hour: rasingCapital)
            if raisingDay > acceptedDateTemp {
                acceptedDate = "\(rasingCapital - acceptedDateTemp)"
            }
            
//            let datelimit = Date(fromString: loan.acceptedAt ?? "", format: .iso8601(ISO8601Format.DateTimeSec)).dateByAddingHours(rasingCapital)
//            limitFunding = datelimit.toString(.custom("dd/MM/yyyy HH:mm"))
        }
 
        
        switch bottom_state {
            
        case .DISBURSEMENT_SOON?:
            //Giai ngan som
            let fullName = loan.userInfo?.fullName ?? ""
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Ngày huy động còn lại", value: "\(acceptedDate) Ngày", attributed: NSAttributedString(string: "\(acceptedDate) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
//            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
//            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
//
//            self.labelBottomView.text = "Không, tiếp tục huy động"
//            self.labelBottomView.isUserInteractionEnabled = true
//            self.labelBottomView.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
//            self.labelBottomView.textAlignment = .center
//            self.labelBottomView.textColor = UIColor(hexString: "#4D6678")
//
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navi_back))
//            tapGestureRecognizer.numberOfTapsRequired = 1
//            self.labelBottomView.addGestureRecognizer(tapGestureRecognizer)
//
//            isEnableFooterView = true
            
        case .DISBURSEMENT_ONTIME?:
            //Giai ngan dung han
            //let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            let fullName = loan.userInfo?.fullName ?? ""
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.navigationItem.rightBarButtonItem = nil
            self.lblTitle.text = "Giải ngân"
            self.btnNext.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.lblFooterText.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
//            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
//            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
//            self.labelBottomView.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
//            isEnableFooterView = true
            
        case .SIGN_CONTRACT?:
            //Ky hop dong
            //let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            let fullName = loan.userInfo?.fullName ?? ""
            
            self.navigationItem.rightBarButtonItem = nil
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.lblTitle.text = "Giải ngân"
            self.btnNext.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.lblFooterText.text = "Nếu bạn đồng ý vay với số tiền huy động được. Vui lòng tiến hành ký hợp đồng để giải ngân."
            
//            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
//            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
//            self.labelBottomView.text = "Nếu bạn đồng ý vay với số tiền huy động được. Vui lòng tiến hành ký hợp đồng để giải ngân."
//            isEnableFooterView = true
            
        case .CONFIRM_RATE?:
            //Xac nhan lai suat
            self.navigationItem.rightBarButtonItem = nil
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
            
            self.lblTitle.text = "Xác nhận lãi suất"
            self.btnNext.setTitle("Xác nhận", for: .normal)
            self.lblFooterText.text = "Tiền phí sẽ được trừ ngay sau khi giải ngân tiền vay."
            
//            self.btnBottomView.setTitle("Xác nhận", for: .normal)
//            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmRate), for: .touchUpInside)
//            self.labelBottomView.text = "Tiền phí sẽ được trừ ngay sau khi giải ngân tiền vay."
//            isEnableFooterView = true
            break
            
        default:
            break
        }
        
        
        // get loan bank
        let loanBankId = DataManager.shared.loanInfo.bankId
        if let userBanks = DataManager.shared.browwerInfo?.banks {
            for bank in userBanks {
                if let bankId = bank.id {
                    if bankId == loanBankId {
                        let accountNumber = bank.accountBankNumber ?? ""
//                        if let number = bank.accountBankNumber, number.count > 4 {
//                            accountNumber = String(number.suffix(4))
//                        } else {
//                            accountNumber = bank.accountBankNumber ?? ""
//                        }
//                        accountNumber = "● ● ● ● \(accountNumber)"
                        
//                        let subtitleParameters = [NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 12)]
                        
                        dataSource.append(LoanSummaryModel(name: "Ngân hàng / Ví", value: "\(bank.bankName ?? "")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Chủ tài khoản", value: "\(bank.accountBankName ?? "None")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Số tài khoản", value: accountNumber, attributed: nil))
                        
                    }
                }
            }
        }
        
        let cellNib = UINib(nibName: "DoubleTextTableViewCell", bundle: nil)
        self.dataTableView?.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        
        self.dataTableView?.tableHeaderView = UIView()
        self.dataTableView?.estimatedRowHeight = 123
        self.dataTableView?.rowHeight = UITableViewAutomaticDimension
        self.dataTableView?.alwaysBounceVertical = false;
        
        
    }
    
    
    /// Convert Hour to Day
    ///
    /// - Parameter hour: <#hour description#>
    /// - Returns: <#return value description#>
    private func convertHourToDay(hour: Int) -> Int {
        if hour % 24 == 0 {
            return Int(hour / 24)
        }
        
        return Int(hour / 24) + 1
    }
    
    //Ký hợp đồng để giải ngân
    private func confirmSignContract() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
        vc.activeLoan = self.activeLoan
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Xác nhận lãi suất
    private func confirmRate() {
        //Goi api thanh cong xong -> confirm_rate_success
        DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                
                self.confirm_rate_success()
            }
            .catch { error in }
        
    }
    
    private func confirm_rate_success()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONFIRM_RATE_SUCCESS")
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //Giải ngân
    
    
    //MARK: Actions
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        switch bottom_state {
        case .DISBURSEMENT_SOON?:
            self.confirmSignContract()
            break
        case .DISBURSEMENT_ONTIME?:
            self.confirmSignContract()
            break
            
        case .SIGN_CONTRACT?:
            self.confirmSignContract()
            break
            
        case .CONFIRM_RATE?:
            self.confirmRate()
            break
        default:
            break
        }
        
    }
    
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension LoanSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        }
        
        cell?.nameLabel.text = NSLocalizedString(item.name, comment: "")
        cell?.desLabel.text = item.value
        
        //            if (item.attributed != nil)
        //            {
        //                cell?.desLabel.attributedText = item.attributed!
        //            }
        
        if (item.attributed != nil)
        {
            let oldAttributed = NSMutableAttributedString(attributedString: (cell?.desLabel?.attributedText)!)
            
            if let range = item.value.range(of: item.attributed!.string)  {
                oldAttributed.addAttributes(item.attributed!.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, item.attributed!.length)), range: NSRange(range, in: item.value))
            }
            
            cell?.desLabel.attributedText = oldAttributed
        }
        
        if let cell_ = cell { return cell_ }
        
        return UITableViewCell()
    }
    
    
    
    
}


