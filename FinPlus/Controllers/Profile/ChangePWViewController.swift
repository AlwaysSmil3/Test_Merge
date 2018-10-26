//
//  ChangePWViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ChangePWViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentPass: HoshiTextField!
    @IBOutlet weak var showCurrentPassBtn: UIButton!
    @IBOutlet weak var newPass: HoshiTextField!
    @IBOutlet weak var showNewPassBtn: UIButton!
    @IBOutlet weak var renewPass: HoshiTextField!
    @IBOutlet weak var showRenewPassBtn: UIButton!
    
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        self.leftBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CHANG_PASSWORD", comment: "")
        
        currentPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        currentPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        newPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        newPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        renewPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        renewPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        
        if #available(iOS 11.0, *) {
            self.currentPass?.textContentType = .password
            self.newPass?.textContentType = .password
            self.renewPass?.textContentType = .password
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    
    private func changePassword(oldPass: String, newPass: String) {
        
        APIClient.shared.changePassword(oldPass: oldPass, newPass: newPass)
            .done(on: DispatchQueue.main) { [weak self] model in
                
                self?.showToastWithMessage(message: model.returnMsg!)
                
                let account = DataManager.shared.currentAccount
                APIClient.shared.authentication(phoneNumber: account, pass: newPass)
                    .done(on: DispatchQueue.main) { [weak self] model in
                        // go to choice VC of back to enter phone number
                        
                        DataManager.shared.userID = model.data?.id ?? 0
                        
                        switch model.returnCode {
                        case 3:
                            // đang đăng nhập trên 1 thiết bị khác -> push home investor or borrwer
                            userDefault.set(account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                            DataManager.shared.currentAccount = account
                            DataManager.shared.updatePushNotificationToken()
                            if let data = model.data {
                                if let token = data.accessToken {
                                    userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                                }
                                
                            }
                            self?.navigationController?.popToRootViewController(animated: true)
                            
                            break
                        case 1:
                            DataManager.shared.updatePushNotificationToken()
                            userDefault.set(account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                            DataManager.shared.currentAccount = account
                            
                            // save token
                            if let data = model.data {
                                if let token = data.accessToken {
                                    userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                                }
                                
                            }
                            self?.navigationController?.popToRootViewController(animated: true)
                            
                            break
                        default :
                            if let returnMessage = model.returnMsg {
                                self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil)
                                return
                            } else {
                                self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: API_MESSAGE.OTHER_ERROR, okTitle: "OK", cancelTitle: nil)
                            }
                        }
                    }
                    .catch {
                        error in
                        self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: API_MESSAGE.OTHER_ERROR, okTitle: "OK", cancelTitle: nil)
                }
                
            }
            .catch { errror in }
        
        
    }
    
    
    
    
    
    //MARK: Actions
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_save(sender: UIButton) {
        guard let currentPass = self.currentPass.text, currentPass.length() > 0 else {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu hiện tại")
            return
        }
        
        guard let newPass = self.newPass.text, newPass.length() > 0 else {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu hiện tại")
            return
        }
        
        guard let renewPass = self.renewPass.text, renewPass.length() > 0 else {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu hiện tại")
            return
        }
        
        if (newPass == renewPass)
        {
            self.changePassword(oldPass: currentPass, newPass: newPass)
            
        }
        else
        {
            showAlertView(title: "Lỗi", message: "Mật khẩu nhập lại không trùng khớp", okTitle: "Đồng ý", cancelTitle: nil)
        }
    }
    
    @IBAction func showCurrentPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentPass.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func showNewPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPass.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func showRenewPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        renewPass.isSecureTextEntry = !sender.isSelected
    }
    
    

}
