//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanOtherInfoVC: LoanBaseViewController {
    
    
    var currentSelectedCollection: IndexPath?
    
    override func viewDidLoad() {
        self.index = 3
        super.viewDidLoad()
        
        self.currentStep = 4
        self.updateDataToServer()
        
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //MARK: ACtions

    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if DataManager.shared.loanInfo.optionalText.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập lương tháng của bạn")
            return
        }
        
        if !Platform.isSimulator {
            if DataManager.shared.loanInfo.optionalMedia.count == 0 {
                self.showToastWithMessage(message: "Vui lòng tải ảnh bảng lương/ chấm công của bạn")
                return
            }
        }
        
        guard DataManager.shared.listKeyMissingLoanKey == nil || DataManager.shared.listKeyMissingLoanKey!.count == 0 else {
            self.updateLoanStatus()
            return
        }
        
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
    }
    
    private func updateLoanStatus() {
        DataManager.shared.loanInfo.status = DataManager.shared.loanInfo.status - 1
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                
                //Lay thong tin nguoi dung
                APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.browwerInfo = model
                        
                        self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: "Bạn đã cập nhật thông tin xong!", okTitle: "Về trang chủ", cancelTitle: nil) { (status) in
                            if status {
                                if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
                                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                                    if let window = UIApplication.shared.delegate?.window, let win = window {
                                        win.rootViewController = tabbarVC
                                    }
                                } else {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                        
                    }
                    .catch { error in
                        self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
            .catch { error in }
        
        
    }
    
    
    
}




//MARK: UICollection View Delegate Flow Layout
extension LoanOtherInfoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (BOUND_SCREEN.size.width - 32) / 3
        return CGSize(width: width, height: width)
    }
    
}


