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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.walletTBView.tableFooterView = UIView()

        
        
        
    }
    
    
}


extension LoanWalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Wallet_TB_Cell", for: indexPath) as! LoanWalletTBCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController
        
        self.navigationController?.pushViewController(loanNationalIDVC, animated: true)
        
    }
    
    
    
}
