//
//  EnterPhoneNumberAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
//import JWT


class EnterPhoneNumberAuthenVC: BaseAuthenViewController {
    
    @IBOutlet var tfPhoneNumber: UITextField!
    @IBOutlet var textDescription: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textDescription.delegate = self
        self.tfPhoneNumber.delegate = self
        self.setupUI()
        self.setupTextView()
        
    }
    
    private func setupUI() {
        if let accountName = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.tfPhoneNumber.text = accountName
        }
        
    }
    
    /// Set link cho UITextView
    private func setupTextView() {
        
        let policyStr : String = "Bằng cách ấn nút \"Tiếp tục\" ở trên, tôi đã hiểu và đồng ý với Điều khoản & Điều kiện vay"
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr, attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
        let myRange = (myMutableString.string as NSString).range(of: "Bằng cách ấn nút \"Tiếp tục\" ở trên, tôi đã hiểu và đồng ý với ")
        myMutableString.addAttribute(
            NSAttributedStringKey.link,
            value: "more://",
            range: (myMutableString.string as NSString).range(of: "Điều khoản & Điều kiện vay"))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "#4D6678"), range: myRange)
        
        let string2 = NSMutableAttributedString(string: " của Mony.", attributes: [ NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_REGULAR, size: 11)!,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR])
        
        myMutableString.append(string2)
        
        
        UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "#3EAA5F")]
        
        self.textDescription.attributedText = myMutableString
        
    }
    
    
    //MARK: Actions
    
    @IBAction func tfPhoneNumberEditChanged(_ sender: Any) {
        var phone = self.tfPhoneNumber.text!
        if phone.hasPrefix("0") {
            
        } else {
            phone = "0" + phone
        }
        
        if phone.length() >= 10 {
            self.isEnableContinueButton(isEnable: true)
        } else {
            self.isEnableContinueButton(isEnable: false)
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        var phone = self.tfPhoneNumber.text!
        if phone.hasPrefix("0") {

        } else {
            phone = "0" + phone
        }

        if self.tfPhoneNumber.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số điện thoại để tiếp tục.")
            return
        } else if phone.length() < 10 {
            self.showToastWithMessage(message: "Số điện thoại phải chứa 10 hoặc 11 số. Vui lòng kiểm tra lại.")
            return
        }
        
        if (phone != DataManager.shared.currentAccount || appDelegate.timeCount == 60)
        {
            appDelegate.timeCount = 0
            
            APIClient.shared.authentication(phoneNumber: phone)
                .done(on: DispatchQueue.main) { [weak self]model in
                    guard let strongSelf = self else { return }
                    
                    DataManager.shared.userID = model.data?.id ?? 0
                    DataManager.shared.currentAccount = phone
                    
                    if let type = model.data?.accountType, type == "1" {
                        //Investor
                        self?.confirmGotoAppInvestor()
                        return
                    }
                    
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
                        DataManager.shared.currentAccount = phone
                        
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

                    strongSelf.pushToVerifyVC(verifyType: .Login, phone: phone)
                }.catch { error in
                    print(error)
                }
        }
        else
        {
            self.pushToVerifyVC(verifyType: .Login, phone: phone)
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

extension EnterPhoneNumberAuthenVC: UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "more" {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .termView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        else {
            return true
        }
    }
}
