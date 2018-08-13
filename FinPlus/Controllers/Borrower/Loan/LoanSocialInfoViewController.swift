//
//  LoanSocialInfoViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/13/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class LoanSocialInfoViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "LoanTypeSocialTBCell", bundle: nil), forCellReuseIdentifier: "LoanTypeSocialTBCell")
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
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
                self.tableView.reloadData()
                
            } else {
                print(error!)
            }
        }
    }
    
    //MARK: Actions
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
        
    }
    
    
    
    
}

extension LoanSocialInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoanTypeSocialTBCell", for: indexPath) as! LoanTypeSocialTBCell
        
        cell.socialData = self.faceBookInfo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.facebookSignIn()
    }
    
    
    
}
