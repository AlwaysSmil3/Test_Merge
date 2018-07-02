//
//  LoginViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import UIKit

enum AccountType {
    case None
    case Investor
    case Borrower
}
class LoginViewController: BaseViewController {
    
    @IBOutlet var lblHeaderAccount: UILabel!
    @IBOutlet var tfPass: UITextField!
    var accountType : AccountType = .None
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
        } else if let account = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
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
        var account = ""
        if let temp = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            account = temp
        } else if let temp = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
            account = temp
        }

        if self.tfPass.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập mật khẩu để tiếp tục")
            return
        }
        
        APIClient.shared.authentication(phoneNumber: account, pass: tfPass.text!)
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
                        if let accountType = data.accountType {
                            if accountType == "BORROWER" {
                                self?.accountType = .Borrower
                            } else if accountType == "INVESTOR" {
                                self?.accountType = .Investor
                            }
                        }
                    }
                    if self?.accountType == .Investor {
                        UserDefaults.standard.set(true, forKey: IS_INVESTOR)
                    } else {
                        UserDefaults.standard.set(false, forKey: IS_INVESTOR)
                    }
                    // check user type: investor or borrwer
                    // push to home viewcontroller

                    //Cap nhat push notification token
                    self?.getUserInfo()
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
                        if let accountType = data.accountType {
                            if accountType == "BORROWER" {
                                self?.accountType = .Borrower
                            } else if accountType == "INVESTOR" {
                                self?.accountType = .Investor
                            }
                        }
                        if self?.accountType == .Investor {
                            UserDefaults.standard.set(true, forKey: IS_INVESTOR)
                        } else {
                            UserDefaults.standard.set(false, forKey: IS_INVESTOR)
                        }
                        // fix to test
//                        self?.accountType = .None

                    }

                    //Cap nhat push notification token
                    // get config
//                    self?.getConfig()
                    // push to choice viewcontroller

//                    self?.pushToChoiceKindUserVC()
                    self?.getUserInfo()
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
                self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: API_MESSAGE.OTHER_ERROR, okTitle: "OK", cancelTitle: nil)
        }
    }

    func getUserInfo() {
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.browwerInfo = model
                self.pushToHomeVC(accountType: self.accountType)

            }
            .catch { error in
                self.pushToHomeVC(accountType: self.accountType)
        }
    }

    func pushToHomeVC(accountType: AccountType) {
        print("Push to user home viewcontroller")
        switch accountType {
        case .Borrower:
            let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)

            self.navigationController?.present(tabbarVC, animated: true, completion: {

            })
        case .Investor:
            let tabbarVC = InvestorTabBarController(nibName: nil, bundle: nil)

            self.navigationController?.present(tabbarVC, animated: true, completion: {

            })
        default:
            self.pushToChoiceKindUserVC()
        }
    }

    func getConfig() {
        APIClient.shared.getConfigs().done(on: DispatchQueue.main) { [weak self] model in
            systemConfig = model
//            userDefault.set(model, forKey: fSYSTEM_CONFIG)
            // self?.pushToVerifyVC(verifyType: .Login, isExisted: false, account: "")
            }
            .catch({ (error) in
                print(error)
            })
    }

    func pushToChoiceKindUserVC() {
        let choiceKindUser = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "ChoiceKindUserVC") as! ChoiceKindUserVC
            choiceKindUser.pw = self.tfPass.text!
        self.navigationController?.pushViewController(choiceKindUser, animated: true)
    }
    
    @IBAction func btnForgotPassTapped(_ sender: Any) {
        // show alert confirm
        if let account = userDefault.value(forKey: fUSER_DEFAUT_ACCOUNT_NAME) as? String {
            self.self.showGreenBtnMessage(title: "Đặt lại mật khẩu", message: "Mã xác thực sẽ được gửi tới \(account) qua tin nhắn SMS sau khi bạn đồng ý. Bạn chắc chắn không?", okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ", completion: { (status) in
                if (status) {
                    self.pushToVerifyVC(verifyType: .Forgot, isExisted: false, account: "")
                }
            })
        }
    }

    func pushToVerifyVC(verifyType: VerifyType, isExisted : Bool, account: String) {
        self.view.endEditing(true)
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = verifyType
        verifyVC.account = account
        self.navigationController?.pushViewController(verifyVC, animated: true)
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






