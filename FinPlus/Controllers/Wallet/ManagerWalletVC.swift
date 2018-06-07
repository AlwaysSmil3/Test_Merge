//
//  ManagerWalletVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/28/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class ManagerWalletVC: BaseViewController {
    
    @IBOutlet var emptyWalletView: UIView!
    @IBOutlet var walletTBView: UITableView!
    
    var dataSource: [Wallet] = [] {
        didSet {
            if dataSource.count > 0 {
                self.walletTBView.reloadData()
            } else {
                self.emptyWalletView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyWalletView.isHidden = true
        
        self.getWallets()
    }
    
    private func getWallets() {
        
        APIClient.shared.getWallets()
            .done { [weak self]model in
                self?.dataSource = model
                
            }
            .catch { error in }
    }
    
    //MARK
    
    @IBAction func btnAddWalletTapped(_ sender: Any) {
        
        let addWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "AddWalletViewController") as! AddWalletViewController
        addWalletVC.delegate = self
        self.navigationController?.pushViewController(addWalletVC, animated: true)
        
    }
    
}

extension ManagerWalletVC: WalletDataProtocol {
    func getWalletData(wallet: [Wallet]) {
        self.dataSource = wallet
    }
}


extension ManagerWalletVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Wallet_TB_Cell", for: indexPath) as! LoanWalletTBCell
        
        let wallet = self.dataSource[indexPath.row]
        
        cell.lblOwnerName.text = wallet.walletAccountName!
        cell.lblAccountNumber.text = wallet.walletNumber!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    
}



