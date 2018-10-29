//
//  LoanStateViewController.swift
//  FinPlus
//
//  Created by nghiendv on 20/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import CoreData

enum HeaderCellType {
    case TextType
    case ButtonType
}

// Bottom State
enum BOTTOM_STATE: Int {
    case DISBURSEMENT_SOON = 1 // Giải ngân sớm
    case DISBURSEMENT_ONTIME = 2 // Giải ngân đúng hạn
    case SIGN_CONTRACT = 3 // Ký hợp đồng
    case CONFIRM_RATE = 4 // Xác nhận ký hợp đồng
}

class LoanStateViewController: UIViewController {
    
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var headerTableView: UITableView?
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dataTableView: UITableView?
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnBottomView: UIButton!
    @IBOutlet weak var labelBottomView: UILabel!
    
    @IBOutlet weak var dataTableViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var headerTableViewHeightConstraint: NSLayoutConstraint?
    
    
    let cellIdentifier = "cell"
    let textIdentifier = "textCell"
    let buttonIdentifier = "buttonCell"
    
    private var headerData: NSArray = []
    private var arrayKey: NSArray!
    
    var hiddenBack = false
    var dataSource: [LoanSummaryModel] = []
    var activeLoan: BrowwerActiveLoan?
    var bottom_state: BOTTOM_STATE!
    var userInfo: BrowwerInfo!
    
    var isFromManagerLoan: Bool = false
    var isFromManagerLoanLoanName: String?
    
    var paymentInfo: PaymentInfoMoney? {
        didSet {
            guard let pay  = self.paymentInfo else { return }
            
            if let period = pay.paymentPeriod {
                self.payAmountPresent = period.feeOverdue! + period.interest! + period.overdue! + period.principal!
                
            }
            
        }
    }
    //Tra ky nay
    var payAmountPresent: Double = 0
    
    // CoreData
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.managedObjectContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isNeedReload = DataManager.shared.isNeedReloadLoanStatusVC, isNeedReload {
            self.reLoadStatusLoanVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.85)

        
        self.getLoanCategories()
        
        self.handleDataNoti()
        
        let id = activeLoan?.status
        var isEnableFooterView = false
        self.userInfo = DataManager.shared.browwerInfo
        
        if (hiddenBack)
        {
            self.navigationItem.leftBarButtonItem = nil
            
        }
        
        self.btnBottomView.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
        self.btnBottomView.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
        self.btnBottomView.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        self.btnBottomView?.backgroundColor = MAIN_COLOR
        self.btnBottomView?.tintColor = .white
        self.btnBottomView.layer.cornerRadius = 8
        self.btnBottomView.layer.masksToBounds = true
        
        self.labelBottomView.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SMALL)
        
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
        var payMounthTitle = TitleAmountAboveAMounth
        var term = "\((loan.term ?? 0)/30) tháng"
        
        if (loan.loanCategoryId == Loan_Student_Category_ID) && (loan.term ?? 0) <= 30 {
            payMounthTitle = TitleAmountUnderAMounth
            term = "\((loan.term ?? 0)) ngày"
        } else {
            if (loan.term ?? 0) < 30 {
                payMounthTitle = TitleAmountUnderAMounth
                term = "\((loan.term ?? 0)) ngày"
            }
        }
        
        func updateMounthTitle() {
            if payMounthTitle == TitleAmountAboveAMounth {
                payMounthTitle = TitleAmountTempAboveAMounth
            }
            
            if payMounthTitle == TitleAmountUnderAMounth {
                payMounthTitle = TitleAmountTempUnderAMounth
            }
        }
        
        titleCate = loan.loanCategory?.title ?? "Đang cập nhật"
        if titleCate.count == 0 {
            titleCate = "Đang cập nhật"
        }
        
        //Lãi suất
        if let inRate = loan.inRate, inRate > 0 {
            rate = Int(inRate)
        }
        
        let amountString = FinPlusHelper.formatDisplayCurrency(Double((loan.amount ?? 0)!)) + "đ"
        
        //Số tiên thanh toán hàng tháng
        let payMounth = FinPlusHelper.CalculateMoneyPayMonth(month: Double(loan.amount ?? 0), term: Double((loan.term ?? 0)/30), rate: Double(rate))
        var payMounthString = FinPlusHelper.formatDisplayCurrency(payMounth) + "đ"
        
        
        //Ngày tạo đơn
        var dateString = "Đang cập nhật"
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
        
        if let collections = loan.collections, collections.count > 0 {
            var temp: Double = Double(collections[0].interest! + collections[0].principal!)
            if temp == 0 {
                temp = collections[0].repayInterest! + collections[0].repayPrincipal!
            }
            if temp > 0 {
                payMounthStringWithFunded = FinPlusHelper.formatDisplayCurrency(temp) + "đ"
            }
        }
        
        if let expectedAmount = loan.expectedPaymentAmount, expectedAmount > 0 {
            payMounthString = FinPlusHelper.formatDisplayCurrency(expectedAmount) + "đ"
            payMounthStringWithFunded = FinPlusHelper.formatDisplayCurrency(expectedAmount) + "đ"
        }
        
        
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
        
        //Ngày huy động còn lại
        var acceptedDate = "30"
        var acceptedDateTemp = 0
        var limitFunding = "Đang cập nhật"
        
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
            
            let datelimit = Date(fromString: loan.acceptedAt ?? "", format: .iso8601(ISO8601Format.DateTimeSec)).dateByAddingHours(rasingCapital)
            limitFunding = datelimit.toString(.custom("dd/MM/yyyy HH:mm"))
        }
        
        //Ngày duyệt đơn
        func updateApprovedAtDate() {
            if let date_ = loan.approvedAt, date_.length() > 0 {
                let date = Date.init(fromString: date_, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
                dateString = date.toString(.custom(kDisplayFormat))
            }
        }
        
        //Ngày giải ngân
        func updateDisbursementDate() {
            if let date_ = loan.disbursementDate, date_.length() > 0 {
                let date = Date.init(fromString: date_, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
                dateString = date.toString(.custom(kDisplayFormat))
            }
        }
        
        
        dataSource = [
            LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
            LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Trạng thái", value: "Chưa hoàn thiện", attributed: NSAttributedString(string: "Chưa hoàn thiện", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#ED8A17")])),
                LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
        
        if (bottom_state == nil)
        {
            switch(STATUS_LOAN(rawValue: id!)) {
            case .DRAFT?:
                //Trang thai Draft = 0
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Chưa hoàn thiện", attributed: NSAttributedString(string: "Chưa hoàn thiện", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#ED8A17")])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn chưa được hoàn thiện.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Hoàn thiện đơn",
                        "subType": ButtonCellType.NullType,
                        "target": "update_loan"
                    ],
                ]
                
            case .SALE_REVIEW?:
                //Kinh doanh duyệt = 1
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Chờ phê duyệt", attributed: NSAttributedString(string: "Chờ phê duyệt", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn đang chờ duyệt.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
                
            case .RISK_REVIEW?:
                // Thẩm định viên duyệt = 3
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Chờ phê duyệt", attributed: NSAttributedString(string: "Chờ phê duyệt", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn đang chờ duyệt.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
            case .SALE_PENDING?:
                //Can bo sung thong tin, Sale review = 2
                if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Cần bổ sung thông tin", attributed: NSAttributedString(string: "Cần bổ sung thông tin", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#ED8A17")])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ dự kiến", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn cần được bổ sung thông tin.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": self.formatTitleMissingKey(),
                        "subType": TextCellType.DesType,
                        
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Bổ sung thông tin",
                        "subType": ButtonCellType.FillType,
                        "target": "update_loan_MissData"
                    ],
                ]
                
                
                
            case .RISK_PENDING?:
                //Cần bổ sung thông tin, risk pending = 4
                if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Cần bổ sung thông tin", attributed: NSAttributedString(string: "Cần bổ sung thông tin", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#ED8A17")])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ dự kiến", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn cần được bổ sung thông tin.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": self.formatTitleMissingKey(),
                        "subType": TextCellType.DesType,
                        
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Bổ sung thông tin",
                        "subType": ButtonCellType.FillType,
                        "target": "update_loan_MissData"
                    ],
                ]
                
            case .INTEREST_CONFIRM?, .INTEREST_CONFIRM_EXPIRED?:
                //Cho xác nhận lãi xuất, qúa hạn xác nhận lãi xuất, 6 - 7
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    //LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    //LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đợi xác nhận lãi suất", attributed: NSAttributedString(string: "Đợi xác nhận lãi suất", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Chúc mừng \(self.userInfo.fullName ?? ""), đơn vay của bạn được duyệt với lãi suất \(rate)%/năm.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Hãy ấn 'xác nhận lãi suất' để vay tiền từ bên cho vay trên ứng dụng mony.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Xác nhận lãi suất",
                        "subType": ButtonCellType.FillType,
                        "target": "confirm_rate"
                    ],
                ]
                
            case .REJECTED?:
                //Bị từ chối - 5
                DataManager.shared.reloadDataFirstLoanVC()
                updateMounthTitle()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đơn vay bị từ chối", attributed: NSAttributedString(string: "Đơn vay bị từ chối", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Rất tiếc, yêu cầu vay của bạn đã bị từ chối.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Yêu cầu vay của bạn đã bị từ chối. Vui lòng tạo một đơn vay mới và thứ lại!",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Tạo đơn vay mới",
                        "subType": ButtonCellType.NullType,
                        "target": "navi_back"
                    ],
                ]
                
            case .CANCELED?:
                //Đã huỷ đơn vay , 17
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBase, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đã huỷ", attributed: NSAttributedString(string: "Đã huỷ", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn đã hủy đơn vay này.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
            case .RAISING_CAPITAL?:
                //Đang huy động vốn - 8
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBeforeSigned, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Thời gian chuẩn bị tiền", value: limitFunding, attributed: nil),
                    LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: MobilizingStatus, attributed: NSAttributedString(string: MobilizingStatus, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Tiền đang được chuẩn bị dành cho đơn vay của bạn.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Xin vui lòng chờ!",
                        "subType": TextCellType.DesType,
                        ],
                ]
                
            case .PARTIAL_FILLED?:
                //Huy động được 1 phần - 9
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBeforeSigned, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: LoanMobiExpDay, value: "\(acceptedDate) Ngày", attributed: NSAttributedString(string: "\(acceptedDate) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: MobilizingStatus, attributed: NSAttributedString(string: MobilizingStatus, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Tiền đang được chuẩn bị dành cho đơn vay của bạn.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Xin vui lòng chờ!",
                        "subType": TextCellType.DesType,
                        ],
                ]
                
//                headerData = [
//                    [
//                        "type": HeaderCellType.TextType,
//                        "text": "Bạn đã huy động được \(funded) trong vòng 1 ngày.",
//                        "subType": TextCellType.TitleType,
//                        ],
//                    [
//                        "type": HeaderCellType.TextType,
//                        "text": "Bạn có thể tiếp tục huy động để có đủ số tiền vay hoặc ấn \"Giải ngân sớm\" để nhận ngay số tiền đã huy động được.",
//                        "subType": TextCellType.DesType,
//                        ],
//                    [
//                        "type": HeaderCellType.ButtonType,
//                        "text": "Giải ngân sớm",
//                        "subType": ButtonCellType.NullType,
//                        "target": "disburse_soon"
//                    ],
//                ]
                
            case .FILLED?:
                //Đơn vay huy động đủ tiền, chờ ký hợp đồng - 10
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBeforeSigned, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Chờ giải ngân", attributed: NSAttributedString(string: "Chờ giải ngân", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Chúc mừng \(self.userInfo.fullName ?? "")!",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Hãy nhấn vào nút giải ngân để hoàn tất thủ tục ký hợp đồng và đồng thời xác nhận bạn yêu cầu nhận nợ.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Giải ngân",
                        "subType": ButtonCellType.FillType,
                        "target": "disburse_expried"
                    ],
                ]
                
            case .CONTRACT_READY? :
                //Số tiền huy động > 50% và hết thời gian huy động - 11
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBeforeSigned, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: LoanMobiExpDay, value: "0 Ngày", attributed: NSAttributedString(string: "0 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Hết thời gian huy động", attributed: NSAttributedString(string: "Hết thời gian huy động", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Thời gian chuẩn bị tiền cho khoản vay của bạn đã hoàn tất. Tổng số tiền sẽ giải ngân cho đơn vay của bạn là:\(funded)",
                        "subType": TextCellType.TitleType,
                        ],
//                    [
//                        "type": HeaderCellType.TextType,
//                        "text": "Khoản vay của bạn đã hết thời gian huy động. Bạn có thể giải ngân số tiền huy động được.",
//                        "subType": TextCellType.DesType,
//                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Giải ngân",
                        "subType": ButtonCellType.FillType,
                        "target": "disburse_expried"
                    ],
                ]
                
            case .EXPIRED? :
                //Đơn vay quá hạn huy động - 12
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmountBeforeSigned, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                    LoanSummaryModel(name: LoanMobiExpDay, value: "0 Ngày", attributed: NSAttributedString(string: "0 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                    LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Hết thời gian huy động", attributed: NSAttributedString(string: "Hết thời gian huy động", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đã hết thời gian huy động nhưng chưa đủ số tiền để giải ngân.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Khoản vay của bạn đã hết thời gian huy động nhưng không đủ để được giải ngân.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Tạo đơn vay mới",
                        "subType": ButtonCellType.NullType,
                        "target": "create_New_Loan"
                    ],
                ]
                
            case .CONTRACT_SIGNED?:
                // Đã ký hợp đồng - 13
                updateMounthTitle()
                updateApprovedAtDate()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đang đợi nhận tiền", attributed: NSAttributedString(string: "Đang đợi nhận tiền", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                //self.navigationItem.rightBarButtonItem = nil
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Ký hợp đồng thành công. Bạn sẽ nhận tiền trong thời gian sớm nhất.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
            case .DISBURSAL?:
                //đã giải ngân - 14
                updateDisbursementDate()
                
                func reloadDisbusal() {
                    dataSource = [
                        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                        LoanSummaryModel(name: "Ngày vay", value: dateString, attributed: nil),
                        LoanSummaryModel(name: "Số giải ngân theo hợp đồng", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                        LoanSummaryModel(name: "Số tháng đã thanh toán", value: paidMonth, attributed: NSAttributedString(string: paidMonth, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Trạng thái", value: "Đang vay", attributed: NSAttributedString(string: "Đang vay", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                        LoanSummaryModel(name: "Ngày thanh toán tiếp theo", value: nextPaymentDate, attributed: nil),
                        LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                        LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                        LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                    ]
                    
                    //self.navigationItem.rightBarButtonItem = nil
                    
                    headerData = [
                        [
                            "type": HeaderCellType.TextType,
                            "text": "Xin chào \(self.userInfo.fullName ?? ""). Dư nợ hiện tại của bạn la \(funded).",
                            "subType": TextCellType.TitleType,
                            ],
                        [
                            "type": HeaderCellType.TextType,
                            "text": "Bạn cần thanh toán \(FinPlusHelper.formatDisplayCurrency(self.payAmountPresent) + "đ") trong tháng này. Hãy thanh toán trước ngày: \(nextPaymentDate).",
                            "subType": TextCellType.DesType,
                            ],
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Thanh toán",
                            "subType": ButtonCellType.FillType,
                            "target": "pushToPayViewController"
                        ],
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Lịch trả nợ",
                            "subType": ButtonCellType.NullType,
                            "target": "pushToPayHistoryVC"
                        ],
                    ]
                    
                }
                
                reloadDisbusal()
                
                self.getPaymentInfo {
                    reloadDisbusal()
                    self.addBankTotDataSource()
                    
                    self.headerTableView?.reloadData()
                    self.dataTableView?.reloadData()
                    
                }
                
                
                break
                
            case .TIMELY_DEPT?:
                //Nợ đúng hạn - 16
                updateDisbursementDate()
                
                func reloadTimelyDept() {
                    self.dataSource = [
                        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                        LoanSummaryModel(name: "Ngày vay", value: dateString, attributed: nil),
                        LoanSummaryModel(name: "Số giải ngân theo hợp đồng", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                        LoanSummaryModel(name: "Số tháng đã thanh toán", value: paidMonth, attributed: NSAttributedString(string: paidMonth, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Trạng thái", value: "Đang vay", attributed: NSAttributedString(string: "Đang vay", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                        LoanSummaryModel(name: "Ngày thanh toán tiếp theo", value: nextPaymentDate, attributed: nil),
                        LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                        LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                        LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                    ]
                    
                    //self.navigationItem.rightBarButtonItem = nil
                    
                    var array: [String: Any] = [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn cần thanh toán \(FinPlusHelper.formatDisplayCurrency(self.payAmountPresent) + "đ") trong tháng này. Hãy thanh toán trước ngày: \(nextPaymentDate).",
                        "subType": TextCellType.DesType,
                        ]
                    
                    let temp = self.getAmountDebt()
                    let temptString = FinPlusHelper.formatDisplayCurrency(temp) + "đ"
                    
                    var currentAmount = funded
                    
                    if let date = self.checkCollectionRightPayForStatusTimelyDebt() {
                        array = [
                            "type": HeaderCellType.TextType,
                            "text": "Bạn đã thanh toán cho kỳ thanh toán ngày \(date). Xin cảm ơn.",
                            "subType": TextCellType.DesType,
                        ]
                        
                        currentAmount = temptString
                    }
                    
                    
                    self.headerData = [
                        [
                            "type": HeaderCellType.TextType,
                            "text": "Xin chào \(self.userInfo.fullName ?? ""). Dư nợ hiện tại của bạn là \(currentAmount).",
                            "subType": TextCellType.TitleType,
                            ],
                        array,
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Thanh toán",
                            "subType": ButtonCellType.FillType,
                            "target": "pushToPayViewController"
                        ],
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Lịch trả nợ",
                            "subType": ButtonCellType.NullType,
                            "target": "pushToPayHistoryVC"
                        ],
                    ]
                }
                
                reloadTimelyDept()
                
                self.getPaymentInfo {
                    
                    reloadTimelyDept()
                    self.addBankTotDataSource()
                    
                    self.headerTableView?.reloadData()
                    self.dataTableView?.reloadData()
                    
                }
                
                
            case .OVERDUE_DEPT?:
                //Nợ quá hạn - 15
                updateDisbursementDate()
                
                func reloadOverdueDept() {
                    var overDate = "0"
                    if let overdudeDate = self.getDateOverdude() {
                        let calendar = NSCalendar.current
                        let d1 = Date()
                        let date1 = calendar.startOfDay(for: d1)
                        //                    let d2 = Date(fromString: nextDateStr, format: .iso8601(ISO8601Format.DateTimeSec))
                        let date2 = calendar.startOfDay(for: overdudeDate)
                        
                        if d1 > overdudeDate {
                            let components = calendar.dateComponents([.day], from: date2, to: date1)
                            overDate = "\(components.day!)"
                        }
                        
                    }
                    
                    
                    dataSource = [
                        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                        LoanSummaryModel(name: "Ngày vay", value: dateString, attributed: nil),
                        LoanSummaryModel(name: LoanAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                        LoanSummaryModel(name: "Số tháng đã thanh toán", value: paidMonth, attributed: NSAttributedString(string: paidMonth, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Trạng thái", value: "Nợ quá hạn", attributed: NSAttributedString(string: "Nợ quá hạn", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : NAGATIVE5_COLOR])),
                        LoanSummaryModel(name: "Ngày thanh toán tiếp theo", value: nextPaymentDate, attributed: nil),
                        LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                        LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                        LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                        LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                    ]
                    
                    
                    //let amountOvertime = FinPlusHelper.formatDisplayCurrency(self.getAmountDebtOvertime()) + "đ"
                    let amountOvertime = FinPlusHelper.formatDisplayCurrency(self.payAmountPresent) + "đ"
                    
                    headerData = [
                        [
                            "type": HeaderCellType.TextType,
                            "text": "Khoản vay của bạn đang quá hạn \(overDate) ngày.",
                            "subType": TextCellType.TitleType,
                            ],
                        [
                            "type": HeaderCellType.TextType,
                            "text": "Bạn cần thanh toán \(amountOvertime) ngay nếu không sẽ chịu phạt theo như hợp đồng.",
                            "attributed": NSAttributedString(string: "chịu phạt theo như hợp đồng", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]),
                            "subType": TextCellType.DesType,
                            ],
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Thanh toán",
                            "subType": ButtonCellType.FillType,
                            "target": "pushToPayViewController"
                        ],
                        [
                            "type": HeaderCellType.ButtonType,
                            "text": "Lịch trả nợ",
                            "subType": ButtonCellType.NullType,
                            "target": "pushToPayHistoryVC"
                        ],
                    ]
                }
                
                reloadOverdueDept()
                
                self.getPaymentInfo {
                    reloadOverdueDept()
                    self.addBankTotDataSource()
                    
                    self.headerTableView?.reloadData()
                    self.dataTableView?.reloadData()
                }
                
                
                break
            case .SETTLED?:
                //Khoản vay thanh toán thành công - 18
                
                //DataManager.shared.reloadDataFirstLoanVC()
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đã tất toán", attributed: NSAttributedString(string: "Đã tất toán", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                /*
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Khoản vay hiện tại đã được thanh toán toàn bộ.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn có thể nhấn 'Tạo đơn vay mới' để tạo khoản vay tiếp theo với mức lãi suất ưu đãi.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Tạo đơn vay mới",
                        "subType": ButtonCellType.NullType,
                        "target": "create_New_Loan"
                    ],
                ]
                */
                
                break
 
                
            default:
                
                break
            }
        }
        
        switch bottom_state {
            
        case .DISBURSEMENT_SOON?:
            //Giai ngan som
            let fullName = loan.userInfo?.fullName ?? ""
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: LoanMobiExpDay, value: "\(acceptedDate) Ngày", attributed: NSAttributedString(string: "\(acceptedDate) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            
            self.labelBottomView.text = "Không, tiếp tục huy chờ"
            self.labelBottomView.isUserInteractionEnabled = true
            self.labelBottomView.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
            self.labelBottomView.textAlignment = .center
            self.labelBottomView.textColor = UIColor(hexString: "#4D6678")
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navi_back))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.labelBottomView.addGestureRecognizer(tapGestureRecognizer)
            
            isEnableFooterView = true
            
        case .DISBURSEMENT_ONTIME?:
            //Giai ngan dung han
            //let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            let fullName = loan.userInfo?.fullName ?? ""
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.navigationItem.rightBarButtonItem = nil
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
            isEnableFooterView = true
            
        case .SIGN_CONTRACT?:
            //Ky hop dong
            //let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            let fullName = loan.userInfo?.fullName ?? ""
            
            self.navigationItem.rightBarButtonItem = nil
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Họ và tên", value: fullName, attributed: nil),
                LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: MobilizedAmount, value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFeeFunded) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthStringWithFunded, attributed: NSAttributedString(string: payMounthStringWithFunded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
//            self.labelBottomView.text = "Nếu bạn đồng ý vay với số tiền huy động được. Vui lòng tiến hành ký hợp đồng để giải ngân."
            self.labelBottomView.text = ""
            isEnableFooterView = true
            
        case .CONFIRM_RATE?:
            //Xac nhan lai suat
            self.navigationItem.rightBarButtonItem = nil
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: LoanAmount, value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Kỳ hạn vay", value: term, attributed: NSAttributedString(string: term, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Kỳ hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: payMounthTitle, value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
            
            self.btnBottomView.setTitle("Xác nhận", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmRate), for: .touchUpInside)
            self.labelBottomView.text = "Tiền phí sẽ được trừ ngay sau khi giải ngân tiền vay."
            isEnableFooterView = true
            break
            
        default:
            break
        }
        
        self.addBankTotDataSource()
        
        if self.isFromManagerLoan {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.navigationItem.rightBarButtonItem = nil
            self.headerData = []
        } else {
            self.initRefresher()
        }
        
        let textCellNib = UINib(nibName: "TitleTableViewCell", bundle: nil)
        self.headerTableView?.register(textCellNib, forCellReuseIdentifier: textIdentifier)
        
        let buttonCellNib = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        self.headerTableView?.register(buttonCellNib, forCellReuseIdentifier: buttonIdentifier)
        
        self.headerTableView?.tableFooterView = UIView()
        self.headerTableView?.estimatedRowHeight = 123
        self.headerTableView?.rowHeight = UITableViewAutomaticDimension
        self.headerTableView?.alwaysBounceVertical = false;
        
        let cellNib = UINib(nibName: "DoubleTextTableViewCell", bundle: nil)
        self.dataTableView?.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        if (!isEnableFooterView)
        {
            self.bottomView.isHidden = true
            NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0).isActive = true
        }
        
        self.dataTableView?.tableHeaderView = UIView()
        self.dataTableView?.estimatedRowHeight = 123
        self.dataTableView?.rowHeight = UITableViewAutomaticDimension
        self.dataTableView?.alwaysBounceVertical = false;
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.cornerRadius = 8
        self.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "ic_logo"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.dataTableViewHeightConstraint?.constant = (self.dataTableView?.contentSize.height)!
        self.headerTableViewHeightConstraint?.constant = (self.headerTableView?.contentSize.height)!
    
    }
    
    private func initRefresher() {
        self.refresher = UIRefreshControl()
        self.scrollView?.addSubview(self.refresher)
        
        //self.refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        //self.refresher.tintColor = MAIN_COLOR
        self.refresher.addTarget(self, action: #selector(completeRefresh), for: .valueChanged)
    }
    
    @objc func completeRefresh() {
        //self.reloadData()
        self.refreshData()
    }
    
    private func refreshData() {
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.refresher.endRefreshing()
                
                if let status = model.activeLoan?.status, status == STATUS_LOAN.SALE_PENDING.rawValue || status == STATUS_LOAN.RISK_PENDING.rawValue {
                    DataManager.shared.isNeedReloadLoanStatusVC = false
                    
                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                    if let window = UIApplication.shared.delegate?.window, let win = window {
                        win.rootViewController = tabbarVC
                    }
                    
                    return
                }
                
                if let status = model.activeLoan?.status, status == STATUS_LOAN.OVERDUE_DEPT.rawValue || status == STATUS_LOAN.TIMELY_DEPT.rawValue || status == STATUS_LOAN.SALE_REVIEW.rawValue || status == STATUS_LOAN.RISK_REVIEW.rawValue {
                    DataManager.shared.isNeedReloadLoanStatusVC = false
                    DataManager.shared.browwerInfo = model
                    
                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                    if let window = UIApplication.shared.delegate?.window, let win = window {
                        win.rootViewController = tabbarVC
                    }
                    
                    return
                }
                
//                if let status = model.activeLoan?.status, let currentStatus = DataManager.shared.browwerInfo?.activeLoan?.status, status == currentStatus { return }
                
                DataManager.shared.isNeedReloadLoanStatusVC = false
                DataManager.shared.browwerInfo = model
                
                let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                if let window = UIApplication.shared.delegate?.window, let win = window {
                    win.rootViewController = tabbarVC
                }
                
            }
            .catch { error in
                self.refresher.endRefreshing()
                
        }
    }
    
    private func formatTitleMissingKey() -> String {
        var value = "Để được duyệt, hãy bổ sung các thông tin sau:"
        guard let listTitle = DataManager.shared.listKeyMissingLoanTitle else { return value }
        var index = 0
        for i in listTitle {
            //Để được duyệt, hãy bổ sung các thông tin sau:\n• Số chứng minh thư.\n• Ảnh chứng minh thư.\n• Bảng lương.
            if index == listTitle.count - 1 {
                value.append("\n\(i)")
            } else {
                value.append("\n• \(i)")
            }
            
            index += 1
        }
        
        return value
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
    
    // MARK: Action
    
    @IBAction func create_New_Loan() {
        DataManager.shared.loanInfo.status = STATUS_LOAN.CANCELED.rawValue
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                self?.moveHome()
                
                
            }
            .catch { error in }
        
        
    }
    
    @IBAction func navi_back() {
        DataManager.shared.isBackFromLoanStatusVC = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_option() {
        
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
        switch (STATUS_LOAN(rawValue: (activeLoan?.status!)!)) {
        case .DRAFT?:
            alert.addAction(UIAlertAction(title: "Xóa đơn vay", style: .destructive , handler:{ (UIAlertAction)in
                self.showGreenBtnMessage(title: "Xóa đơn vay", message: "Bạn có chắc chắn muốn xóa đơn vay chưa hoàn thiện này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
                    if (okAction)
                    {
                        self.delLoan()
                    }
                })
            }))
            
        case .SALE_REVIEW?:
            alert.addAction(UIAlertAction(title: "Chỉnh sửa đơn vay", style: .default , handler:{ (UIAlertAction)in
                self.update_loan()
            }))
            
            alert.addAction(UIAlertAction(title: "Hủy yêu cầu", style: .destructive , handler:{ (UIAlertAction)in
                self.showGreenBtnMessage(title: "Hủy yêu cầu", message: "Bạn có chắc chắn muốn xóa đơn vay này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
                    if (okAction)
                    {
                        self.delLoan()
                    }
                })
            }))
            
            
        case .RISK_PENDING?, .SALE_PENDING?:
            
            alert.addAction(UIAlertAction(title: "Hủy yêu cầu", style: .destructive , handler:{ (UIAlertAction)in
                self.showGreenBtnMessage(title: "Hủy yêu cầu", message: "Bạn có chắc chắn muốn xóa đơn vay này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
                    if (okAction)
                    {
                        self.delLoan()
                    }
                })
            }))
            
//        case .RISK_REVIEW?:
//            alert.addAction(UIAlertAction(title: "Hủy yêu cầu", style: .destructive , handler:{ (UIAlertAction)in
//                self.showGreenBtnMessage(title: "Hủy yêu cầu", message: "Bạn có chắc chắn muốn xóa đơn vay này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
//                    if (okAction)
//                    {
//                        self.delLoan()
//                    }
//                })
//            }))
            
        case .CONTRACT_SIGNED?, .DISBURSAL?, .OVERDUE_DEPT?, .TIMELY_DEPT?:
            alert.addAction(UIAlertAction(title: "Xem hợp đồng", style: .default , handler:{ (UIAlertAction)in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
                vc.isSigned = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
//            alert.addAction(UIAlertAction(title: "Hủy đơn vay", style: .destructive , handler:{ (UIAlertAction)in
//
//            }))
            
        default:
            break
        }
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: 20, y: 20, width: 64, height: 64)
        }
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    /// Get số tiền đã thanh toán được
    ///
    /// - Returns: <#return value description#>
    func getAmountPaided() -> Double {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return 0 }
        var amount: Double = 0
        for col in collections {
            if let status = col.status, status == 2 {
                let temp = col.repayFeeOverdue! + col.repayInterest! + col.repayOverdue! + col.repayPrincipal!
                amount += temp
            }
        }
        
        return amount
    }
    
    
    /// Get Số tiền nợ
    ///
    /// - Returns: <#return value description#>
    func getAmountDebt() -> Double {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return 0 }
        var amount: Double = 0
        for col in collections {
            let temp = col.repayPrincipal!
            amount += temp
            
        }
        
        let value: Double = Double(activeLoan.amount ?? 0) - amount

        
        return value
    }
    
    
    /// Get số tiền khi nợ quá hạn
    ///
    /// - Returns: <#return value description#>
    func getAmountDebtOvertime() -> Double {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return 0 }
        var amount: Double = 0
        for col in collections {
            if col.status == 3 {
                let temp = Double(col.principal! + col.feeOverdue! + col.overdue! + col.interest!)
                amount += temp
            }
            
        }
        
        return amount
    }
    
    //Lấy ngày quá hạn
    func getDateOverdude() -> Date? {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return nil }
        
        for col in collections {
            if let status = col.status, status == 3 {
                if let monthPayed = col.dueDatetime {
                    let date = Date(fromString: monthPayed, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
                    return date
                }
            }
        }
        
        return nil
    }
    
    
    //Check đã thanh toán kỳ nào chưa
    func checkCollectionRightPayForStatusTimelyDebt() -> String? {
        
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return nil }
        
        let monthCurrent = Date().month()
        
        for col in collections {
            if let status = col.status, status == 2 {
                if let monthPayed = col.dueDatetime {
                    let date = Date(fromString: monthPayed, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
                    let month = date.month()
                    
                    if monthCurrent + 1 == month || monthCurrent == month {
                        //value = true
                        let days = date.days(from: Date())
                        if days > 0 && days <= 31 {
                            return date.toString(.custom(kDisplayFormat))
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    // Xác nhận lãi suất
    @IBAction func confirm_rate()
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoanSummaryViewController") as! LoanSummaryViewController

        vc.bottom_state = .CONFIRM_RATE
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func confirm_rate_success()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONFIRM_RATE_SUCCESS")
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // Giải ngân sớm
    @IBAction func disburse_soon()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .DISBURSEMENT_SOON
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Giải ngân khi quá hạn huy động vốn
    @IBAction func disburse_expried()
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoanSummaryViewController") as! LoanSummaryViewController
        vc.bottom_state = .DISBURSEMENT_ONTIME
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Ký hợp đồng
    @IBAction func signContract()
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoanSummaryViewController") as! LoanSummaryViewController
        
        vc.bottom_state = .SIGN_CONTRACT
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Xác nhận ký hợp đồng
    @IBAction func confirmSignContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
        vc.activeLoan = self.activeLoan
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushToPayViewController() {
        let payVC = TestBorrowingPayViewController(nibName: "TestBorrowingPayViewController", bundle: nil)
        payVC.paymentInfo = self.paymentInfo
        payVC.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
    @IBAction func pushToPayHistoryVC() {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        payHistoryVC.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(payHistoryVC, animated: true)
    }
    
    // MARK: func
    
    @objc func confirmRate() {
        //Goi api thanh cong xong -> confirm_rate_success
        DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { [weak self]model in
                DataManager.shared.loanID = model.loanId!
                
                self?.confirm_rate_success()
            }
            .catch { error in }
        
    }
    
    // Xóa đơn vay
    func delLoan() {
        
        APIClient.shared.delLoan(loanID: (self.activeLoan?.loanId)!)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                guard let code = model.returnCode, code > 0 else {
                    self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "Đồng ý", cancelTitle: nil, completion: { (okAction) in
                        
                        DataManager.shared.loanInfo.amount = 0
                        DataManager.shared.loanInfo.term = 0
                        
                        self?.moveHome()
                    })
                    
                    return
                }
                
                self?.showGreenBtnMessage(title: "", message: "Đơn vay của bạn đã được xóa. Bạn có thể tạo một đơn mới.", okTitle: "Đồng ý", cancelTitle: nil, completion: { (okAction) in
                    
                    DataManager.shared.loanInfo.amount = 0
                    DataManager.shared.loanInfo.term = 0
                    
                    self?.moveHome()
                    
                    
                })
            }
            .catch { error in
                
                
                self.showGreenBtnMessage(title: "Có lỗi", message: "Đã có lỗi trong quá trình xóa đơn vay. Vui lòng thử lại.", okTitle: "Thử lại", cancelTitle: "Hủy", completion: { (okAction) in
                    if (okAction)
                    {
                        self.delLoan()
                    }
                })
        }
    }
    
    private func moveHome() {
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.browwerInfo = model
                
                let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                if let window = UIApplication.shared.delegate?.window, let win = window {
                    win.rootViewController = tabbarVC
                }
                
            }
            .catch { error in
                
        }
    }
    
    
}

extension LoanStateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == headerTableView {
            return headerData.count
        }
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension LoanStateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == headerTableView {
            
            let item = headerData[indexPath.row] as! NSDictionary
            let type = item["type"] as! HeaderCellType
            
            if (type == .TextType)
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier) as? TitleTableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: textIdentifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: textIdentifier) as? TitleTableViewCell
                }
                
                let desText = item["text"] as? String
                
                cell?.setTextCellType(type: item["subType"] as! TextCellType)
                cell?.label.text = desText
                
                if let attributed = item["attributed"] as? NSAttributedString
                {
                    let oldAttributed = NSMutableAttributedString(attributedString: (cell?.label.attributedText)!)
                    
                    if let range = desText?.range(of: attributed.string)  {
                        oldAttributed.addAttributes(attributed.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, attributed.length)), range: NSRange(range, in: desText!))
                    }
                    
                    cell?.label.attributedText = oldAttributed
                }
                
                return cell!
            }
            else
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: buttonIdentifier) as? ButtonTableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: buttonIdentifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: buttonIdentifier) as? ButtonTableViewCell
                }
                
                cell?.setButtonCellType(type: item["subType"] as! ButtonCellType)
                cell?.button.setTitle(item["text"] as? String, for: .normal)
                
                let target = item["target"] as? String
                if ((target?.count)! > 0)
                {
                    cell?.button.addTarget(self, action: Selector(target!), for: .touchUpInside)
                }
                
                return cell!
            }
        }
        else
        {
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
            
            
            return cell!
        }
    }
    
}
