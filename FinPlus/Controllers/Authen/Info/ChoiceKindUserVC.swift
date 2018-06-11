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
        self.browView.layer.cornerRadius = 5
        self.investView.dropShadow(color: DISABLE_BUTTON_COLOR)
        self.investView.layer.cornerRadius = 5
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
    
    private func facebookSignIn() {
        // Go to Facebook
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                
                guard let fbInfo = self.faceBookInfo, let pass = self.pw else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pass, accountType: self.accountType!.rawValue, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName)
                    .done(on: DispatchQueue.main) { [weak self]data in
                        
                        DataManager.shared.userID = data.id!
                        
                        let homeVC = UIStoryboard(name: "HomeBrowwer", bundle: nil).instantiateViewController(withIdentifier: "BorrowTabbarViewController") as! BorrowTabbarViewController
                        
                        self?.navigationController?.present(homeVC, animated: true, completion: {
                            
                        })
                        
                    }
                    .catch { error in
                        
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    // MARK Actions
    
    @IBAction func btnInvestorSelectedTapped(_ sender: Any) {

        guard self.accountType != .Investor else { return }
        self.accountType = .Investor

        let homeVC = UIStoryboard(name: "HomeInvestor", bundle: nil).instantiateViewController(withIdentifier: "InvestorTabBarController")

        self.navigationController?.present(homeVC, animated: true, completion: {

        })

    }
    
    @IBAction func btnBrowwerSelectedTapped(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showAlertView(title: MS_TITLE_ALERT, message: "Bạn chắc chắn muốn trở thành người vay tiền?. Chúng tôi cần bạn kết nối với facebook để xác thực thông tin cần thiết cho việc đăng ký làm người vay tiền. Chúng tôi sẽ không dùng các thông tin này cho mục đích nào khác.", okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ", completion: { (status) in
                if status {
                    self.facebookSignIn()
                }
            })
        }
        
        guard self.accountType != .Browwer else { return }
        self.accountType = .Browwer
    
    }

    
}
