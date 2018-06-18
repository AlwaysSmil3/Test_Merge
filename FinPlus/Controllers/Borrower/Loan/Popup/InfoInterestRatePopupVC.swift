//
//  InfoInterestRatePopupVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class InfoInterestRatePopupVC: BasePopup {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var mainTBView: UITableView?
    
    var titleString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = self.titleString
        self.mainTBView?.tableFooterView = UIView()
        self.mainTBView?.separatorColor = UIColor.clear
        
    }
    
    
    @IBAction func btnHiddenTapped(_ sender: Any) {
        self.hide()
    }
    
    
}

extension InfoInterestRatePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
