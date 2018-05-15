//
//  VerifyOTPAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class VerifyOTPAuthenVC: BaseViewController {
    
    @IBOutlet var lblLimitTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        
        let phoneNumber = DataManager.shared.currentAccount
        
        APIClient.shared.verifyOTPAuthen(phoneNumber: phoneNumber, otp: "123456")
            .then(on: DispatchQueue.main) { model -> Void in
                guard let isNew = model.isNew, isNew else {
                    // Nếu là tài khoản củ sang login
                    let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    
                    return
                }
                // Nếu là tài khoản mới sang cập nhật thông tin(pass, chon là invest hat broww...)
                
                let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
                
                self.navigationController?.pushViewController(updatePassVC, animated: true)
                
            }
    }
    
}
