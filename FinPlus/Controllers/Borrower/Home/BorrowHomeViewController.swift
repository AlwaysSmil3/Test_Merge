//
//  BorrowHomeViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BorrowHomeViewController: BaseViewController {
    
    @IBOutlet var contentLoanView: UIView!
    
    var detailLoanView: BrrowerHome?
    
    // Loan status cho các trạng thái của Loan
    var loanStatus: Int = DataManager.shared.browwerInfo?.activeLoan?.status ?? -1 {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.getUserInfo()
        self.getLoanCategories()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if let detailLoanView = self.detailLoanView {
            detailLoanView.frame.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    private func setupUI() {
        self.detailLoanView = BrrowerHome(frame: self.contentLoanView.frame)
        
    }
    
    // Lấy thông tin User
    private func getUserInfo() {
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .then(on: DispatchQueue.main) { model -> Void in
                
                DataManager.shared.browwerInfo = model
                
                if let loan = model.activeLoan, let status = loan.status {
                    self.loanStatus = status
                    self.detailLoanView?.loanInfo = loan
                    self.contentLoanView.addSubview(self.detailLoanView!)
                    
                    if let detailLoanView = self.detailLoanView {
                        detailLoanView.frame.origin = CGPoint(x: 0, y: 0)
                    }
                    
                }
            }
            .catch { error in }
    }
    
    // Lấy danh sách các loại khoản vay
    private func getLoanCategories() {
        guard DataManager.shared.loanCategories.count == 0 else { return }
        
        APIClient.shared.getLoanCategories()
            .then(on: DispatchQueue.main) { model -> Void in
                DataManager.shared.loanCategories = model
            }
            .catch { error in }
    }
    
    
    //MARK: Actions
    
    @IBAction func btnLoanTapped(_ sender: Any) {
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[0]
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
        
    }
    
    
    
    
}
