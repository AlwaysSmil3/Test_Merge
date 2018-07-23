//
//  BaseAuthenViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BaseAuthenViewController: BaseViewController {
    
    var accountType : AccountType = .Borrower
    @IBOutlet weak var tfPass: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func login(account: String, pass: String) {
        APIClient.shared.authentication(phoneNumber: account, pass: pass)
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
                        
                    }
                    
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
            .done(on: DispatchQueue.main) { [weak self]model in
                guard let strongSelf = self else { return }
                DataManager.shared.browwerInfo = model
                
                strongSelf.pushToHomeVC(accountType: strongSelf.accountType)
                
            }
            .catch { error in
                self.pushToHomeVC(accountType: self.accountType)
        }
    }
    
    func pushToHomeVC(accountType: AccountType) {
        print("Push to user home viewcontroller")
        switch accountType {
        case .None:
            self.pushToChoiceKindUserVC()
        default:
            let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
            
            self.navigationController?.present(tabbarVC, animated: true, completion: {
                
            })
        }
    }
    
    func pushToChoiceKindUserVC() {
        let choiceKindUser = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "ChoiceKindUserVC") as! ChoiceKindUserVC
        choiceKindUser.pw = self.tfPass?.text ?? ""
        self.navigationController?.pushViewController(choiceKindUser, animated: true)
    }
    
    
}
