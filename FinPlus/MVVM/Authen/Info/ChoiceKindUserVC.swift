//
//  ChoiceKindUserVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class ChoiceKindUserVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnGoToFacebookTapped(_ sender: Any) {
        // Go to Facebook
        
        if FBSDKAccessToken.current() != nil {
            
            print("UserID: " + FBSDKAccessToken.current().userID)
            print("AppID: " + FBSDKAccessToken.current().appID)
            print("AccessToken: " + FBSDKAccessToken.current().tokenString)
            
            return
        }
        
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            if error == nil {
                print(data)
                
                
                
            } else {
                print(error)
                
                
                
            }
            
        }
        
    }
    
    
    
}
