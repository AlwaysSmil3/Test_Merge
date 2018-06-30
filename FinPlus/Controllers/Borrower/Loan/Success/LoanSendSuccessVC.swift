//
//  LoanSendSuccessVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanSendSuccessVC: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MARK: Actions
    
    @IBAction func btnEnableNotificationTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnGoHomeTapped(_ sender: Any) {
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.browwerInfo = model

                if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                    if let window = UIApplication.shared.delegate?.window, let win = window {
                        win.rootViewController = tabbarVC
                    }
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
            .catch { error in
                self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    
    
    
    
}
