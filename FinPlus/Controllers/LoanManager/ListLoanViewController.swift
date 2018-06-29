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
    private var listLoan: NSMutableArray = [
        [
            "title" : "CURRENT_LOAN",
            "sub_array" : [
                [
                    "1PHONE" : "0986632888",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "2.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 0,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "200.000đ",
                    "8MONEY_MONTH" : "180.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 1,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 2,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 3,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 4,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 5,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 6,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 7,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 8,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 9,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 10,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 11,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 12,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 13,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 14,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 15,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 16,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 17,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 18,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
                [
                    "1PHONE" : "01656229145",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "12.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 19,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "500.000đ",
                    "8MONEY_MONTH" : "280.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                    ],
            ]
        ],
        [
            "title" : "END_LOAN",
            "sub_array" : [
                [
                    "1PHONE" : "0986632888",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "2.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 0,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "200.000đ",
                    "8MONEY_MONTH" : "180.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                ],
                [
                    "1PHONE" : "0986632888",
                    "2LOAN_START" : "8/5/2018",
                    "3LOAN_MONEY" : "2.000.000đ",
                    "4LOAN_TIME" : "12 tháng",
                    "5STATUS" : 0,
                    "6RATE" : "10%/năm",
                    "7LOAN_FEE" : "200.000đ",
                    "8MONEY_MONTH" : "180.000đ",
                    "9LOAN_DIS" : "Vay mua điện thoại",
                ],
            ]
        ]
    ]
    
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
                NSLog("List loan: %d", model.count)
//                self.tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listLoan.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = listLoan[section] as! NSDictionary
        return (sectionItem["sub_array"] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = listLoan[indexPath.section] as! NSDictionary
        tableView.deselectRow(at: indexPath, animated: true)
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! NSDictionary
//        if (item["5STATUS"] as? Int) == 9 {
            // fixed to test borrowing pay viewcontroller
            let sHome = UIStoryboard(name: "Loan", bundle: nil)
            let v1 = sHome.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE")
            if let loanStatusVC = v1 as? LoanStateViewController {
                loanStatusVC.activeLoanId = (item["5STATUS"] as? Int)!
                self.navigationController?.pushViewController(v1, animated: true)
            }
//        } else {
//            // will use LoanStateViewController replace LoanDetailViewController
//            tableView.deselectRow(at: indexPath, animated: true)
//            let sectionItem = listLoan[indexPath.section] as! NSDictionary
//            let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! NSDictionary
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LOAN_DETAIL") as! LoanDetailViewController
//            vc.detailLoan = item
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        print("123")
    }
    
}

extension ListLoanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = listLoan[section] as! NSDictionary

        return NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = listLoan[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! NSDictionary
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "LoanTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LoanTableViewCell
        }
        
        let state = item["5STATUS"] as? Int
        
        cell?.dateLabel.text = item["2LOAN_START"] as? String
        cell?.statusLabel.text = NSLocalizedString("STATUS", comment: "")
        cell?.statusValueLabel.text = getState(type: STATUS_LOAN(rawValue: state!)!)
        cell?.statusValueLabel.textColor = getColorText(type: STATUS_LOAN(rawValue: state!)!)
        
//        if ((item["5STATUS"] as? Int) == 0) {
//            cell?.statusValueLabel.text = "Đã kết thúc"
//            cell?.statusValueLabel.textColor = .black
//        } else if (item["5STATUS"] as? Int) == 9 {
//            cell?.statusValueLabel.text = "Cần thanh toán"
//            cell?.statusValueLabel.textColor = MAIN_COLOR
//        } else {
//            cell?.statusValueLabel.text = "Đang vay"
//            cell?.statusValueLabel.textColor = MAIN_COLOR
//        }
        
        cell?.moneyLabel.text = item["3LOAN_MONEY"] as? String
        cell?.disLabel.text = "Thời hạn " + (item["4LOAN_TIME"] as? String)! + " - " + (item["9LOAN_DIS"] as? String)!
        
        return cell!
    }
    
}
