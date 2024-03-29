//
//  VerifyFacebookVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/13/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import FBSDKLoginKit

protocol FacebookInfoDelegate {
    func getFacebookInfo(info: FacebookInfo)
}

class VerifyFacebookVC: BaseViewController {
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: TypeAccount?
    var pw: String?
    var delegate: FacebookInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Pasre Facebook Data Info
    private func getFaceBookInfoData(data: FacebookDataType) {
        var accessToken = ""
        var fullName = ""
        var avatar = ""
        let facebookId = ""
        
        if let picture = data["picture"], let data = picture["data"] as? FacebookDataType, let url = data["url"] as? String {
            avatar = url
        }
        
        if let name = data["name"] as? String {
            fullName = name
        }
        
        if AccessToken.current != nil {
            accessToken = AccessToken.current?.tokenString ?? ""
        }
        
        self.faceBookInfo = FacebookInfo(accessToken: accessToken, fullName: fullName, avatar: avatar, facebookId: facebookId)
        
    }
    
    private func facebookSignIn() {
        // Go to Facebook
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                
                if let type = self.accountType, type.rawValue == 1, let info = self.faceBookInfo {
                    //Investor
                    self.delegate?.getFacebookInfo(info: info)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                guard let fbInfo = self.faceBookInfo, let pass = self.pw else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pass, accountType: self.accountType!.rawValue, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName, facebookId: fbInfo.facebookId)
                    .done(on: DispatchQueue.main) { [weak self]data in
                        
                        DataManager.shared.userID = data.id!
                        
                        //Lay thong tin nguoi dung
                        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                            .done(on: DispatchQueue.main) { model in
                                DataManager.shared.browwerInfo = model
                                let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                                self?.navigationController?.present(tabbarVC, animated: true, completion: nil)
                            }
                            .catch { error in }
                    }
                    .catch { error in }
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction func btnConnectFBTapped(_ sender: Any) {
        self.facebookSignIn()
    }
    
}
