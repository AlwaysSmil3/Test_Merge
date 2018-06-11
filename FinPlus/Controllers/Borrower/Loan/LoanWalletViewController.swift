//
//  LoanWalletViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanWalletViewController: BaseViewController {
    
    
    @IBOutlet var walletTBView: UITableView!
    
    var dataSource1: [Wallet] = [] {
        didSet {
            if dataSource1.count > 0 {
                self.walletTBView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.walletTBView.tableFooterView = UIView()
        
        self.getWallets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    func updateDataToServer() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    
    private func getWallets() {
        APIClient.shared.getWallets()
            .done { [weak self]model in
                self?.dataSource1 = model
                
            }
            .catch { error in }
    }
    
    //MARK: Actions
    
    @IBAction func btnAddWalletTapped(_ sender: Any) {
        let addWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "AddWalletViewController") as! AddWalletViewController
        addWalletVC.delegate = self
        self.navigationController?.pushViewController(addWalletVC, animated: true)
        
    }
    
}

extension LoanWalletViewController: WalletDataProtocol {
    func getWalletData(wallet: [Wallet]) {
        self.dataSource1 = wallet
    }
}


extension LoanWalletViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Wallet_TB_Cell", for: indexPath) as! LoanWalletTBCell

        let wallet = self.dataSource1[indexPath.row]

        cell.lblOwnerName.text = wallet.walletAccountName!
        cell.lblAccountNumber.text = wallet.walletNumber!
        DataManager.shared.loanInfo.walletId = wallet.id!

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController

        self.navigationController?.pushViewController(loanNationalIDVC, animated: true)

    }



}
