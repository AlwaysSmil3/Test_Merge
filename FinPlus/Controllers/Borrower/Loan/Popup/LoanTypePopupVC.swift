//
//  LoanTypePhoneRelationPopupVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation



class LoanTypePopupVC: BasePopup {
    
    private var dataSource: [LoanBuilderData] = [] {
        didSet {
            self.mainTBView?.reloadData()
        }
    }
    
    @IBOutlet var mainTBView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView?.tableFooterView = UIView()
        
    }
    
    func setDataSource(data: [LoanBuilderData]) {
        self.dataSource = data
    }
    
    @IBAction func btnOkTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.hide()
    }
    
}

extension LoanTypePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        cell.lblValue?.text = self.dataSource[indexPath.row].title!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
}
