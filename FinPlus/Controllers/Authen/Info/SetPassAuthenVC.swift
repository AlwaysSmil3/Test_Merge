//
//  SetPassAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

enum SetPassOrResetPass {
    case SetPass
    case ResetPass
}
class SetPassAuthenVC: BaseViewController, UITextFieldDelegate {
    var phone : String!
    var setPassOrResetPass: SetPassOrResetPass = SetPassOrResetPass.SetPass
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfRePass: UITextField!
    
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
    
    @IBOutlet var btnHideShowRePass: UIButton!
    var isShowRePass: Bool = false {
        didSet {
            if isShowRePass {
                self.btnHideShowRePass.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
                self.tfRePass.isSecureTextEntry = false
            } else {
                self.btnHideShowRePass.setImage(#imageLiteral(resourceName: "ic_show_pass"), for: .normal)
                self.tfRePass.isSecureTextEntry = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfPass.delegate = self
        self.tfRePass.delegate = self
        
        self.tfPass.becomeFirstResponder()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch setPassOrResetPass {
        case .SetPass:
            self.lblTitle.text = "Tạo tài khoản mới"
            if let account = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
                self.lblHeader.text = "Xin chào \(account), bạn chưa có tài khoản. Vui lòng thiết lập mật khẩu để bắt đầu."
            }
        default:
            self.lblTitle.text = "Thiết lập mật khẩu mới"
            if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
                self.lblHeader.text = "Xin chào \(account), bạn đã yêu cầu đặt lại mật khẩu. Vui lòng tạo mật khẩu mới."
            }
        }
    }
    
    private func updateStateBtnContinue() {
        if self.tfPass.text!.length() >= 6 && self.tfRePass.text!.length() >= 6 {
            self.isEnableContinueButton(isEnable: true)
            self.view.endEditing(true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
        
    }
    
    //MARK: TextFiled Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    //MARK: Action
    
    @IBAction func tfPassEditChanged(_ sender: Any) {
        self.updateStateBtnContinue()
        
    }
    
    @IBAction func tfRePassEditChanged(_ sender: Any) {
        self.updateStateBtnContinue()
    }
    
    @IBAction func btnShowPassTapped(_ sender: Any) {
        self.isShowPass = !self.isShowPass
    }
    
    @IBAction func btnShowRePassTapped(_ sender: Any) {
        self.isShowRePass = !self.isShowRePass
    }
    
    
    @IBAction func btnConfirmTapped(_ sender: Any) {
        // validate password
        if self.tfPass.text!.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu")
            return
        }

        if self.tfPass.text!.length() < 6 {
            self.showToastWithMessage(message: "Mật khẩu nhập vào không hợp lệ. Mật khẩu chỉ gồm 6 số, không bao gồm chữ cái và các ký tự khác")
            return
        }

        if self.tfRePass.text!.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập lại mật khẩu")
            return
        }

        if self.tfRePass.text!.length() < 6 {
            self.showToastWithMessage(message: "Mật khẩu xác nhận không hợp lệ. Mật khẩu chỉ gồm 6 số, không bao gồm chữ cái và các ký tự khác")
            return
        }

        if !self.tfPass.text!.contains(self.tfRePass.text!) {
            self.showToastWithMessage(message: "Mật khẩu Không trùng khớp. Vui lòng thử lại.")

            return
        }
        
        switch setPassOrResetPass {
        case .SetPass:
            self.setNewPasswordAPI(newPassword: self.tfPass.text!)
            self.pushToChoiceKindUserVC()
        default:
            self.resetPasswordAPI(newPassword: self.tfPass.text!)
            self.showGreenBtnMessage(title: "Thành công", message: "Mật khẩu mới đã được thiết lập thành công", okTitle: "OK", cancelTitle: nil) { (true) in
                self.pushToChoiceKindUserVC()
            }
        }
    }

    func setNewPasswordAPI(newPassword: String) {
        // call to set new password API (update user data)

        // success -> save phone
        if let newPhone = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
            userDefault.set(newPhone, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
            DataManager.shared.currentAccount = newPhone
        }
    }

    func resetPasswordAPI(newPassword: String) {
        // call to reset password API (update user data)

        // sucess -> save phone
        userDefault.set(DataManager.shared.currentAccount, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
    }

    func pushToChoiceKindUserVC() {
        let choiceKindUser = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "ChoiceKindUserVC") as! ChoiceKindUserVC
        choiceKindUser.pw = self.tfPass.text!
        self.navigationController?.pushViewController(choiceKindUser, animated: true)
    }

}
