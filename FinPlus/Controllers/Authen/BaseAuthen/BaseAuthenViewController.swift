//
//  BaseAuthenViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BaseAuthenViewController: BaseViewController {
    
    var accountType : AccountType = .Borrower {
        didSet {
            if accountType == .Investor {
                self.confirmGotoAppInvestor()
            }
        }
    }
    
    
    @IBOutlet weak var tfPass: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    func checkConnectedToNetwork() {
        if !FinPlusHelper.isConnectedToNetwork() {
            self.showAlertView(title: "Lỗi kết nối", message: "Ứng dụng này cần có kết nối internet để hoạt động. Vui lòng kiểm tra kết nối internet và thử lại.", okTitle: "Thử lại", cancelTitle: nil) { (status) in
                
                if FinPlusHelper.isConnectedToNetwork() {
                    self.getLoanCategories {
                        
                    }
                } else {
                    self.checkConnectedToNetwork()
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
        APIClient.shared.authentication(phoneNumber: account, pass: pass)
            .done(on: DispatchQueue.main) { [weak self] model in
                // go to choice VC of back to enter phone number
                DataManager.shared.userID = model.data?.id ?? 0
                DataManager.shared.currentAccount = account
                
                if let type = model.data?.accountType, type == "1" {
                    //Investor
                    self?.confirmGotoAppInvestor()
                    return
                }
                
                switch model.returnCode {
                case 3:
                    // đang đăng nhập trên 1 thiết bị khác -> push home investor or borrwer
                    userDefault.set(account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                    DataManager.shared.currentAccount = account
                    DataManager.shared.updatePushNotificationToken()
                    
                    //save token
                    if let data = model.data {
                        if let token = data.accessToken {
                            userDefault.set(token, forKey: fUSER_DEFAUT_TOKEN)
                        }
                        if let accountType = data.accountType {
                            if accountType == UserRole.Investor.rawValue {
                                self?.accountType = .Investor
                                return
                            }
                        }
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
    
    //Confirm Goto app Investor
    func confirmGotoAppInvestor() {
        self.showGreenBtnMessage(title: "Khác loại tài khoản", message: "Số điện thoại \(DataManager.shared.currentAccount) đã được đăng ký làm nhà đầu tư, bạn có muốn chuyển sang app cho nhà đầu tư không?", okTitle: "Chuyển", cancelTitle: "Không") { (status) in
            if status {
                self.gotoAppInvestor()
            }
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
