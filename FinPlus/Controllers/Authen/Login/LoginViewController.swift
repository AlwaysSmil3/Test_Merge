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
        self.tfPass.becomeFirstResponder()

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
            self.isEnableContinueButton(isEnable: true)
            self.view.endEditing(true)
        } else {
            self.isEnableContinueButton(isEnable: true)
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
            .done(on: DispatchQueue.main) { [weak self] model in
                switch model.returnCode {
                case 2:
                    // show messsage, Ok -> verify OTP
                    if let returnMessage = model.returnMsg {
                        self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil, completion: { (true) in
                            self?.pushToVerifyVC(verifyType: .Login)
                        })
                    }
                    break
                case 1:
                    userDefault.set(account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                    DataManager.shared.currentAccount = account
                    // save token
                    if let data = model.data {
                        if let token = data.token {
                            userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                        }
                    }
                    // get config
                    self?.getConfig()
                    break
                default :
                    if let returnMessage = model.returnMsg {
                        self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil)
//                        UIApplication.shared.topViewController()?.showAlertView(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil)
                    }
                }



            }
            .catch { error in }
    }

    func getConfig() {
        APIClient.shared.getConfigs().done(on: DispatchQueue.main) { [weak self] model in
            systemConfig = model
//            userDefault.set(model, forKey: fSYSTEM_CONFIG)
            self?.pushToVerifyVC(verifyType: .Login)
            }
            .catch({ (error) in
                print(error)
            })
    }
    
    @IBAction func btnForgotPassTapped(_ sender: Any) {
        // show alert confirm
        if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.self.showGreenBtnMessage(title: "Đặt lại mật khẩu", message: "Mã xác thực sẽ được gửi tới \(account) qua tin nhắn SMS sau khi bạn đồng ý. Bạn chắc chắn không?", okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ", completion: { (status) in
                if (status) {
                    self.pushToVerifyVC(verifyType: .Forgot)
                }
            })
        }
    }

    func pushToVerifyVC(verifyType: VerifyType) {
        self.view.endEditing(true)
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = verifyType
        self.navigationController?.pushViewController(verifyVC, animated: true)
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






