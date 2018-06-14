//
//  BorrowHomeViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BorrowHomeViewController: BaseViewController {
    
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var contentLoanView: UIView!
    @IBOutlet var mainCollectionView: UICollectionView!
    
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
        self.detailLoanView?.delegate = self
    }
    
    // Lấy thông tin User
    private func getUserInfo() {
        
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                
                DataManager.shared.browwerInfo = model
                
                self.lblTitle.text = "Xin chào " + model.fullName! + "!"
                
                if let loan = model.activeLoan, let status = loan.status {
                    self.loanStatus = status
                    self.detailLoanView?.loanInfo = loan
                    //self.contentLoanView.addSubview(self.detailLoanView!)
                    
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
            .done(on: DispatchQueue.main) { model in
                print(model)
                DataManager.shared.loanCategories = model
            }
            .catch { error in }
    }
    
    
    //MARK: Actions

    

}

//MARK: BrowwerHomeDelegate

extension BorrowHomeViewController: BrowwerHomeDelegate {
    
    func updateInfo(status: STATUS_LOAN) {
        guard DataManager.shared.loanCategories.count > 0 else { return }
        
        switch status {
        case .DRAFT:
            self.updateInfoNeed()
            break
            
        case .ACCEPTED:
            self.acceptedInterestRate()
            break
            
        case .CANCELED:
            
            break
        case .PENDING:
            break
            
        case .REJECTED:
            break
            
        case .WAITING_FOR_APPROVAL:
            
            break
            
        case .RAISING_CAPITAL:
            break

        }
 
    }
    
    
    func updateInfoNeed() {
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[0]
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    
    func acceptedInterestRate() {
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "ConfirmInterestRateVC") as! ConfirmInterestRateVC
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    
    }
 
    
}

//MARK: UICollectionView Delegate, DataSource

extension BorrowHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeBrowModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home_Brower_Collection_Cell", for: indexPath) as! HomeBrowerCollectionCell
        
        let model = homeBrowModels[indexPath.row]
        
        cell.imgIcon.image = model.icon
        cell.lblName.text = model.name
        cell.lblDistanceAmount.text = model.distanceAmount
        
        return cell
    }
    
    /**
     * Initial size
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return FinPlusHelper.setCellSizeDisplayFitThird(indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[0]
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    
}




