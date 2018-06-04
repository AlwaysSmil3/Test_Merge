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
    
    @IBOutlet var browView: UIView!
    @IBOutlet var imgBgBrow: UIImageView!
    @IBOutlet var lblBrow1: UILabel!
    @IBOutlet var lblBrow2: UILabel!
    @IBOutlet var lblBrow3: UILabel!
    
    @IBOutlet var investView: UIView!
    @IBOutlet var imgBgInvest: UIImageView!
    @IBOutlet var lblInvest1: UILabel!
    @IBOutlet var lblInvest2: UILabel!
    @IBOutlet var lblInvest3: UILabel!

    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    var pw: String?
    
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: TypeAccount? {
        didSet {
            self.updateUIForSelectedType()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.browView.dropShadow(color: DISABLE_BUTTON_COLOR)
        self.investView.dropShadow(color: DISABLE_BUTTON_COLOR)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func updateUIForSelectedType() {
        
        guard let type = self.accountType else { return }
        
        if type.rawValue == 0 {
            self.imgBgBrow.image = #imageLiteral(resourceName: "img_bg_growth")
            self.lblBrow1.textColor = UIColor.white
            self.lblBrow2.textColor = UIColor.white
            self.lblBrow3.textColor = UIColor.white
            self.browView.dropShadow(color: MAIN_COLOR)
            
            self.imgBgInvest.image = #imageLiteral(resourceName: "img_bg_growth1")
            self.lblInvest1.textColor = UIColor(hexString: "#08121E")
            self.lblInvest2.textColor = UIColor(hexString: "#4D6678")
            self.lblInvest3.textColor = UIColor(hexString: "#3EAA5F")
            self.investView.dropShadow(color: DISABLE_BUTTON_COLOR)
            
            
        } else {
            self.imgBgBrow.image = #imageLiteral(resourceName: "img_bg_growth1")
            self.lblBrow1.textColor = UIColor(hexString: "#08121E")
            self.lblBrow2.textColor = UIColor(hexString: "#4D6678")
            self.lblBrow3.textColor = UIColor(hexString: "#3EAA5F")
            self.browView.dropShadow(color: DISABLE_BUTTON_COLOR)
            
            self.imgBgInvest.image = #imageLiteral(resourceName: "img_bg_growth")
            self.lblInvest1.textColor = UIColor.white
            self.lblInvest2.textColor = UIColor.white
            self.lblInvest3.textColor = UIColor.white
            self.investView.dropShadow(color: MAIN_COLOR)
        }
        
        
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
    
    private func updateViewForBrowwer() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.heightConstraintInfoInvestorView.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (status) in
            self.infoInvestorView.isHidden = true
            self.btnFacebook.isHidden = false
        })
    }
    
    // MARK Actions
    
    @IBAction func btnInvestorSelectedTapped(_ sender: Any) {
        
        guard self.accountType != .Investor else { return }
        self.accountType = .Investor

    }
    
    @IBAction func btnBrowwerSelectedTapped(_ sender: Any) {
        
        guard self.accountType != .Browwer else { return }
        self.accountType = .Browwer
    
    }
    
    @IBAction func btnGoToFacebookTapped(_ sender: Any) {
        
        // Go to Facebook
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                
                guard let fbInfo = self.faceBookInfo, let pass = self.pw else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pass, accountType: self.accountType!.rawValue, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName)
                    .then(on: DispatchQueue.main) { data -> Void in
                        
                        DataManager.shared.userID = data.id!
                        
                        let homeVC = UIStoryboard(name: "HomeBrowwer", bundle: nil).instantiateViewController(withIdentifier: "BorrowTabbarViewController") as! BorrowTabbarViewController
                        
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
