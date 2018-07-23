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

        self.tfPhoneNumber.delegate = self
        self.setupUI()
        
    }
    
    private func setupUI() {
        if let accountName = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.tfPhoneNumber.text = accountName
        }
        
    }
    
    
    //MARK: Actions
    
    @IBAction func tfPhoneNumberEditChanged(_ sender: Any) {
        if self.tfPhoneNumber.text!.length() >= 9 {
            self.isEnableContinueButton(isEnable: true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        var phone = self.tfPhoneNumber.text
        if (phone?.hasPrefix("0"))! {

        } else {
            phone = "0" + phone!
        }

        if self.tfPhoneNumber.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại để tiếp tục.")
            return
        } else if (phone?.length())! < 10 {
            self.showToastWithMessage(message: "Số điện thoại phải chứa 10 hoặc 11 số. Vui lòng kiểm tra lại.")
            return
        }
        APIClient.shared.authentication(phoneNumber: phone!)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard let strongSelf = self else { return }
                
                DataManager.shared.userID = model.data?.id ?? 0
                
                switch model.returnCode {
                case 0:
                    // code 0.
                    if let returnMessage = model.returnMsg {
                        self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: returnMessage, okTitle: "OK", cancelTitle: nil)
                        return
                    }
                    break
                default :
                    // new account
                    DataManager.shared.currentAccount = phone!
                    // save token
                    if let data = model.data {
                        if let token = data.accessToken {
                            userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                        }
                    }
                    //Cap nhat push notification token
                    DataManager.shared.updatePushNotificationToken()
                    // get config
                    userDefault.set(phone, forKey: fNEW_ACCOUNT_NAME)
                    break
                }

                strongSelf.pushToVerifyVC(verifyType: .Login, phone: phone!)
            }.catch { error in
                print(error)
        }
    }


    func pushToVerifyVC(verifyType: VerifyType, phone: String) {
        self.view.endEditing(true)
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = verifyType
        verifyVC.account = phone
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }

    func pushToLoginVC() {
        self.view.endEditing(true)
        let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

//MARK: TextField Delegate
extension EnterPhoneNumberAuthenVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
}
