//
//  LoanSummaryInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSummaryInfoVC: BaseViewController {
    
    @IBOutlet var mainTBView: UITableView!
    
    var dataSource: [LoanSummaryModel] = [
        LoanSummaryModel(name: "Số điện thoại", value: DataManager.shared.currentAccount),
        LoanSummaryModel(name: "Ngày tạo đơn", value: "Date"),
        LoanSummaryModel(name: "Số tiền vay", value: FinPlusHelper.formatDisplayCurrency(Double(DataManager.shared.loanInfo.amount)) + "đ"),
        LoanSummaryModel(name: "Kỳ hạn vay", value: "\(DataManager.shared.loanInfo.term)"),
        LoanSummaryModel(name: "Lãi xuất dự kiến", value: ""),
        LoanSummaryModel(name: "Phí dịch vụ", value: ""),
        LoanSummaryModel(name: "Trả góp dự kiến hàng tháng", value: ""),
        LoanSummaryModel(name: "Mục đích vay", value: ""),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.tableFooterView = UIView()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    private func loan() {
        APIClient.shared.loan()
            .done(on: DispatchQueue.main) { [weak self] model in
                
                let otpVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                otpVC.loanResponseModel = model
                otpVC.verifyType = .Loan
                self?.navigationController?.pushViewController(otpVC, animated: true)
                
            }
            .catch { error in }
    }
    
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        let messeage = "Mã xác thực sẽ được gửi tới " + DataManager.shared.currentAccount + " qua tin nhắn SMS sau khi bạn đồng ý. Bạn có chắc chắn không?"
        
        self.showAlertView(title: "Gửi đơn vay", message: messeage, okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ") { (status) in
            
            if status {
                self.loan()
            }
        }
        
    }
    
}

extension LoanSummaryInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        let model = self.dataSource[indexPath.row]
        
        cell.lblValue.text = model.name
        cell.lblSubTitle.text = model.value
        
        return cell
    }
    
    
    
}


