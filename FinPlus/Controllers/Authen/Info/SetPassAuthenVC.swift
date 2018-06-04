//
//  SetPassAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class SetPassAuthenVC: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var tfPass: UITextField!
    @IBOutlet var tfRePass: UITextField!
    
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
        
    }
    
    private func updateStateBtnContinue() {
        if self.tfPass.text!.length() >= 6 && self.tfRePass.text!.length() >= 6 {
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_enable_login")
            self.btnContinue!.dropShadow(color: MAIN_COLOR)
            self.btnContinue!.isEnabled = true
        } else {
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_disable_login")
            self.btnContinue!.dropShadow(color: DISABLE_BUTTON_COLOR)
            self.btnContinue!.isEnabled = false
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
        
        let choiceKindUser = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "ChoiceKindUserVC") as! ChoiceKindUserVC
        
        choiceKindUser.pw = self.tfPass.text!
        
        self.navigationController?.pushViewController(choiceKindUser, animated: true)
        
    }
    
    
    
}
