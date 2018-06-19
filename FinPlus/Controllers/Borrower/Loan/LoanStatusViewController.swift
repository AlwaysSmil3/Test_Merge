//
//  LoanStatusViewController.swift
//  FinPlus
//
//  Created by nghiendv on 15/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class LoanStatusViewController: LoanDetailBaseViewController {
    
//    init() {
//        let storyboard = UIStoryboard(name: "HomeBrowwer", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE")
//        object_setClass(vc, LoanStatusViewController.self)
//        return (LoanStatusViewController *)vc
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var detailLoan = [
        "1PHONE" : "0986632888",
        "2LOAN_START" : "8/5/2018",
        "3LOAN_MONEY" : "2.000.000đ",
        "4LOAN_TIME" : "12 tháng",
        "5STATUS" : 1,
        "6RATE" : "10%/năm",
        "7LOAN_FEE" : "200.000đ",
        "8MONEY_MONTH" : "180.000đ",
        "9LOAN_DIS" : "Vay mua điện thoại",
        ] as NSDictionary
    
    
    private var arrayKey:NSArray!
    var activeLoan: BrowwerActiveLoan?
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        let id = DataManager.shared.browwerInfo?.activeLoan?.status
        
        switch(id) {
            case STATUS_LOAN.DRAFT.rawValue:
                
                self.desLabel?.isHidden = true
                self.bottomButton?.isHidden = true
            
                self.titleLabel?.text = NSLocalizedString("Đơn vay của bạn chưa được hoàn thiện.", comment: "")
                
                self.topButton?.backgroundColor = .white
                self.topButton?.setTitle(NSLocalizedString("Hoàn thiện đơn", comment: ""), for: .normal)
                self.topButton?.layer.cornerRadius = 8
                self.topButton?.tintColor = MAIN_COLOR
                self.topButton?.layer.borderWidth = 1
                self.topButton?.layer.borderColor = MAIN_COLOR.cgColor
            
            case STATUS_LOAN.WAITING_FOR_APPROVAL.rawValue:
                self.desLabel?.isHidden = true
                self.topButton?.isHidden = true
                self.bottomButton?.isHidden = true
            case STATUS_LOAN.PENDING.rawValue:
                
                self.bottomButton?.isHidden = true
            
                self.titleLabel?.text = NSLocalizedString("Đơn vay của bạn cần được bổ sung thông tin.", comment: "")
                self.desLabel?.text = NSLocalizedString("Để được duyệt, hãy bổ sung các thông tin sau:\n• Số chứng minh thư.\n• Ảnh chứng minh thư.\n• Bảng lương.", comment: "")
                
                self.topButton?.backgroundColor = MAIN_COLOR
                self.topButton?.setTitle(NSLocalizedString("Bổ sung thông tin", comment: ""), for: .normal)
                self.topButton?.layer.cornerRadius = 8
                self.topButton?.tintColor = .white
            
            case STATUS_LOAN.ACCEPTED.rawValue:
                
                self.bottomButton?.isHidden = true
                
                self.titleLabel?.text = NSLocalizedString("Chúc mừng Minh, đơn vay của bạn được duyệt với lãi suất 10%/năm.", comment: "")
                self.desLabel?.text = NSLocalizedString("Hãy ấn 'Xác nhận lãi suất' để bắt đầu huy động tiền từ các nhà đầu tư.", comment: "")
                
                self.topButton?.backgroundColor = MAIN_COLOR
                self.topButton?.setTitle(NSLocalizedString("Xác nhận lãi suất", comment: ""), for: .normal)
                self.topButton?.layer.cornerRadius = 8
                self.topButton?.tintColor = .white
            
            case STATUS_LOAN.REJECTED.rawValue:
                
                self.bottomButton?.isHidden = true
            
                self.titleLabel?.text = NSLocalizedString("Rất tiếc, yêu cầu vay của bạn đã bị từ chối.", comment: "")
                self.desLabel?.text = NSLocalizedString("Yêu cầu vay của bạn đã bị từ chối. Vui lòng tạo một đơn vay mới và thứ lại!", comment: "")
                
                self.topButton?.backgroundColor = .white
                self.topButton?.setTitle(NSLocalizedString("Tạo đơn vay mới", comment: ""), for: .normal)
                self.topButton?.layer.cornerRadius = 8
                self.topButton?.tintColor = MAIN_COLOR
                self.topButton?.layer.borderWidth = 1
                self.topButton?.layer.borderColor = MAIN_COLOR.cgColor
            
            case STATUS_LOAN.CANCELED.rawValue:
                
                self.desLabel?.isHidden = true
                self.topButton?.isHidden = true
                self.bottomButton?.isHidden = true
            
                self.titleLabel?.text = NSLocalizedString("Bạn đã hủy đơn vay này.", comment: "")
            
            case STATUS_LOAN.RAISING_CAPITAL.rawValue:
                
                self.topButton?.isHidden = true
                self.bottomButton?.isHidden = true
            
                self.titleLabel?.text = NSLocalizedString("FinSmart đang huy động cho khoản vay của bạn.", comment: "")
                self.desLabel?.text = NSLocalizedString("Xin vui lòng chờ, khoản vay của bạn đang được huy động vốn từ các nhà đầu tư.", comment: "")
            default:
                break
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.titleLabel?.text = NSLocalizedString("Đơn vay của bạn chưa được hoàn thiện.", comment: "")
//        self.desLabel?.text = NSLocalizedString("Để được duyệt, hãy bổ sung các thông tin sau:\n• Số chứng minh thư.\n• Ảnh chứng minh thư.\n• Bảng lương.", comment: "")
//
//        self.topButton?.backgroundColor = MAIN_COLOR
//        self.topButton?.setTitle(NSLocalizedString("Bổ sung thông tin", comment: ""), for: .normal)
//        self.topButton?.layer.cornerRadius = 8
//        self.topButton?.tintColor = .white
//        
//        self.bottomButton?.backgroundColor = MAIN_COLOR
//        self.bottomButton?.setTitle(NSLocalizedString("Bổ sung thông tin", comment: ""), for: .normal)
//        self.bottomButton?.layer.cornerRadius = 8
//        self.bottomButton?.tintColor = .white
        
        // Do any additional setup after loading the view.
//        self.arrayKey = detailLoan.allKeys as NSArray
        self.title = NSLocalizedString("DETAIL_LOAN", comment: "")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        UIView.animate(withDuration: 0, animations: {
            self.tableView?.layoutIfNeeded()
        }) { (complete) in
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.tableViewHeightConstraint?.constant = (self.tableView?.visibleCells[0].frame.height)!*10
        }
    }

}

extension LoanStatusViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension LoanStatusViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let key = arrayKey[indexPath.row] as! String
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        }
        
        cell?.nameLabel.text = "\(indexPath.row)"
        cell?.desLabel.text = "aaaaaqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        
        if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            //End of loading all Visible cells
            UIView.animate(withDuration: 0, animations: {
                self.tableView?.layoutIfNeeded()
            }) { (complete) in
                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.tableView?.visibleCells
                for cell in cells! {
                    heightOfTableView += cell.frame.height
                }
                // Edit heightOfTableViewConstraint's constant to update height of table view
                self.tableViewHeightConstraint?.constant = heightOfTableView
            }
        }
        
        return cell!
    }
    
}
