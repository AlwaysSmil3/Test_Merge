//
//  BaseAuthenViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import MessageUI

class BaseAuthenViewController: BaseViewController {
    
    @IBOutlet weak var tfPass: UITextField?
    
    var accountType : AccountType = .Borrower {
        didSet {
            if accountType == .Investor {
                self.confirmGotoAppInvestor()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkConnectedToNetwork() {
        if !FinPlusHelper.isConnectedToNetwork() {
            if DataManager.shared.isCanShowAlertAPIError {
                DataManager.shared.isCanShowAlertAPIError = false
                
                self.showAlertViewNoConnect(title: TITLE_ALERT_ERROR_CONNECTION, message: API_MESSAGE.MONY_MESSEAGE_ERROR, okTitle: "Thử lại", cancelTitle: nil) { (status) in
                    DataManager.shared.isCanShowAlertAPIError = true
                    if FinPlusHelper.isConnectedToNetwork() {
                        self.getLoanCategories {
                            
                        }
                    } else {
                        self.checkConnectedToNetwork()
                    }
                }
            }
        }
    }
    
    func getVersion(completion: @escaping() -> Void) {
        APIClient.shared.getConfigs()
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.config = model
                guard let version = userDefault.value(forKey: fVERSION_CONFIG) as? String else {
                    userDefault.set(model.version!, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                    completion()
                    return
                }
                
                if version == model.version! {
                    //Không cần thay đổi dữ liệu local
                    DataManager.shared.isUpdateFromConfig = false
                } else {
                    userDefault.set(model.version!, forKey: fVERSION_CONFIG)
                    userDefault.synchronize()
                }
                completion()
            }
            .catch { error in
                completion()
        }
    }
    
    func getLoanCategories(completion: @escaping() -> Void) {
        SVProgressHUD.show(withStatus: "Đang lấy dữ liệu hệ thống...")
        APIClient.shared.getLoanCategories()
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanCategories.removeAll()
                DataManager.shared.loanCategories.append(contentsOf: model)
                self.getVersion {
                    SVProgressHUD.dismiss()
                }
            }
            .catch { error in
                SVProgressHUD.dismiss()
                // Get Loan Data from Json
        }
    }
    
    
    func login(account: String, pass: String) {
        if DataManager.shared.config == nil || DataManager.shared.loanCategories.count == 0 {
            if FinPlusHelper.isConnectedToNetwork() {
                self.getLoanCategories {
                    self.handleLogin(account: account, pass: pass)
                }
            } else {
                self.checkConnectedToNetwork()
            }
            return
        }
        self.handleLogin(account: account, pass: pass)
    }
    
    func handleLogin(account: String, pass: String) {
        
        var accountTemp = account
        
        APIClient.shared.authentication(phoneNumber: account, pass: pass)
            .done(on: DispatchQueue.main) { [weak self] model in
                // go to choice VC of back to enter phone number
                if let acc = model.data?.phoneNumber, acc.count > 0 {
                    accountTemp = acc
                }
                
                DataManager.shared.userID = model.data?.id ?? 0
                DataManager.shared.currentAccount = accountTemp
                
                if let type = model.data?.accountType, type == "1" {
                    //Investor
                    self?.confirmGotoAppInvestor()
                    return
                }
                
                switch model.returnCode {
                case 3:
                    // đang đăng nhập trên 1 thiết bị khác -> push home investor or borrwer
                    userDefault.set(accountTemp, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                    userDefault.synchronize()
                    DataManager.shared.currentAccount = accountTemp
                    DataManager.shared.updatePushNotificationToken()
                    
                    //save token
                    if let data = model.data {
                        if let token = data.accessToken {
                            userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                            userDefault.synchronize()
                        }
                        if let accountType = data.accountType {
                            if accountType == UserRole.Investor.rawValue {
                                self?.accountType = .Investor
                                return
                            }
                        }
                    }
                    
                    self?.getUserInfo()
                case 1:
                    DataManager.shared.updatePushNotificationToken()
                    userDefault.set(accountTemp, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                    userDefault.synchronize()
                    DataManager.shared.currentAccount = accountTemp
                    
                    // save token
                    if let data = model.data {
                        if let token = data.accessToken {
                            userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                            userDefault.synchronize()
                        }
                        if let accountType = data.accountType {
                            if accountType == UserRole.Investor.rawValue {
                                self?.accountType = .Investor
                                return
                            }
                        } else {
                            //Chua chọn loại user
                            self?.pushToChoiceKindUserVC()
                            return
                        }
                    }
                    
                    self?.getUserInfo()
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
    
    //Confirm Goto app Investor
    func confirmGotoAppInvestor() {
        /*
        //"Số điện thoại \(DataManager.shared.currentAccount) đã được đăng ký làm bên cho vay, bạn có muốn chuyển sang app cho bên cho vay không?"
 */
        self.showGreenBtnMessage(title: "Khác loại tài khoản", message: "Số điện thoại \(DataManager.shared.currentAccount) đã được đăng ký làm bên cho vay. Phiên bản App cho bên cho vay đang được phát triển. Vui lòng thử lại sau.", okTitle: "Đóng", cancelTitle: nil) { (status) in
            if status {
                //self.gotoAppInvestor()
            }
        }
    }
    
    func pushToHomeVC(accountType: AccountType) {
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
    
    //MARK: Mail config
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Không thể gửi e-mail", message: "Thiết bị của bạn không thể gửi e-mail. Vui lòng kiểm tra lại cài đặt và thử lại.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["support@mony.vn"])
        mailComposerVC.setSubject("[Mony - Hỗ trợ \(DataManager.shared.currentAccount)]")
        mailComposerVC.setMessageBody("Hi Mony,\n", isHTML: false)
        return mailComposerVC
    }
    
}

//MARK: MFMailComposeViewControllerDelegate
extension BaseAuthenViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
