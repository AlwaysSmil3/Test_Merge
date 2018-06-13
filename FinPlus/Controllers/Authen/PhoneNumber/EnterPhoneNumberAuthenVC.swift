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
        if self.tfPhoneNumber.text!.length() >= 10 {
            self.isEnableContinueButton(isEnable: true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        if self.tfPhoneNumber.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại để tiếp tục.")
            return
        } else if (self.tfPhoneNumber.text?.length())! < 10 {
            self.showToastWithMessage(message: "Số điện thoại phải chứa 10 hoặc 11 số. Vui lòng kiểm tra lại.")
            return
        }
        APIClient.shared.authentication(phoneNumber: self.tfPhoneNumber.text!)
            .done(on: DispatchQueue.main) { [weak self]model in
                    print(model)
                if let data = model["data"] as? [String : String] {
                    if let token = data["token"] {
                        userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                    }
                }

                guard let strongSelf = self else { return }

                userDefault.set(strongSelf.tfPhoneNumber.text!, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                userDefault.synchronize()

                DataManager.shared.currentAccount = strongSelf.tfPhoneNumber.text!
                strongSelf.getConfig()
//                let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
//
//                strongSelf.navigationController?.pushViewController(verifyVC, animated: true)
            }.catch { error in
                print(error)
        }
    }
    func getConfig() {
        APIClient.shared.getConfigs().done(on: DispatchQueue.main) { [weak self] model in
            systemConfig = model
            guard let strongSelf = self else { return }

            //            userDefault.set(model, forKey: fSYSTEM_CONFIG)
            strongSelf.pushToVerifyVC(verifyType: .Login)
            }
            .catch({ (error) in
                print(error)
            })
    }

    func pushToVerifyVC(verifyType: VerifyType) {
        self.view.endEditing(true)
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = verifyType
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
}

//MARK: TextField Delegate
extension EnterPhoneNumberAuthenVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
}
