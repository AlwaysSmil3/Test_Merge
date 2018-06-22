//
//  LoanStateViewController.swift
//  FinPlus
//
//  Created by nghiendv on 20/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum HeaderCellType {
    case TextType
    case ButtonType
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
    var activeLoanId: Int = 0
    
    @IBAction func navi_back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var id = activeLoan?.status
        var isEnableFooterView = false
        
        id = activeLoanId
        
        if (hiddenBack)
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        self.btnBottomView.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
        self.btnBottomView.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
        self.btnBottomView?.backgroundColor = MAIN_COLOR
        self.btnBottomView?.tintColor = .white
        self.btnBottomView.layer.cornerRadius = 8
        self.btnBottomView.layer.masksToBounds = true
        
        switch(id) {
        case STATUS_LOAN.DRAFT.rawValue:
            
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
                    "target": ""
                ],
            ]
            
        case STATUS_LOAN.WAITING_FOR_APPROVAL.rawValue:
            
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Đơn vay của bạn đang chờ duyệt.",
                    "subType": TextCellType.TitleType,
                ],
            ]
            
        case STATUS_LOAN.PENDING.rawValue:
            
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
            
        case STATUS_LOAN.ACCEPTED.rawValue:
            
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Chúc mừng Minh, đơn vay của bạn được duyệt với lãi suất 10%/năm.",
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
                    "target": ""
                ],
            ]
            
        case STATUS_LOAN.REJECTED.rawValue:
            
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
            
        case STATUS_LOAN.CANCELED.rawValue:
            
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Bạn đã hủy đơn vay này.",
                    "subType": TextCellType.TitleType,
                ],
            ]
            
        case STATUS_LOAN.RAISING_CAPITAL.rawValue:
            
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

        case STATUS_LOAN.PAY_TEST_STATUS.rawValue :
            headerData = [
                [
                    "type": HeaderCellType.TextType,
                    "text": "Xin chào Minh, bạn đang vay 2.000.000đ.",
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
            
        case 10:
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.signContract), for: .touchUpInside)
            self.labelBottomView.text = "Khoản vay của bạn đã được huy động đủ số tiền. Chỉ còn một bước ký hợp đồng để nhận tiền."
            isEnableFooterView = true
            
        case 11:
            self.btnBottomView.setTitle("Ký hợp đồng để giải ngân", for: .normal)
            self.btnBottomView.addTarget(self, action: #selector(LoanStateViewController.confirmSignContract), for: .touchUpInside)
            self.labelBottomView.text = "Không, tiếp tục huy động"
            self.labelBottomView.font = UIFont.boldSystemFont(ofSize: 17)
            self.labelBottomView.textAlignment = .center
            self.labelBottomView.textColor = UIColor(hexString: "#4D6678")
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

    @IBAction func pushToPayViewController() {
        let payVC = TestBorrowingPayViewController(nibName: "TestBorrowingPayViewController", bundle: nil)
        self.navigationController?.pushViewController(payVC, animated: true)
    }

    @IBAction func pushToPayHistoryVC() {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(payHistoryVC, animated: true)
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
    
    @IBAction func signContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE") as! LoanStateViewController
        vc.activeLoanId = 11
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func confirmSignContract()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN")
        self.navigationController?.pushViewController(vc!, animated: true)
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
                
                cell?.setTextCellType(type: item["subType"] as! TextCellType)
                cell?.label.text = item["text"] as? String
                
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
            case 3:
                cell?.nameLabel.text = NSLocalizedString("LOAN_TIME", comment: "")
                cell?.desLabel.text = "12 tháng"
            case 4:
                cell?.nameLabel.text = NSLocalizedString("STATUS", comment: "")
                cell?.desLabel.text = "Chưa hoàn thiện"
            case 5:
                cell?.nameLabel.text = NSLocalizedString("RATE", comment: "")
                cell?.desLabel.text = "10%/năm"
            case 6:
                cell?.nameLabel.text = NSLocalizedString("LOAN_FEE", comment: "")
                cell?.desLabel.text = "200.000đ"
            case 7:
                cell?.nameLabel.text = NSLocalizedString("MONEY_MONTH", comment: "")
                cell?.desLabel.text = "180.000đ"
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
