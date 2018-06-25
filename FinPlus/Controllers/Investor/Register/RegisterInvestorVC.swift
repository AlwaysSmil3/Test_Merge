//
//  RegisterInvestorVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class RegisterInvestorVC: BaseViewController {
    
    
    @IBOutlet var mainTBView: TPKeyboardAvoidingTableView!
    
    var dataSource: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTBView.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.DropDown)
        mainTBView.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.TextField)
        mainTBView.register(UINib(nibName: "LoanTypeAddressTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Address)
        mainTBView.register(UINib(nibName: "LoanTypeFooterTBView", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Footer)
        
        mainTBView.rowHeight = UITableViewAutomaticDimension
        mainTBView.separatorColor = UIColor.clear
        mainTBView.tableFooterView = UIView()
        
        
    }
    
    
    
}

extension RegisterInvestorVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
        //cell.field = model
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
}


