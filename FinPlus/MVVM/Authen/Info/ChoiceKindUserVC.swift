//
//  ChoiceKindUserVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import JWT

// Type User: Investor or Browwer
enum TypeAccount: Int {
    case Browwer = 0
    case Investor
}


class ChoiceKindUserVC: BaseViewController {
    
    
    @IBOutlet var heightConstraintInfoInvestorView: NSLayoutConstraint!
    @IBOutlet var infoInvestorView: UIView!
    
    @IBOutlet var btnFacebook: UIButton!
    
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    var pw: String?
    
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: TypeAccount = .Browwer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Pasre Facebook Data Info
    private func getFaceBookInfoData(data: FacebookDataType) {
        var accessToken = ""
        var fullName = ""
        var avatar = ""
        
        if let picture = data["picture"], let data = picture["data"] as? FacebookDataType, let url = data["url"] as? String {
            avatar = url
        }
        
        if let name = data["name"] as? String {
            fullName = name
        }
        
        if FBSDKAccessToken.current() != nil {
            accessToken = FBSDKAccessToken.current().tokenString
        }
        
        self.faceBookInfo = FacebookInfo(accessToken: accessToken, fullName: fullName, avatar: avatar)
        
    }
    
    // MARK Actions
    
    @IBAction func btnInvestorSelectedTapped(_ sender: Any) {
        
        self.accountType = .Investor
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.heightConstraintInfoInvestorView.constant = 526
            self.view.layoutIfNeeded()
        }) { (status) in
            self.infoInvestorView.isHidden = false
            self.btnFacebook.isHidden = true
        }
    }
    
    @IBAction func btnBrowwerSelectedTapped(_ sender: Any) {
        
        self.accountType = .Browwer
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.heightConstraintInfoInvestorView.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (status) in
            self.infoInvestorView.isHidden = true
            self.btnFacebook.isHidden = false
        })
        
    }
    
    @IBAction func btnGoToFacebookTapped(_ sender: Any) {
        
        // Go to Facebook
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                
                guard let fbInfo = self.faceBookInfo, let pass = self.pw else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pass, accountType: self.accountType.rawValue, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName)
                    .then(on: DispatchQueue.main) { data -> Void in
                        
                        DataManager.shared.userID = data.id!
                        
                        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "BorrowHomeViewController") as! BorrowHomeViewController
                        
                        self.navigationController?.present(homeVC, animated: true, completion: {
                            
                        })
                        
                    }
                    .catch { error in
                        
                }
                
            } else {
                print(error!)
            }
        }
    }
    
}
