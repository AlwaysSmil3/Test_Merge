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
class SetPassAuthenVC: BaseAuthenViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    var phone : String!
    var setPassOrResetPass: SetPassOrResetPass = SetPassOrResetPass.SetPass
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tfRePass: UITextField!
    
    @IBOutlet var btnHideShowPass: UIButton!
    var isShowPass: Bool = false {
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
            //if let account = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
            self.lblHeader.text = "Xin chào! Bạn chưa có tài khoản. Vui lòng thiết lập mật khẩu để bắt đầu."
            //}
            break
        case .ResetPass:
            self.lblTitle.text = "Thiết lập mật khẩu mới"
            if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
                self.lblHeader.text = "Xin chào \(account), bạn đã yêu cầu đặt lại mật khẩu. Vui lòng tạo mật khẩu mới."
            }
            break
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
            break
        case .ResetPass:
            self.resetPasswordAPI(newPassword: self.tfPass?.text! ?? "")
            break

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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@mony.vn"])
        mailComposerVC.setSubject("[Mony - Hỗ trợ \(DataManager.shared.currentAccount)]")
        mailComposerVC.setMessageBody("Hi Mony,\n", isHTML: false)
        
        return mailComposerVC
    }
    
    @IBAction func optionAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Trợ giúp", preferredStyle: .actionSheet)
        
        let emailAction = UIAlertAction(title: "Email hỗ trợ: support@mony.vn", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let appDelegate = UIApplication.shared.delegate, let win = appDelegate.window, let window = win else {
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
        
        let hotLineAction = UIAlertAction(title: "Gọi hotline: 1900 232 389", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let appDelegate = UIApplication.shared.delegate, let win = appDelegate.window, let window = win else {
                return
            }
            // show call popup
            let phoneNumber = "1900232389"
            guard let number = URL(string: "tel://" + phoneNumber) else {
                return
            }
            UIApplication.shared.openURL(number)
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
        
        //        if UserIdiom == .pad
        //        {
        //            if let currentPopoverpresentioncontroller = alertController.popoverPresentationController{
        //                currentPopoverpresentioncontroller.sourceView = self.btnContinue
        //                currentPopoverpresentioncontroller.sourceRect = self.btnContinue!.bounds;
        //                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up;
        //                self.present(alertController, animated: true, completion: nil)
        //            }
        //        } else {
        //            self.present(alertController, animated: true, completion: nil)
        //        }
        
        //        if let popoverController = alertController.popoverPresentationController {
        //            popoverController.sourceView = self.view
        //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        //        }
        //
        //        self.present(alertController, animated: true, completion: nil)
        
        //        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        //        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive , handler:{ (UIAlertAction)in
        //        guard let appDelegate = UIApplication.shared.delegate, let win = appDelegate.window, let window = win else {
        //                return
        //            }
        //            //Clear Data and Login
        //            DataManager.shared.clearData {
        //                let enterPhoneVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumberAuthenNavi") as! UINavigationController
        //                window.rootViewController = enterPhoneVC
        //            }
        //
        //        }))
        //
        //        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
        //            print("User click Dismiss button")
        //        }))
        //        alert.view.tintColor = UIColor(hexString: "#08121E")
        //        self.present(alert, animated: true, completion: {
        //            print("completion block")
        //        })
    }


}
