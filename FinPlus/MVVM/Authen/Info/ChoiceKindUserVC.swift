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


class ChoiceKindUserVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    var pw: String?
    
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: Int = 0
    
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
    
    @IBAction func btnGoToFacebookTapped(_ sender: Any) {
        
        // Go to Facebook
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                
                guard let fbInfo = self.faceBookInfo, let pass = self.pw else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pass, accountType: self.accountType, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName)
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
