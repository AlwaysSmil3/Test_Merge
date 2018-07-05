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
    
    // CoreData
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Lấy data Local
        if let context = self.managedContext {
            FinPlusHelper.fetchCoreData(context: context) {
                
            }
        }
        
        self.getLoanCategories()
        
        
//        //Map DataLoan
//        DataManager.shared.mapDataBrowwerAndLoan()
        
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
        
        guard let loan = DataManager.shared.browwerInfo?.activeLoan else { return }
        
        var serviceFee: Double = 0
        if let config = DataManager.shared.config {
            serviceFee = Double(Int(loan.amount ?? 0) * (config.serviceFee ?? 0 ) / 100)
        }
        var titleCate = "Khoản vay"
        var rate = 0
        if let cate = DataManager.shared.getCurrentCategory() {
            titleCate = cate.title!
            rate = Int(cate.interestRate!)
        }
        
        if let inRate = loan.inRate, inRate > 0 {
            rate = Int(inRate)
        }
        
        let amountString = FinPlusHelper.formatDisplayCurrency(Double((loan.amount ?? 0)!)) + "đ"
        
        let payMounth = FinPlusHelper.CalculateMoneyPayMonth(month: Double(loan.amount ?? 0), term: Double((loan.term ?? 0)/30), rate: Double(rate))
        let payMounthString = FinPlusHelper.formatDisplayCurrency(payMounth) + "đ"
        
        
        var dateString = "2/7/2018"
        if let date_ = loan.createdAt, date_.length() > 0 {
            let date = Date.init(fromString: date_, format: DateFormat.custom("yyyy-MM-dd HH:mm:ssZ"))
            dateString = date.toString(.custom(kDisplayFormat))
            
        } else {
            dateString = Date().toString(.custom(kDisplayFormat))
        }
        
        dataSource = [
            LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
            LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Trạng thái", value: "Chưa hoàn thiện", attributed: NSAttributedString(string: "Chưa hoàn thiện", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#ED8A17")])),
                LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
        
        if (bottom_state == nil)
        {
            switch(STATUS_LOAN(rawValue: id!)) {
            case .DRAFT?:
                
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
                
            case .SALE_REVIEW?, .SALE_PENDING?, .RISK_REVIEW?:
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Chờ phê duyệt", attributed: NSAttributedString(string: "Chờ phê duyệt", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn đang chờ duyệt.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
            case .RISK_PENDING?:
                if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đơn vay của bạn cần được bổ sung thông tin.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Để được duyệt, hãy bổ sung các thông tin sau:\n• Số chứng minh thư.\n• Ảnh chứng minh thư.\n• Bảng lương.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Bổ sung thông tin",
                        "subType": ButtonCellType.FillType,
                        "target": ""
                    ],
                ]
                
            case .INTEREST_CONFIRM?, .INTEREST_CONFIRM_EXPIRED?:
                //Cho xác nhận lãi xuất, quá hạn xác nhận lãi xuất
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đợi xác nhận lãi suất", attributed: NSAttributedString(string: "Đợi xác nhận lãi suất", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Chúc mừng \(self.userInfo.fullName ?? ""), đơn vay của bạn được duyệt với lãi suất \(rate)%/năm.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Hãy ấn 'Xác nhận lãi suất' để bắt đầu huy động tiền từ các nhà đầu tư.",
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
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đơn vay bị từ chối", attributed: NSAttributedString(string: "Đơn vay bị từ chối", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất dự kiến", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
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
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn đã hủy đơn vay này.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
            case .RAISING_CAPITAL?:
                //Đang huy động vốn
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền huy động được", value: "0đ", attributed: NSAttributedString(string: "0đ", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Ngày huy động còn lại", value: "7 Ngày", attributed: NSAttributedString(string: "7 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đang huy động", attributed: NSAttributedString(string: "Đang huy động", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "FinSmart đang huy động cho khoản vay của bạn.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Xin vui lòng chờ, khoản vay của bạn đang được huy động vốn từ các nhà đầu tư.",
                        "subType": TextCellType.DesType,
                        ],
                ]
                
            case .PARTIAL_FILLED?:
                //Huy động được 1 phần
                
                let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Ngày huy động còn lại", value: "5 Ngày", attributed: NSAttributedString(string: "5 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đang huy động", attributed: NSAttributedString(string: "Đang huy động", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn đã huy động được \(funded) trong vòng 1 ngày.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn có thể tiếp tục huy động để có đủ số tiền vay hoặc ấn \"Giải ngân sớm\" để nhận ngay số tiền đã huy động được.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Giải ngân sớm",
                        "subType": ButtonCellType.NullType,
                        "target": "disburse_soon"
                    ],
                ]
                
            case .FILLED?, .CONTRACT_READY? :
                //Đơn vay huy động đủ tiền, chờ ký hợp đồng
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền huy động được", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đã huy động đủ 100%", attributed: NSAttributedString(string: "Đã huy động đủ 100%", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Chúc mừng \(self.userInfo.fullName ?? ""), khoản vay của bạn đã được huy động đủ.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Hãy ấn nút 'Giải ngân' để ký hợp đồng và lấy tiền ngay.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Giải ngân",
                        "subType": ButtonCellType.FillType,
                        "target": "disburse_expried"
                    ],
                ]
                
            case .EXPIRED? :
                //Đơn vay quá hạn huy động
                let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
                
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Ngày huy động còn lại", value: "0 Ngày", attributed: NSAttributedString(string: "0 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : UIColor(hexString: "#DA3535")])),
                    LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Hết thời gian huy động", attributed: NSAttributedString(string: "Hết thời gian huy động", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đã hết thời gian huy động. Số tiền huy động được: \(funded)",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Khoản vay của bạn đã hết thời gian huy động. Bạn có thể giải ngân số tiền huy động được.",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Giải ngân",
                        "subType": ButtonCellType.FillType,
                        "target": "disburse_expried"
                    ],
                ]
                
            case .CONTRACT_SIGNED?:
                // Đã ký hợp đồng
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đang đợi nhận tiền", attributed: NSAttributedString(string: "Đang đợi nhận tiền", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Ký hợp đồng thành công. Bạn sẽ nhận tiền trong thời gian sớm nhất.",
                        "subType": TextCellType.TitleType,
                        ],
                ]
                
                
            case .TIMELY_DEPT?, .DISBURSAL?:
                
                //đã giải ngân
                dataSource = [
                    LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                    LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                    LoanSummaryModel(name: "Số tiền vay", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Số tháng đã thanh toán", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Trạng thái", value: "Đang vay", attributed: NSAttributedString(string: "Đang vay", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                    LoanSummaryModel(name: "Tháng thanh toán tiếp theo", value: "20/08/2018", attributed: nil),
                    LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                    LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                    LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                    LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
                ]
                
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Xin chào \(self.userInfo.fullName ?? ""), bạn đang vay \(amountString).",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn cần thanh toán \(payMounthString) trong tháng này. Hãy thanh toán trước ngày: 20/7/2018.",
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
                        "text": "Lịch sử thanh toán",
                        "subType": ButtonCellType.NullType,
                        "target": "pushToPayHistoryVC"
                    ],
                ]
            case .OVERDUE_DEPT?:
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Khoản vay của bạn đang quá hạn 2 ngày.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Bạn cần thanh toán \(payMounthString) ngay nếu không sẽ chịu phạt theo như hợp đồng.",
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
                        "text": "Lịch sử thanh toán",
                        "subType": ButtonCellType.NullType,
                        "target": "pushToPayHistoryVC"
                    ],
                ]
            case .EXPIRED_NOT_ENOUGH?:
                headerData = [
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Đã hết thời gian huy động nhưng chưa đủ số tiền để giải ngân.",
                        "subType": TextCellType.TitleType,
                        ],
                    [
                        "type": HeaderCellType.TextType,
                        "text": "Khoản vay của bạn đã hết thời gian huy động nhưng không đủ để được giải ngân",
                        "subType": TextCellType.DesType,
                        ],
                    [
                        "type": HeaderCellType.ButtonType,
                        "text": "Tạo đơn vay mới",
                        "subType": ButtonCellType.NullType,
                        "target": ""
                    ],
                ]
                
            default:
                
                break
            }
        }
        
        switch bottom_state {
            
        case .DISBURSEMENT_SOON:
            
            let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Ngày huy động còn lại", value: "5 Ngày", attributed: NSAttributedString(string: "5 Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: "Trả góp hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!]))
            ]
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            
            self.labelBottomView.text = "Không, tiếp tục huy động"
            self.labelBottomView.isUserInteractionEnabled = true
            self.labelBottomView.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
            self.labelBottomView.textAlignment = .center
            self.labelBottomView.textColor = UIColor(hexString: "#4D6678")
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navi_back))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.labelBottomView.addGestureRecognizer(tapGestureRecognizer)
            
            isEnableFooterView = true
            
        case .DISBURSEMENT_ONTIME:
            let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
            
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
            isEnableFooterView = true
            
        case .SIGN_CONTRACT:
            let funded = FinPlusHelper.formatDisplayCurrency(Double(loan.funded ?? 0)) + "đ"
            
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Ngày tạo đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Số tiền huy động được", value: funded, attributed: NSAttributedString(string: funded, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!, NSAttributedStringKey.foregroundColor : MAIN_COLOR])),
                LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: "Mỗi tháng phải trả", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
            
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Nếu bạn đồng ý vay với số tiền huy động được. Vui lòng tiến hành ký hợp đồng để giải ngân."
            isEnableFooterView = true
            
        case .CONFIRM_RATE:
            dataSource = [
                LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount, attributed: nil),
                LoanSummaryModel(name: "Số tiền vay được duyệt", value: amountString, attributed: NSAttributedString(string: amountString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Thời hạn vay", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Thời hạn vay được duyệt", value: "\((loan.term ?? 0)!) Ngày", attributed: NSAttributedString(string: "\((loan.term ?? 0)!) Ngày", attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Lãi suất", value: "\(rate)%/năm", attributed: nil),
                LoanSummaryModel(name: "Phí dịch vụ", value: FinPlusHelper.formatDisplayCurrency(serviceFee) + "đ", attributed: nil),
                LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: payMounthString, attributed: NSAttributedString(string: payMounthString, attributes: [NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)!])),
                LoanSummaryModel(name: "Ngày duyệt đơn", value: dateString, attributed: nil),
                LoanSummaryModel(name: "Loại gói vay", value: titleCate, attributed: nil),
            ]
            
            self.btnBottomView.setTitle("Xác nhận", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmRate), for: .touchUpInside)
            self.labelBottomView.text = "Tiền phí sẽ được trừ ngay sau khi giải ngân tiền vay."
            isEnableFooterView = true
            
        default:
            break
        }
        
        let textCellNib = UINib(nibName: "TitleTableViewCell", bundle: nil)
        self.headerTableView?.register(textCellNib, forCellReuseIdentifier: textIdentifier)
        
        let buttonCellNib = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        self.headerTableView?.register(buttonCellNib, forCellReuseIdentifier: buttonIdentifier)
        
        self.headerTableView?.tableFooterView = UIView()
        self.headerTableView?.estimatedRowHeight = UITableViewAutomaticDimension
        self.headerTableView?.alwaysBounceVertical = false;
        
        let cellNib = UINib(nibName: "DoubleTextTableViewCell", bundle: nil)
        self.dataTableView?.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        if (!isEnableFooterView)
        {
            self.bottomView.isHidden = true
            NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0).isActive = true
        }
        
        self.dataTableView?.tableHeaderView = UIView()
        self.dataTableView?.estimatedRowHeight = UITableViewAutomaticDimension
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
        
        DispatchQueue.main.async() {

            NSLog("headerTableView contentSize: %0.2f", self.headerTableView?.contentSize.height ?? 0)
            NSLog("dataTableView contentSize: %0.2f", self.dataTableView?.contentSize.height ?? 0)
            NSLog("contentSize: %0.2f", self.scrollView?.contentSize.height ?? 0)
            NSLog("height: %0.2f", self.scrollView?.frame.size.height ?? 0)
        }
        
    }
    
    // MARK: Action
    
    @IBAction func navi_back() {
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
            
        case .RISK_PENDING?, .RISK_REVIEW?, .SALE_REVIEW?, .SALE_PENDING?:
            alert.addAction(UIAlertAction(title: "Chỉnh sửa đơn vay", style: .default , handler:{ (UIAlertAction)in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Hủy yêu cầu", style: .destructive , handler:{ (UIAlertAction)in
                self.showGreenBtnMessage(title: "Hủy yêu cầu", message: "Bạn có chắc chắn muốn xóa đơn vay này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
                    if (okAction)
                    {
                        self.delLoan()
                    }
                })
            }))
            
        case .CONTRACT_SIGNED?:
            alert.addAction(UIAlertAction(title: "Xem hợp đồng", style: .default , handler:{ (UIAlertAction)in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
                vc.isSigned = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Hủy đơn vay", style: .destructive , handler:{ (UIAlertAction)in
                
            }))
            
        default:
            break
        }
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // Xác nhận lãi suất
    @IBAction func confirm_rate()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .CONFIRM_RATE
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Giải ngân khi quá hạn huy động vốn
    @IBAction func disburse_expried()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .DISBURSEMENT_ONTIME
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Ký hợp đồng
    @IBAction func signContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .SIGN_CONTRACT
        vc.activeLoan = self.activeLoan
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Xác nhận ký hợp đồng
    @IBAction func confirmSignContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
        vc.activeLoan = self.activeLoan
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushToPayViewController() {
        let payVC = TestBorrowingPayViewController(nibName: "TestBorrowingPayViewController", bundle: nil)
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
    @IBAction func pushToPayHistoryVC() {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(payHistoryVC, animated: true)
    }
    
    // MARK: func
    
    @objc func confirmRate() {
        //Goi api thanh cong xong -> confirm_rate_success
        DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                
                self.confirm_rate_success()
            }
            .catch { error in }
        
    }
    
    // Xóa đơn vay
    func delLoan() {
        
        self.handleLoadingView(isShow: true)
        
        APIClient.shared.delLoan(loanID: (self.activeLoan?.loanId)!)
            .done(on: DispatchQueue.main) { model in
                
                self.handleLoadingView(isShow: false)
                
                self.showGreenBtnMessage(title: "", message: "Đơn vay của bạn đã được xóa. Bạn có thể tạo một đơn mới.", okTitle: "ok", cancelTitle: nil, completion: { (okAction) in
                    self.moveHome()
                    
                    
                })
            }
            .catch { error in
                
                self.handleLoadingView(isShow: false)
                
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
            
            if (item.attributed != nil)
            {
                cell?.desLabel.attributedText = item.attributed!
            }
            
//            switch indexPath.row {
//            case 0:
//                cell?.nameLabel.text = NSLocalizedString("PHONE", comment: "")
//                cell?.desLabel.text = "0986632888"
//            case 1:
//                cell?.nameLabel.text = NSLocalizedString("LOAN_START", comment: "")
//                cell?.desLabel.text = "8/5/2018"
//            case 2:
//                cell?.nameLabel.text = NSLocalizedString("LOAN_MONEY", comment: "")
//                cell?.desLabel.text = "2.000.000đ"
//                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
//            case 3:
//                cell?.nameLabel.text = NSLocalizedString("LOAN_TIME", comment: "")
//                cell?.desLabel.text = "12 tháng"
//                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
//            case 4:
//                cell?.nameLabel.text = NSLocalizedString("STATUS", comment: "")
//                cell?.desLabel.text = getState(type: STATUS_LOAN(rawValue: (activeLoan?.status)!)!)
//                cell?.desLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: (activeLoan?.status)!)!)
//            case 5:
//                cell?.nameLabel.text = NSLocalizedString("RATE", comment: "")
//                cell?.desLabel.text = "10%/năm"
//            case 6:
//                cell?.nameLabel.text = NSLocalizedString("LOAN_FEE", comment: "")
//                cell?.desLabel.text = "200.000đ"
//            case 7:
//                cell?.nameLabel.text = NSLocalizedString("MONEY_MONTH", comment: "")
//                cell?.desLabel.text = "180.000đ"
//                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
//            default:
//                cell?.nameLabel.text = NSLocalizedString("LOAN_DIS", comment: "")
//                cell?.desLabel.text = "Vay mua điện thoại"
//            }
            
            return cell!
        }
    }
    
}
