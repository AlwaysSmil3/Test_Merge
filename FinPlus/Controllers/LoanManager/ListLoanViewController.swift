//
//  ListLoanViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ListLoanViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    let cellIdentifier = "cell"
    private var listLoan: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        self.title = NSLocalizedString("LOAN_MANAGER", comment: "")
        
        self.noWalletLabel.text = NSLocalizedString("NO_LOAN", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        
        let cellNib = UINib(nibName: "LoanTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableview.isHidden = self.listLoan.count < 1
        self.noWalletLabel.isHidden = self.listLoan.count > 0
        self.addBtn.isHidden = self.listLoan.count > 0
        
        self.getAllLoans()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getAllLoans() {
        APIClient.shared.getAllLoans()
            .done(on: DispatchQueue.main) { model in
                // print(model)
                //                self.allLoansArray = model
                self.listLoan = model as NSArray
                self.tableview.reloadData()
                // let _ : BrowwerActiveLoan = model
            }
            .catch { error in }
    }
    
    @IBAction func addNewWallet(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListLoanViewController: UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return listLoan.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listLoan.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.listLoan[indexPath.row] as! BrowwerActiveLoan

        let sHome = UIStoryboard(name: "Loan", bundle: nil)
        let v1 = sHome.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE")
        if let loanStatusVC = v1 as? LoanStateViewController {
            loanStatusVC.activeLoan = item
            self.navigationController?.pushViewController(v1, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
}

extension ListLoanViewController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionItem = listLoan[section] as! NSDictionary
//
//        return NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.listLoan[indexPath.row] as! BrowwerActiveLoan
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "LoanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        }
        
        let state = item.status
        
        cell?.dateLabel.text = item.createdTime
        cell?.statusLabel.text = NSLocalizedString("STATUS", comment: "")
        cell?.statusValueLabel.text = getState(type: STATUS_LOAN(rawValue: state!)!)
        cell?.statusValueLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: state!)!)
        cell?.moneyLabel.text = "\(String(describing: item.amount))"
        cell?.disLabel.text = "Thời hạn: \(String(describing: item.term)) - \(String(describing: item.loanCategory?.title))"
        
        return cell!
    }
    
}
