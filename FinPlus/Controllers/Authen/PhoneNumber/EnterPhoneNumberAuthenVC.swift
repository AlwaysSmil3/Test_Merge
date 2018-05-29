//
//  EnterPhoneNumberAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import JWT


class EnterPhoneNumberAuthenVC: BaseViewController {
    
    @IBOutlet var tfPhoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }
    
    private func testJWT() {
        
        let encode = JWT.encode(claims: ["my": "payload"], algorithm: .hs256("11111116".data(using: .utf8)!))
        
        print("encode: \(encode)")
        
        do {
            let decode: ClaimSet = try JWT.decode(encode, algorithm: .hs256("11111116".data(using: .utf8)!))
            print("decoce: \(decode)")
        } catch let error {
            print("failue to decode JWT: \(error)")
        }
        
    }
    
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        if self.tfPhoneNumber.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại để tiếp tục")
            return
        }
        
        
        APIClient.shared.authentication(phoneNumber: self.tfPhoneNumber.text!)
            .then(on: DispatchQueue.main) { model -> Void in
                if model.returnCode! == 1 {
                    
                    DataManager.shared.currentAccount = self.tfPhoneNumber.text!
                    
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                    
                    self.navigationController?.pushViewController(verifyVC, animated: true)
                }
            }
    }
    
}
