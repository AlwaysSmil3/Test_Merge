//
//  LoanSummaryInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreLocation
import APAddressBook

class LoanSummaryInfoVC: BaseViewController {
    
    @IBOutlet var mainTBView: UITableView!
    @IBOutlet var footerTextView: UITextView!
    @IBOutlet var btnAgreeTerm: UIButton?
    
    let addressBook = APAddressBook()
    var aPContacts = [APContact]() {
        didSet {
            if self.aPContacts.count == 0 {
                return
            }
            
            self.aPContacts.forEach {
                self.contactsAPI.contacts.append(self.updateContact(apContact: $0))
            }
            
        }
    }
    
    var contactsAPI: ContactParamsList = ContactParamsList()
    var isLoadedContact: Bool = false
    
    let currentCategory: LoanCategories? = DataManager.shared.getCurrentCategory()
    
    var dataSource: [LoanSummaryModel] = [
        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
        LoanSummaryModel(name: "Ngày tạo đơn", value: "Date", attributed: nil),
        LoanSummaryModel(name: LoanAmount, value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ", attributed: nil),
        LoanSummaryModel(name: "Kỳ hạn vay", value: "\(DataManager.shared.loanInfo.term) Ngày", attributed: nil),
        LoanSummaryModel(name: "Lãi xuất dự kiến", value: "", attributed: nil),
        LoanSummaryModel(name: "Phí dịch vụ", value: "", attributed: nil),
        LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: "", attributed: nil),
        LoanSummaryModel(name: "Mục đích vay", value: "", attributed: nil),
        LoanSummaryModel(name: "Ngân hàng / Ví", value: "", attributed: nil),
        LoanSummaryModel(name: "Chủ tài khoản", value: "", attributed: nil),
        LoanSummaryModel(name: "Số tài khoản", value: "", attributed: nil),
        
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = [APContactField.default, APContactField.thumbnail]
        addressBook.sortDescriptors = [NSSortDescriptor(key: "name.firstName", ascending: true),
                                       NSSortDescriptor(key: "name.lastName", ascending: true)]
        addressBook.filterBlock =
            {
                (contact: APContact) -> Bool in
                if let phones = contact.phones
                {
                    return phones.count > 0
                }
                return false
        }
        addressBook.startObserveChanges
            {
                [unowned self] in
                self.loadContacts {
                    
                }
        }
    }
    
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
        self.loadContacts {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initLocationManager()
    }
    
    //MARK: Contacts
    /// Load Contact
    
    func loadContacts(completion: @escaping() -> Void)
    {
        
        addressBook.loadContacts
            {
                [unowned self] (contacts: [APContact]?, error: Error?) in
                
                if let contacts = contacts
                {
                    self.aPContacts = contacts
                    self.isLoadedContact = true
                    completion()
                    return
                }
                
                guard error != nil else {
                    return
                }
                
                let message = "Đang không có quyền truy cập danh bạ. Để thực hiện tạo đơn vay, bạn vui lòng vào: Cài đặt -> Mony -> và cho phép danh bạ."
                
                self.showAlertView(title: "Danh bạ", message: message, okTitle: "Huỷ", cancelTitle: "Đồng ý", completion: { (bool) in
                    
                    guard !bool else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    
                })
        }
    }
    
    /// Get Account Name Contact
    ///
    /// - Returns: <#return value description#>
    func updateContact(apContact: APContact) -> ContactParams {
        
        //self.contact.initData()
        var tempContact: ContactParams = ContactParams()
        
        if let phone = apContact.phones {
            if let number = phone.first?.number {
                
                let numberTemp = number.trimmingCharacters(in: CharacterSet.whitespaces)
                
                var numberPhone = numberTemp.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
                if numberPhone.contains("+84") {
                    numberPhone = numberPhone.replacingOccurrences(of: "+84", with: "0")
                }
                
                tempContact.contactPhoneNumber = numberPhone
            }
        }
        
        if let name = apContact.name {
            guard let lastName = name.lastName, let firstName = name.firstName else {
                
                if let lastName = name.lastName {
                    tempContact.contactName = lastName
                }
                
                if let firstName = name.firstName {
                    tempContact.contactName = firstName
                }
                
                return tempContact
            }
            
            tempContact.contactName = (firstName + " " + lastName).trimmingCharacters(in: .whitespacesAndNewlines)
            
            return tempContact
        }
        
        return tempContact
    }
    
    private func uploadContact() {
        APIClient.shared.uploadContacts(list: self.contactsAPI)
            .done(on: DispatchQueue.main) { [weak self] model in
                self?.checkPermisssionCreateLoan()
            }
            .catch { error in
                self.showGreenBtnMessage(title: TITLE_ALERT_ERROR_CONNECTION, message: API_MESSAGE.OTHER_ERROR, okTitle: "Đóng", cancelTitle: nil)
                
        }
        
    }
    
    
    func getPermissionLocation(completion: () -> Void) {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            // For use in foreground
            self.initLocationManager()
            return
        }
        
        if status == .denied || status == .restricted {
            let message = "Để gửi đơn vay, Mony cần biết chính xác vị trí hiện tại của bạn. Vui lòng bật các dịch vụ định vị GPS để hoàn thiện đơn vay."
            
            self.showAlertView(title: "Không tìm thấy địa điểm", message: message, okTitle: "Bật định vị", cancelTitle: nil, completion: { (bool) in
                
                guard bool else {
                    return
                }
                
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                
            })
            
            
            return
        }
        
        self.checkLocationsIsValid {
            completion()
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
            LoanSummaryModel(name: LoanAmount, value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ", attributed: nil),
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
                        let accountNumber = bank.accountBankNumber ?? ""
//                        if let number = bank.accountBankNumber, number.count > 4 {
//                             accountNumber = String(number.suffix(4))
//                        } else {
//                            accountNumber = bank.accountBankNumber ?? ""
//                        }
//                        accountNumber = "● ● ● ● \(accountNumber)"
//                        let subtitleParameters = [NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 12)]
                        let bankName = bank.bankName ?? ""
                        let prefixBankName = FinPlusHelper.getPrefixBankName(bankName: bankName)
                        
                        
                        dataSource.append(LoanSummaryModel(name: "Tài khoản nhận tiền", value: prefixBankName + bankName, attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Chủ tài khoản", value: "\(bank.accountBankName ?? "None")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Số tài khoản", value: accountNumber, attributed: nil))

                    }
                }
            }
        }
        
    }
    
    private func updateDataLoan() {
        DataManager.shared.loanInfo.currentStep = 5
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!

            }
            .catch { error in }
    }
    
    
    /// Set link cho UITextView
    private func setupTextView() {
        
        let policyStr : String = "Tôi đã hiểu và đồng ý với Điều khoản & Điều kiện vay."
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr, attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 15)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
        let myRange = (myMutableString.string as NSString).range(of: "Tôi đã hiểu và đồng ý với ")
        myMutableString.addAttribute(
            NSAttributedStringKey.link,
            value: "more://",
            range: (myMutableString.string as NSString).range(of: "Điều khoản & Điều kiện vay."))
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
            self.showGreenBtnMessage(title: "Điều khoản & Điều kiện vay", message: "Vui lòng đồng ý Điều khoản & Điều kiện vay để gửi đơn vay của bạn.", okTitle: "Đóng", cancelTitle: nil)
            
            return
        }
        
        guard DataManager.shared.loanInfo.status == 0 else {
            self.checkPermisssionCreateLoan()
            return
        }
        //Khi tao loan moi upload
        if self.isLoadedContact {
            //Contact da duoc lay
            self.uploadContact()
        } else {
            //Contact chua duoc lay
            self.loadContacts {
                self.uploadContact()
            }
        }
    
    }
    
    private func checkPermisssionCreateLoan() {
        self.getPermissionLocation {
            
            DataManager.shared.loanInfo.currentStep = 5
            APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
                .done(on: DispatchQueue.main) { model in
                    DataManager.shared.loanID = model.loanId!
                    
                    let messeage = "Mã xác thực sẽ được gửi tới " + DataManager.shared.currentAccount + " qua tin nhắn SMS sau khi bạn đồng ý. Bạn có chắc chắn không?"
                    self.showGreenBtnMessage(title: "Gửi đơn vay", message: messeage, okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ") { (status) in
                        if status {
                            self.loan()
                        }
                    }
                }
                .catch { error in }
            
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
            vc.webViewType = .contractView
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


