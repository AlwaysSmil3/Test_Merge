//
//  SetPassAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import MessageUI

enum SetPassOrResetPass {
    case SetPass
    case ResetPass
}
class SetPassAuthenVC: BaseAuthenViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tfRePass: UITextField!
    @IBOutlet var btnHideShowPass: UIButton!
    @IBOutlet var btnHideShowRePass: UIButton!
    
    var phone : String!
    var setPassOrResetPass: SetPassOrResetPass = SetPassOrResetPass.SetPass
    
    var isShowPass = false {
        didSet {
            if isShowPass {
                self.btnHideShowPass.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
                self.tfPass?.isSecureTextEntry = false
            } else {
                self.btnHideShowPass.setImage(#imageLiteral(resourceName: "ic_show_pass"), for: .normal)
                self.tfPass?.isSecureTextEntry = true
            }
        }
    }
    
    var isShowRePass = false {
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
        self.tfPass?.delegate = self
        self.tfRePass?.delegate = self
        if #available(iOS 11.0, *) {
            self.tfPass?.textContentType = .password
            self.tfRePass?.textContentType = .password
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch setPassOrResetPass {
        case .SetPass:
            self.lblTitle.text = "Tạo tài khoản mới"
            self.lblHeader.text = "Xin chào! Bạn chưa có tài khoản. Vui lòng thiết lập mật khẩu để bắt đầu."
        case .ResetPass:
            self.lblTitle.text = "Thiết lập mật khẩu mới"
            if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
                self.lblHeader.text = "Xin chào \(account), bạn đã yêu cầu đặt lại mật khẩu. Vui lòng tạo mật khẩu mới."
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tfPass?.becomeFirstResponder()
    }
    
    private func updateStateBtnContinue() {
        if (self.tfPass?.text! ?? "").length() >= 6 && self.tfRePass.text!.length() >= 6 {
            self.isEnableContinueButton(isEnable: true)
            self.view.endEditing(true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
    }
    
    //MARK: TextFiled Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
    
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
        if self.tfPass?.text!.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu")
            return
        }

        if (self.tfPass?.text! ?? "").length() < 6 {
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

        if !(self.tfPass?.text! ?? "").contains(self.tfRePass.text!) {
            self.showToastWithMessage(message: "Mật khẩu Không trùng khớp. Vui lòng thử lại.")

            return
        }
        
        switch setPassOrResetPass {
        case .SetPass:
            self.setNewPasswordAPI(newPassword: self.tfPass?.text! ?? "")
            //self.pushToChoiceKindUserVC()
            self.updateNewInfo()
        case .ResetPass:
            self.resetPasswordAPI(newPassword: self.tfPass?.text! ?? "")
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
    
    private func updateNewInfo() {
        APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: self.tfPass?.text! ?? "", accountType: nil)
            .done(on: DispatchQueue.main) { [weak self]data in
                DataManager.shared.userID = data.id!
                //Lay thong tin nguoi dung
                self?.pushToChoiceKindUserVC()
            }
            .catch { error in }
    }
    

    func resetPasswordAPI(newPassword: String) {
        // call to reset password API (update user data)
        
        APIClient.shared.forgetPasswordNewPass(phoneNumber: DataManager.shared.currentAccount, pwd: newPassword)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                guard let code = model.returnCode, code == 1 else {
                    self?.showAlertView(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: nil)
                    return
                }
                
                // sucess -> save phone
                userDefault.set(DataManager.shared.currentAccount, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                
                self?.login(account: DataManager.shared.currentAccount, pass: newPassword)
                
            }
            .catch { model in }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    
    @IBAction func optionAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Trợ giúp", preferredStyle: .actionSheet)
        
        let emailAction = UIAlertAction(title: "Email hỗ trợ: support@mony.vn", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let appDelegate = UIApplication.shared.delegate, let win = appDelegate.window, let _ = win else {
                return
            }
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            // go to email form
        })
        
        let hotLineAction = UIAlertAction(title: "Gọi hotline: \(phoneNumberMony)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let appDelegate = UIApplication.shared.delegate, let win = appDelegate.window, let _ = win else {
                return
            }
            // show call popup
            FinPlusHelper.makeCall(forPhoneNumber: phoneNumberMony)
        })
        
        let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        alertController.view.tintColor = UIColor(hexString: "#08121E")
        alertController.addAction(emailAction)
        alertController.addAction(hotLineAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height - 150, width: 0, height: 150)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

}
