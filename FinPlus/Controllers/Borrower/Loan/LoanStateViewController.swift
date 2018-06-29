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
        
        //        //Lấy data Local
        if let context = self.managedContext {
            FinPlusHelper.fetchCoreData(context: context) {
                
            }
        }
        
        let id = activeLoan?.status
        var isEnableFooterView = false
        self.userInfo = DataManager.shared.browwerInfo
        
        if (hiddenBack)
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        self.btnBottomView.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
        self.btnBottomView.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
        self.btnBottomView.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        self.btnBottomView?.backgroundColor = MAIN_COLOR
        self.btnBottomView?.tintColor = .white
        self.btnBottomView.layer.cornerRadius = 8
        self.btnBottomView.layer.masksToBounds = true
        
        self.labelBottomView.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SMALL)
        
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
            
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Chúc mừng \(String(describing: self.userInfo.fullName)), đơn vay của bạn được duyệt với lãi suất 10%/năm.",
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
            
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Bạn đã huy động được 1.500.000đ trong vòng 2 ngày.",
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
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Chúc mừng \(String(describing: self.userInfo.fullName)), khoản vay của bạn đã được huy động đủ.",
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
                    "target": "disburse_expỉed"
                ],
            ]
            
        case .EXPIRED? :
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Đã hết thời gian huy động. Số tiền huy động được: 1.500.000đ",
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
                    "target": "disburse_expỉed"
                ],
            ]
            
        case .CONTRACT_SIGNED?, .DISBURSAL?:
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Ký hợp đồng thành công. Bạn sẽ nhận tiền trong thời gian sớm nhất.",
                    "subType": TextCellType.TitleType,
                    ],
            ]
        case .TIMELY_DEPT?:
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Xin chào \(String(describing: self.userInfo.fullName)), bạn đang vay 2.000.000đ.",
                    "subType": TextCellType.TitleType,
                ],
                [
                    "type": HeaderCellType.TextType,
                    "text": "Bạn cần thanh toán 125.000đ trong tháng này. Hãy thanh toán trước ngày: 20/6/2018.",
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
                    "text": "Bạn cần thanh toán 125.000đ ngay nếu không sẽ chịu phạt theo như hợp đồng.",
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
        
        switch bottom_state {
            
        case .DISBURSEMENT_SOON:
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
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
            isEnableFooterView = true
            
        case .SIGN_CONTRACT:
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Nếu bạn đồng ý vay với số tiền huy động được. Vui lòng tiến hành ký hợp đồng để giải ngân."
            isEnableFooterView = true
            
        case .CONFIRM_RATE:
            self.btnBottomView.setTitle("Xác nhận", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirm_rate_success), for: .touchUpInside)
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
        self.headerTableView?.estimatedRowHeight = 44
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
        self.dataTableView?.estimatedRowHeight = 44
        self.dataTableView?.rowHeight = UITableViewAutomaticDimension
        self.dataTableView?.alwaysBounceVertical = false;
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.cornerRadius = 8
        self.borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "ic_logo"))
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (headerData.count > 0)
        {
//            UIView.animate(withDuration: 0, animations: {
//                self.headerTableView?.layoutIfNeeded()
//            }) { (complete) in
//                // Edit heightOfTableViewConstraint's constant to update height of table view
//                self.headerTableViewHeightConstraint?.constant = (self.headerTableView?.visibleCells[0].frame.height)!*CGFloat(self.headerData.count)
//            }
        }
        else
        {
            self.headerTableViewHeightConstraint?.constant = 0
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.dataTableView?.layoutIfNeeded()
        }) { (complete) in
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.dataTableViewHeightConstraint?.constant = (self.dataTableView?.visibleCells[0].frame.height)!*9
        }
    }
    
    func updateConstrainTable(tableView: UITableView) {
        //End of loading all Visible cells
        if (tableView == self.headerTableView)
        {
            UIView.animate(withDuration: 0, animations: {
                self.headerTableView?.layoutIfNeeded()
            }) { (complete) in
                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.headerTableView?.visibleCells
                for cell in cells! {
                    heightOfTableView += cell.frame.height
                }
                // Edit heightOfTableViewConstraint's constant to update height of table view

                self.headerTableViewHeightConstraint?.constant = heightOfTableView
            }
        }
        else
        {
            UIView.animate(withDuration: 0, animations: {
                self.dataTableView?.layoutIfNeeded()
            }) { (complete) in
                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.dataTableView?.visibleCells
                for cell in cells! {
                    heightOfTableView += cell.frame.height
                }
                // Edit heightOfTableViewConstraint's constant to update height of table view

                self.dataTableViewHeightConstraint?.constant = heightOfTableView
            }
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
                self.showAlertView(title: "Xóa đơn vay", message: "Bạn có chắc chắn muốn xóa đơn vay chưa hoàn thiện này?", okTitle: "Xóa", cancelTitle: "Không", completion: { (okAction) in
                    if (okAction)
                    {
                        APIClient.shared.delLoan(loanID: (self.activeLoan?.loanId)!)
                        .done(on: DispatchQueue.main) { model in
                            self.handleLoadingView(isShow: false)
                            self.showAlertView(title: "", message: "Đơn vay của bạn đã được xóa. Bạn có thể tạo một đơn mới.", okTitle: "ok", cancelTitle: nil, completion: { (okAction) in
                                self.tabBarController?.selectedIndex = 0
                            })
                        }
                        .catch { error in
                            self.handleLoadingView(isShow: false)
                            self.showAlertView(title: "Có lỗi", message: "Đã có lỗi trong quá trình xóa đơn vay. Vui lòng thử lại.", okTitle: "ok", cancelTitle: nil, completion: { (okAction) in
                            })
                        }
                    }
                })
            }))
            
        case .RISK_PENDING?:
            alert.addAction(UIAlertAction(title: "Chỉnh sửa đơn vay", style: .default , handler:{ (UIAlertAction)in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Hủy yêu cầu", style: .destructive , handler:{ (UIAlertAction)in
                
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
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Giải ngân khi quá hạn huy động vốn
    @IBAction func disburse_expỉed()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .DISBURSEMENT_ONTIME
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Ký hợp đồng
    @IBAction func signContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.bottom_state = .SIGN_CONTRACT
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Xác nhận ký hợp đồng
    @IBAction func confirmSignContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func pushToPayViewController() {
        let payVC = TestBorrowingPayViewController(nibName: "TestBorrowingPayViewController", bundle: nil)
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
    @IBAction func pushToPayHistoryVC() {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(payHistoryVC, animated: true)
    }
    
}

extension LoanStateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == headerTableView {
            return headerData.count
        }
        
        return 9
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
                
                if indexPath.row == (headerData.count - 1) {
                    updateConstrainTable(tableView: self.headerTableView!)
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
                
                if indexPath.row == (headerData.count - 1) {
                    updateConstrainTable(tableView: self.headerTableView!)
                }
                
                return cell!
            }
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
            }
            
            switch indexPath.row {
            case 0:
                cell?.nameLabel.text = NSLocalizedString("PHONE", comment: "")
                cell?.desLabel.text = "0986632888"
            case 1:
                cell?.nameLabel.text = NSLocalizedString("LOAN_START", comment: "")
                cell?.desLabel.text = "8/5/2018"
            case 2:
                cell?.nameLabel.text = NSLocalizedString("LOAN_MONEY", comment: "")
                cell?.desLabel.text = "2.000.000đ"
                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
            case 3:
                cell?.nameLabel.text = NSLocalizedString("LOAN_TIME", comment: "")
                cell?.desLabel.text = "12 tháng"
                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
            case 4:
                cell?.nameLabel.text = NSLocalizedString("STATUS", comment: "")
                cell?.desLabel.text = getState(type: STATUS_LOAN(rawValue: (activeLoan?.status)!)!)
                cell?.desLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: (activeLoan?.status)!)!)
            case 5:
                cell?.nameLabel.text = NSLocalizedString("RATE", comment: "")
                cell?.desLabel.text = "10%/năm"
            case 6:
                cell?.nameLabel.text = NSLocalizedString("LOAN_FEE", comment: "")
                cell?.desLabel.text = "200.000đ"
            case 7:
                cell?.nameLabel.text = NSLocalizedString("MONEY_MONTH", comment: "")
                cell?.desLabel.text = "180.000đ"
                cell?.desLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
            default:
                cell?.nameLabel.text = NSLocalizedString("LOAN_DIS", comment: "")
                cell?.desLabel.text = "Vay mua điện thoại"
            }
            
            if indexPath.row == 8 {
                updateConstrainTable(tableView: self.dataTableView!)
            }
            
            return cell!
        }
    }
    
}
