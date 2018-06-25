//
//  BudgetAwardsViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BudgetAwardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetAwardBtn: UIButton!
    var bankList : [Wallet] = [Wallet]()
    var bankSelected: Wallet!
    override func viewDidLoad() {
        super.viewDidLoad()
        let wallet1 = Wallet(wID: 1, wType: 1, wAccountName: "0987654231234", wName: "MoMo", wNumber: "10231231")
        let wallet2 = Wallet(wID: 1, wType: 2, wAccountName: "0987654231234", wName: "PayPal", wNumber: "10231232")
        //        let wallet3 = Wallet(wID: 1, wType: 2, wAccountName: "0987654231234", wName: "Wallet3", wNumber: "10231233")

        bankList.append(wallet1)
        bankList.append(wallet2)
        configureTableView()

        // Do any additional setup after loading the view.
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(type: BankAccountTableViewCell.self)
        tableView.registerNibCell(type: AddNewWalletTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < bankList.count {
            if let cell = tableView.dequeueReusableNibCell(type: BankAccountTableViewCell.self) {
                cell.cellData = bankList[indexPath.row]
                if (bankSelected) != nil {
                    if cell.cellData.walletNumber == self.bankSelected.walletNumber {
                        cell.isSelectedCell = true
                    } else {
                        cell.isSelectedCell = false
                    }
                } else {
                    cell.isSelectedCell = false
                }
                cell.updateCellView()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableNibCell(type: AddNewWalletTableViewCell.self) {
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < bankList.count {
            let cellDataSelected = bankList[indexPath.row]
            self.bankSelected = cellDataSelected
            self.tableView.reloadData()
        } else {
            // add new bank
            print("add new bank")
        }

    }
    
    @IBAction func budgetRewardAction(_ sender: Any) {
        print("budget reward")
        // direct to bank

        // after success -> success view
        let successVC = BudgetRewardSuccessViewController(nibName: "BudgetRewardSuccessViewController", bundle: nil)
//        self.present(successVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(successVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
