//
//  LoginViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import MessageUI

enum AccountType {
    case None
    case Investor
    case Borrower
}

class LoginViewController: BaseAuthenViewController {
    
    @IBOutlet var lblHeaderAccount: UILabel!
    //@IBOutlet var tfPass: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfPass?.delegate = self
        self.tfPass?.keyboardType = .numberPad
        self.updateUI()
        
        if #available(iOS 11.0, *) {
            self.tfPass?.textContentType = .password
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getNotificationSettings()
        self.checkConnectedToNetwork()

        DataManager.shared.getListBank {
            
        }
    }
    
    //Check cai dat notification
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                
                switch settings.authorizationStatus {
                case .authorized:
                    print("Notification authorized")
                case .denied:
                    print("Notification denied")
                    self.showAlertView(title: MS_TITLE_ALERT, message: "Vui lòng vào: Cài đặt > Thông báo -> Mony -> Bật thông báo, để nhận những thông báo mới nhất từ Mony", okTitle: "Huỷ", cancelTitle: "Đồng ý", completion: { (status) in
                        
                        guard !status else {
                            self.tfPass?.becomeFirstResponder()
                            return
                        }
                        DispatchQueue.main.async {
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                        }
                    })
                    
                    return
                case .notDetermined:
                    print("Notification not Determined")
                case .provisional:
                    break
                }
                DispatchQueue.main.async {
                    self.tfPass?.becomeFirstResponder()
                }
            }
        } else {
            // Fallback on earlier versions
            DispatchQueue.main.async {
                self.tfPass?.becomeFirstResponder()
            }
        }
    }
    
    private func updateUI() {
        self.lblHeaderAccount.text = "Xin chào! Vui lòng nhập mật khẩu của bạn để tiếp tục."
        if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            
            DataManager.shared.currentAccount = account
        } else if let account = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
            //self.lblHeaderAccount.text = "Xin chào \(account), vui lòng nhập mật khẩu của bạn để tiếp tục."
            DataManager.shared.currentAccount = account
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    //MARK: Actions
    @IBAction func btnLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
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
        
        alert.addAction(emailAction)
        alert.addAction(hotLineAction)

        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive , handler:{ (UIAlertAction) in
            self.logoutAndSetRootVCIsEnterPhone()
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        alert.view.tintColor = UIColor(hexString: "#08121E")
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: 20, y: 20, width: 64, height: 64)
        }
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func tfEditChanged(_ sender: Any) {
        //guard !FinPlusHelper.checkStatusVersionIsNeedUpdate() else { return }
        
        if let text = self.tfPass?.text, text.length() >= 6 {
            self.isEnableContinueButton(isEnable: true)
            self.view.endEditing(true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
    }
    
    @IBAction func btnHideShowPassTapped(_ sender: Any) {
        self.isShowPass = !self.isShowPass
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        var account = ""
        if let temp = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            account = temp
        } else if let temp = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
            account = temp
        }

        if self.tfPass?.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu để tiếp tục")
            return
        }
        
        self.login(account: account, pass: tfPass?.text! ?? "")
    }
    
    @IBAction func btnForgotPassTapped(_ sender: Any) {
        //guard !FinPlusHelper.checkStatusVersionIsNeedUpdate() else { return }
        // show alert confirm
        if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.self.showGreenBtnMessage(title: "Đặt lại mật khẩu", message: "Mã xác thực sẽ được gửi tới \(account) qua tin nhắn SMS sau khi bạn đồng ý. Bạn chắc chắn không?", okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ", completion: { (status) in
                if (status) {
                    self.pushToVerifyVC(verifyType: .Forgot, account: account)
                }
            })
        }
    }

    func pushToVerifyVC(verifyType: VerifyType, account: String) {
        self.view.endEditing(true)
        APIClient.shared.forgetPassword(phoneNumber: account)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard let code = model.returnCode, code == 1 else {
                    self?.showAlertView(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: nil)
                    return
                }
                
                if #available(iOS 12.0, *) {
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                    verifyVC.verifyType = verifyType
                    verifyVC.account = account
                    self?.navigationController?.pushViewController(verifyVC, animated: true)
                } else {
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVCUnderIOS12") as! VerifyOTPAuthenVCUnderIOS12
                    verifyVC.verifyType = verifyType
                    verifyVC.account = account
                    self?.navigationController?.pushViewController(verifyVC, animated: true)
                }
            }
            .catch { errror in }
    }

    func pushToPhoneVC() {
        self.view.endEditing(true)
        let enterPhoneVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "EnterPhoneNumberAuthenNavi") as! UINavigationController
        self.present(enterPhoneVC, animated: true, completion: nil)
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
