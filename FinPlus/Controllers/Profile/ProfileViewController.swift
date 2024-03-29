//
//  ProfileViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let cellIdentifier = "cell"
    let headerIdentifier = "header"
    
    let data_borrower = [
        [
            "icon": "lock",
            "name": "CHANG_PASSWORD",
        ],
        [
            "icon": "calc",
            "name": "CALCULATE_PAY",
        ],
        [
            "icon": "hotline",
            "name": "HOTLINE",
        ],
        [
            "icon": "mail",
            "name": "SUPPORT_FROM_FINSMART",
        ],
        [
            "icon": "help",
            "name": "FAQ",
        ],
        [
            "icon": "terms",
            "name": "TERMS_OF_USE",
        ],
        [
            "icon": "info",
            "name": "ABOUT_FINSMART",
        ],
        [
            "icon": "logout",
            "name": "LOGOUT",
        ],
    ]
    
    let data_investor = [
        [
            "icon": "lock",
            "name": "CHANG_PASSWORD",
            ],
        [
            "icon": "account",
            "name": "ACCOUNT_BANK_MANAGER",
            ],
        [
            "icon": "mode",
            "name": "APP_MODE",
            ],
        [
            "icon": "mail",
            "name": "SUPPORT_FROM_FINSMART",
            ],
        [
            "icon": "help",
            "name": "FAQ",
            ],
        [
            "icon": "terms",
            "name": "TERMS_OF_USE",
            ],
        [
            "icon": "info",
            "name": "ABOUT_FINSMART",
            ],
        [
            "icon": "logout",
            "name": "LOGOUT",
            ],
        ]
    
    var data: NSArray!
    var mode = false
    var isInvestor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("BRIEF", comment: "")
        self.data = self.isInvestor ? self.data_investor as NSArray : self.data_borrower as NSArray
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.configTBView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.mode = UserDefaults.standard.bool(forKey: APP_MODE)
        setupMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configTBView() {
        self.tableView.tableFooterView = UIView()
        let cellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
        self.view.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = LIGHT_MODE_NAVI_COLOR
        self.navigationController?.navigationBar.tintColor = LIGHT_MODE_MAIN_TEXT_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: LIGHT_MODE_MAIN_TEXT_COLOR]
    }
    
    func setupMode() {
        guard let bundleNib = Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil), bundleNib.count > 0, let header = bundleNib[0] as? ProfileHeaderView else { return }
        
//        if #available(iOS 10.0, *) {
//
//        } else {
////            let tempRect = header.frame
////            header.frame = CGRect(x: tempRect.origin.x, y: tempRect.origin.y, width: BOUND_SCREEN.size.width, height: tempRect.size.height)
////            header.layoutIfNeeded()
//        }
        
        if let info = DataManager.shared.browwerInfo {
            header.usernameLabel.text = info.fullName ?? info.displayName
            header.phoneLabel.text = info.phoneNumber ?? ""
            header.avatarBtn.sd_setImage(with: URL(string: info.avatar ?? ""), for: .normal, placeholderImage: UIImage(named: "user-default"), options: .fromCacheOnly, completed: nil)
        }
        
        //header.delegate = self
        header.avatarBtn.tintColor = LIGHT_MODE_MAIN_TEXT_COLOR
        header.usernameLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
        header.phoneLabel.textColor = LIGHT_MODE_SUB_TEXT_COLOR
        
        self.tableView.tableHeaderView = header
        self.tableView.reloadData()
    }
    
    //tableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row] as! NSDictionary
        
        var cell: ProfileTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProfileTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProfileTableViewCell
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.icon.image = UIImage(named: (item["icon"] as? String) ?? "")
        cell.nameLabel.text = NSLocalizedString((item["name"] as? String) ?? "", comment: "")
        cell.desLabel.text = ""
        
        if self.mode && self.isInvestor {
            cell.nameLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            cell.desLabel.textColor = DARK_MODE_SUB_TEXT_COLOR
        } else {
            cell.nameLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            cell.desLabel.textColor = LIGHT_MODE_SUB_TEXT_COLOR
        }
        
        if self.isInvestor && indexPath.row == 2 {
            cell.desLabel.text = self.mode ? NSLocalizedString("DARK_MODE", comment: "") : NSLocalizedString("LIGHT_MODE", comment: "")
        }
        
        if indexPath.row + 1 == self.data.count {
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.isNavigationBarHidden = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CHANG_PASSWORD") as! ChangePWViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CALCULATE_PAY") as! CalPayViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            // call to hotline
            FinPlusHelper.makeCall(forPhoneNumber: phoneNumberMony)
        case 3:
            sendEmail()
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQ") as! FAQViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .termView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .aboutView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            //LogOut
            self.showAlertView(title: "Đăng xuất", message: "Bạn có chắc chắn muốn đăng xuất tài khoản này?", okTitle: "Đồng ý", cancelTitle: "Huỷ") { (status) in
                
                if status {
                    APIClient.shared.logOut()
                        .done(on: DispatchQueue.main) { [weak self] model in
                            guard let reponseCode = model.returnCode, reponseCode > 0 else {
                                self?.showToastWithMessage(message: model.returnMsg!)
                                return
                            }
                            self?.logoutAndSetRootVCIsEnterPhone()
                        }
                        .catch { error in }
                }
            }
            
        default:
            break
        }
    }
    
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["support@mony.vn"])
        mailComposerVC.setSubject("[Mony - Hỗ trợ \(DataManager.shared.currentAccount)]")
        mailComposerVC.setMessageBody("Hi Mony,\n", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
//        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ (UIAlertAction) in
//            print("User click Dismiss button")
//        }))
//
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController : ProfileHeaderViewDelegate {
    
    func changeAvatar(_ header: ProfileHeaderView) {
        
    }
    
}
