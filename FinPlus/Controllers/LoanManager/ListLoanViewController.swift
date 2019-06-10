//
//  ListLoanViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ListLoanViewController: BaseViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    private var listLoan: NSMutableArray = []
    private var pageSize = 30
    var isCanReload = true
    var currentPage = 1
    var totalCountItems = 0
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitleView(title: "Quản lý các khoản vay")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.noWalletLabel.text = NSLocalizedString("NO_LOAN", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        
//        let cellNib = UINib(nibName: "LoanTableViewCell", bundle: nil)
//        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
//        let loadCellNib = UINib(nibName: "FetchingDataTableViewCell", bundle: nil)
//        self.tableview.register(loadCellNib, forCellReuseIdentifier: "FetchingDataTableViewCell")
        
        tableview.registerCell(LoanTableViewCell.className)
        tableview.registerCell(FetchingDataTableViewCell.className)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isBack = DataManager.shared.isBackFromLoanStatusVC, isBack {
            DataManager.shared.isBackFromLoanStatusVC = nil
            return
        }
        
        self.getAllLoans()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentPage = 1
    }
    
    private func getAllLoans() {
        guard self.isCanReload else { return }
        
        DataManager.shared.isNoShowAlertTimeout = true
        self.isCanReload = false
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        APIClient.shared.getUserLoans(currentPage: self.currentPage, pageSize: self.pageSize)
            .done(on: DispatchQueue.global()) { json in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.errorConnectView?.isHidden = true
                }
                
                guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                    let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: "Lấy danh sách khoản vay của bạn", message: message, okTitle: "Thử lại", cancelTitle: "Đóng", completion: { (status) in
                            
                            self.isCanReload = true
                            if status {
                                self.getAllLoans()
                            }
                        })
                    }
                    return
                }
                
                var model: [BrowwerActiveLoan] = []
                
                if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                    model = data.compactMap {BrowwerActiveLoan(object: $0)}
                }
                
                self.isCanReload = true
                
                if self.currentPage >= 2 {
                    //Handle LoadMore
                    guard model.count > 0 else {
                        self.isCanReload = true
                        return
                    }
                    self.currentPage += 1
                    
                    let completeArr:NSMutableArray = []
                    //let unCompleteArr:NSMutableArray = []
                    if let sectionItem = self.listLoan.lastObject as? NSDictionary, let items = sectionItem["sub_array"] as? [BrowwerActiveLoan] {
                        completeArr.addObjects(from: items)
                    }
                    
                    model.forEach({ (loan) in
                        if let status = loan.status {
                            if status == 17 || status == 18 || status == 5 {
                                completeArr.add(loan)
                            }
                        }
                    })
                    
                    if completeArr.count > 0 {
                        self.listLoan.removeLastObject()
                        self.listLoan.add(["title" : "END_LOAN", "sub_array" : completeArr])
                    }
                    
                    self.totalCountItems += completeArr.count
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                        self.tableview.isHidden = self.listLoan.count < 1
                        self.noWalletLabel.isHidden = self.listLoan.count > 0
                        self.addBtn.isHidden = self.listLoan.count > 0
                    }
                    return
                }
                
                if model.count > 0 {
                    self.currentPage += 1
                }
                
                let completeArr:NSMutableArray = []
                let unCompleteArr:NSMutableArray = []
                
                model.forEach({ (loan) in
                    if let status = loan.status {
                        if status == 17 || status == 18 || status == 5 {
                            completeArr.add(loan)
                        } else {
                            unCompleteArr.add(loan)
                        }
                    }
                })
                
                if self.currentPage == 2 {
                    if unCompleteArr.count > 0 {
                        self.listLoan.removeAllObjects()
                        self.listLoan.add(["title" : "CURRENT_LOAN", "sub_array" : unCompleteArr])
                    }
                    
                    if completeArr.count > 0 {
                        self.listLoan.removeAllObjects()
                        self.listLoan.add(["title" : "END_LOAN", "sub_array" : completeArr])
                    }
                }
                
                self.totalCountItems = unCompleteArr.count + completeArr.count
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.tableview.isHidden = self.listLoan.count < 1
                    self.noWalletLabel.isHidden = self.listLoan.count > 0
                    self.addBtn.isHidden = self.listLoan.count > 0
                }
            }
            .catch { error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let err = error as NSError
                self.isCanReload = true
                if err.code == NSURLErrorTimedOut {
                    guard self.listLoan.count > 0 else {
                        self.errorConnectView?.isHidden = false
                        return
                    }
                    self.errorConnectView?.isHidden = true
                    
                    self.showSnackView(message: "Lỗi timeout đường truyền.", titleButton: "THỬ LẠI", completion: {
                        self.getAllLoans()
                    })
                }
        }
    }
    
    @IBAction func addNewLoan(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func btnTryTapped(_ sender: Any) {
        self.getAllLoans()
    }
    
}

extension ListLoanViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard listLoan.count > 0 else { return 1 }
        return listLoan.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard listLoan.count > 0 else { return 1 }
        let sectionItem = listLoan[section] as! NSDictionary
        return (sectionItem["sub_array"] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        guard listLoan.count > 0 else { return }
        
        let sectionItem = listLoan[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! BrowwerActiveLoan

        let sHome = UIStoryboard(name: "Loan", bundle: nil)
        let v1 = sHome.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE")
        if let loanStatusVC = v1 as? LoanStateViewController {
            loanStatusVC.activeLoan = item
            loanStatusVC.isFromManagerLoan = true
            v1.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(v1, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
}

extension ListLoanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard listLoan.count > 0 else { return }
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = FONT_CAPTION
        header.textLabel?.textColor = TEXT_NORMAL_COLOR
        let sectionItem = listLoan[section] as! NSDictionary
        header.textLabel?.text = NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard listLoan.count > 0 else { return nil }
        let sectionItem = listLoan[section] as! NSDictionary
        return NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard listLoan.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FetchingDataTableViewCell", for: indexPath) as! FetchingDataTableViewCell
            return cell
        }
        
        let sectionItem = listLoan[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! BrowwerActiveLoan
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LoanTableViewCell.className) as! LoanTableViewCell
//        if cell == nil {
//            tableView.register(UINib(nibName: "LoanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
//            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
//        }
        
        let state = item.status ?? 0
        
        cell.dateLabel.text = Date.init(fromString: item.createdTime ?? "", format: DateFormat.custom(DATE_FORMATTER_FROM_SERVER)).toString(DateFormat.custom(kDisplayFormat))
        cell.statusLabel.text = NSLocalizedString("STATUS", comment: "") + ":"
        cell.statusValueLabel.text = getState(type: STATUS_LOAN(rawValue: state)!)
        cell.statusValueLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: state)!)
        let amount = FinPlusHelper.formatDisplayCurrency(Double(item.amount?.description ?? "") ?? 0) + " đ"
        cell.moneyLabel.text = amount
        
        let termInt = item.term ?? 0
        var term = "\(termInt/30) tháng"
        if termInt < 30 {
            term = "\(termInt) ngày"
        }
        
        var titleCate = item.loanCategory?.title ?? "Đang cập nhật"
        if titleCate.count == 0 {
            titleCate = "Đang cập nhật"
        }
        
        cell.disLabel.text = "Thời hạn: \(term) - \(titleCate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if self.listLoan.count > 0 && indexPath.section + 1 == self.listLoan.count {
            if let sectionItem = listLoan[indexPath.section] as? NSDictionary, let items = sectionItem["sub_array"] as? NSArray {
                if self.totalCountItems > 2, self.totalCountItems % self.pageSize == 0, indexPath.row == items.count - 2 {
                    self.getAllLoans()
                }
            }
        }
    }
    
}
