//
//  SetPassAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class SetPassAuthenVC: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet var tfPass: UITextField!
    @IBOutlet var tfRePass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfPass.delegate = self
        self.tfRePass.delegate = self
        
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
            self.showToastWithMessage(message: "Mật khẩu và mật khẩu xác nhận không giống nhau. Vui lòng thử lại!")
            
            return
        }
        
        let choiceKindUser = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "ChoiceKindUserVC") as! ChoiceKindUserVC
        
        choiceKindUser.pw = self.tfPass.text!
        
        self.navigationController?.pushViewController(choiceKindUser, animated: true)
        
    }
    
    
    
}
