//
//  ListWalletViewController+Loan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 12/17/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

//Loan
extension ListWalletViewController {
    
    
    func initForCreateLoan() {
        
        tableview.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.DropDown)
        tableview.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.TextField)
        tableview.register(UINib(nibName: "AddNewWalletTBCell", bundle: nil), forCellReuseIdentifier: "AddNewWalletTBCell")
        
        self.noWalletLabel?.isHidden = true
        self.addBtn?.isHidden = true
        self.tableview?.isHidden = false
        
        self.rightBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR, NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_SEMIBOLD, size: 17) ?? UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        self.setupTitleView(title: "Tạo yêu cầu vay", subTitle: "Bước 4: Thông tin tài chính")
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.bottomView.isHidden = false
        self.updateDataFromServer()
        DataManager.shared.loanInfo.currentStep = 3
        self.listFieldsForLoan.add("no_wallet")
        guard let fields = DataManager.shared.listFieldForStep4 else {
            self.getDataLoanFromJSONStep4()
            return
        }
        
        self.listFieldsForLoan.addObjects(from: fields)
        
    }
    
    
    
    /// Get Data from JSON
    func getDataLoanFromJSONStep4() {
        if let path = Bundle.main.path(forResource: "LoanJsonStep4", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Any] {
                    // do stuff
                    var listTemp: [LoanBuilderFields] = []
                    jsonResult.forEach({ (data) in
                        let toll = LoanBuilderFields(object: data)
                        listTemp.append(toll)
                    })
                    
                    if listTemp.count > 0 {
                        DataManager.shared.listFieldForStep4 = listTemp
                        self.listFieldsForLoan.addObjects(from: listTemp)
                    }
                    
                }
            } catch {
                // handle error
            }
        }
    }
    
    
    /// Cho Loan - Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func updateDataToServer(completion: @escaping() -> Void) {
        DataManager.shared.loanInfo.currentStep = 3
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                completion()
            }
            .catch { error in }
    }
    
    
    /// Right NavigationBar tapped
    func hanldeLoanDataToServer() {
        guard self.walletAction == .LoanNation, let bankId = self.currentBankIdSelected else {
            self.showToastWithMessage(message: "Vui lòng chọn tài khoản nhận tiền")
            return
        }
        
        DataManager.shared.loanInfo.walletId = bankId
        DataManager.shared.loanInfo.bankId = bankId
        
        if !DataManager.shared.checkDataInvalidChangedInStepBank(currentBank: self.getCurrentLoanBank()) {
            //For Missing Data
            self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
            return
        }
        
        
        if DataManager.shared.listKeyMissingLoanKey != nil && DataManager.shared.listKeyMissingLoanKey!.count > 0  {
            if !DataManager.shared.checkIndexLastStepHaveMissingData(index: 4) {
                DataManager.shared.loanInfo.currentStep = 3
                updateLoanStatusInvalidData()
                return
            }
        }
        
        self.updateDataToServer {
            let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(loanNationalIDVC, animated: true)
        }
    }
    
    
    
    
    
    
    
    
    
}
