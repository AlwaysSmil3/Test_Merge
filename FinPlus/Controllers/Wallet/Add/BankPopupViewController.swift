//
//  BankPopupViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 11/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol BankPopupSelectedProtocol: class {
    func bankSelected(name: String, index: Int)
}

class BankPopupViewController: BasePopup {
    
    
    @IBOutlet weak var mainTBView: UITableView!
    
    /// Cell đang chọn
    var currentIndex: Int?
    weak var bankSelectedDelegate: BankPopupSelectedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.register(UINib(nibName: "BankPopupTBCell", bundle: nil), forCellReuseIdentifier: "BankPopupTBCell")
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.rowHeight = UITableViewAutomaticDimension
        self.mainTBView.tableFooterView = UIView()
        
    
    }
    
    @IBAction func btnExistTapped(_ sender: Any) {
        self.hide {
            
        }
    }
    
    @IBAction func btnAgreeTapped(_ sender: Any) {
        guard let index = self.currentIndex else {
            self.showToastWithMessage(message: "Vui lòng chọn ngân hàng")
            return
        }
        self.hide {
            self.bankSelectedDelegate?.bankSelected(name: "Bidv", index: index)
        }
    }
    
    
}

extension BankPopupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankPopupTBCell", for: indexPath) as! BankPopupTBCell
        
        guard let i = self.currentIndex, i == indexPath.row else {
            cell.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_off")
            return cell
        }

        cell.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_on")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.currentIndex != indexPath.row {
            self.currentIndex = indexPath.row
            self.mainTBView.reloadData()
        }
        
        
    }
    
}
