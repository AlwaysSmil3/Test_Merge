//
//  ProfileViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "cell"
    let headerIdentifier = "header"
    
    let data = [
        [
            "icon": "lock",
            "name": "CHANG_PASSWORD",
        ],
        [
            "icon": "calc",
            "name": "CALCULATE_PAY",
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Setting"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let header: ProfileHeaderView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil)![0] as! ProfileHeaderView
        header.usernameLabel.text = "+84988xxxxxx"
        header.phoneLabel.text = "+84988xxxxxx"
        header.avatarBtn.setBackgroundImage(UIImage(named: "avatar_default"), for: .normal)
        header.delegate = self
        self.tableView.tableHeaderView = header
        self.tableView.tableFooterView = UIView()
        
        let cellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //tableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row] as NSDictionary
        
        var cell: ProfileTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProfileTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProfileTableViewCell
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.icon.image = UIImage(named: (item["icon"] as? String)!)
        cell.nameLabel.text = NSLocalizedString((item["name"] as? String)!, comment: "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CHANG_PASSWORD") as! ChangePWViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CALCULATE_PAY") as! CalPayViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            sendEmail()
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQ") as! FAQViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .termView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .aboutView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
            
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
        
        mailComposerVC.setToRecipients(["support@five9.vn"])
        mailComposerVC.setSubject("Help me")
        mailComposerVC.setMessageBody("Hi Five9,\n", isHTML: false)
        
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
