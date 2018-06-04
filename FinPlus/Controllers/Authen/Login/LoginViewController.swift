//
//  LoginViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var lblHeaderAccount: UILabel!
    @IBOutlet var tfPass: UITextField!
    
    @IBOutlet var btnHideShowPass: UIButton!
    var isShowPass: Bool = false {
        didSet {
            if isShowPass {
                self.btnHideShowPass.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
                self.tfPass.isSecureTextEntry = false
            } else {
                self.btnHideShowPass.setImage(#imageLiteral(resourceName: "ic_show_pass"), for: .normal)
                self.tfPass.isSecureTextEntry = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfPass.delegate = self

        self.updateUI()
    }
    
    private func updateUI() {
        if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.lblHeaderAccount.text = "Xin chào \(account), Vui lòng nhập mật khẩu của bạn để tiếp tục."
        }
        
    }
    
    
    
    //MARK: Actions
    
    @IBAction func tfEditChanged(_ sender: Any) {
        if self.tfPass.text!.length() >= 6 {
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_enable_login")
            self.btnContinue!.dropShadow(color: MAIN_COLOR)
            self.btnContinue!.isEnabled = true
        } else {
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_disable_login")
            self.btnContinue!.dropShadow(color: DISABLE_BUTTON_COLOR)
            self.btnContinue!.isEnabled = false
        }
    }
    
    @IBAction func btnHideShowPassTapped(_ sender: Any) {
        self.isShowPass = !self.isShowPass
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        
        guard let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String else { return }
        
        if self.tfPass.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu để tiếp tục")
            return
        }
        
        APIClient.shared.authentication(phoneNumber: account, pass: tfPass.text!)
            .then(on: DispatchQueue.main) { model -> Void in
                if model.returnCode! == 1 {
                
                    DataManager.shared.currentAccount = account
                    
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                    
                    self.navigationController?.pushViewController(verifyVC, animated: true)
                }
        }
    }
    
    @IBAction func btnForgotPassTapped(_ sender: Any) {
        
    }
}

//MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
}






