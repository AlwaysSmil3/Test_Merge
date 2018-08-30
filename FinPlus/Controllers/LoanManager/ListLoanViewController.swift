//
//  ListLoanViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ListLoanViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    let cellIdentifier = "cell"
    private var listLoan: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        //self.title = NSLocalizedString("LOAN_MANAGER", comment: "")
        self.setupTitleView(title: "Quản lý các khoản vay")
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.noWalletLabel.text = NSLocalizedString("NO_LOAN", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        
        let cellNib = UINib(nibName: "LoanTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        // self.getAllLoans(isShowLoading: true)
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
        
        // reload data
        self.getAllLoans()
    }
    
    private func getAllLoans() {
        
        self.listLoan.removeAllObjects()
        APIClient.shared.getUserLoans()
            .done(on: DispatchQueue.main) { model in
                
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
                
                if (unCompleteArr.count > 0)
                {
                    self.listLoan.add(["title" : "CURRENT_LOAN", "sub_array" : unCompleteArr])
                }
                
                if (completeArr.count > 0)
                {
                    self.listLoan.add(["title" : "END_LOAN", "sub_array" : completeArr])
                }
                
                self.tableview.reloadData()

                self.tableview.isHidden = self.listLoan.count < 1
                self.noWalletLabel.isHidden = self.listLoan.count > 0
                self.addBtn.isHidden = self.listLoan.count > 0
            }
            .catch { error in
        }
    }
    
    @IBAction func addNewLoan(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}

extension ListLoanViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listLoan.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionItem = listLoan[section] as! NSDictionary
        return (sectionItem["sub_array"] as! NSArray).count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionItem = listLoan[section] as! NSDictionary
        return NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = listLoan[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! BrowwerActiveLoan
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "LoanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        }
        
        let state = item.status
        
        cell?.dateLabel.text = Date.init(fromString: item.createdTime ?? "", format: DateFormat.custom(DATE_FORMATTER_FROM_SERVER)).toString(DateFormat.custom(kDisplayFormat))
        cell?.statusLabel.text = NSLocalizedString("STATUS", comment: "") + ":"
        cell?.statusValueLabel.text = getState(type: STATUS_LOAN(rawValue: state!)!)
        cell?.statusValueLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: state!)!)
        let amount = FinPlusHelper.formatDisplayCurrency(Double(item.amount?.description ?? "") ?? 0) + " đ"
        cell?.moneyLabel.text = amount
        cell?.disLabel.text = "Thời hạn: \(item.term ?? 0) ngày - \(item.loanCategory?.title ?? "")"
        
        return cell!
    }
    
}
