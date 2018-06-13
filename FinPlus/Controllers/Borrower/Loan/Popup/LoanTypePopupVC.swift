//
//  LoanTypePhoneRelationPopupVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


/// Data trả về sau khi chọn
protocol DataSelectedFromPopupProtocol {
    func dataSelected(data: LoanBuilderData)
}

class LoanTypePopupVC: BasePopup {
    
    var delegate: DataSelectedFromPopupProtocol?
    
    //Dữ liệu đầu vào
    private var dataSource: [LoanBuilderData] = [] {
        didSet {
            self.mainTBView?.reloadData()
        }
    }
    
    
    /// Cell đang chọn
    private var currentIndex: Int? {
        didSet {
            self.mainTBView?.reloadData()
        }
    }
    
    @IBOutlet var mainTBView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView?.tableFooterView = UIView()
        
    }
    
    
    /// set DataSource for tableView
    ///
    /// - Parameter data: <#data description#>
    func setDataSource(data: [LoanBuilderData]) {
        self.dataSource = data
    }
    
    @IBAction func btnOkTapped(_ sender: Any) {
        guard let index = self.currentIndex else { return }
        
        self.hide {
            self.delegate?.dataSelected(data: self.dataSource[index])
        }
    }
    
    //Đóng popup
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
        
        guard let i = self.currentIndex, i == indexPath.row else {
            cell.lblValue?.textColor = TEXT_NORMAL_COLOR
            return cell
        }
        
        cell.lblValue?.textColor = MAIN_COLOR
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.currentIndex = indexPath.row
        
    }
    
    
}
