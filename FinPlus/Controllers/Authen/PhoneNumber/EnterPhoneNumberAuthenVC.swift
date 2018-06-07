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
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại để tiếp tục")
            return
        }
        
        APIClient.shared.authentication(phoneNumber: self.tfPhoneNumber.text!)
            .done(on: DispatchQueue.main) { [weak self]model in
                if model.returnCode! == 1 {
                    
                    guard let strongSelf = self else { return }
                    
                    userDefault.set(strongSelf.tfPhoneNumber.text!, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                    userDefault.synchronize()
                    
                    DataManager.shared.currentAccount = strongSelf.tfPhoneNumber.text!
                    
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                    
                    strongSelf.navigationController?.pushViewController(verifyVC, animated: true)
                }
            }
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
