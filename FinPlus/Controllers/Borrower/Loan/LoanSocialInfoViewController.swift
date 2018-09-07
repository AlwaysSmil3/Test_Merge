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
        self.tableView.register(UINib(nibName: "LoanTypeFooterTBView", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Footer)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        self.updateDataLoan()
        
    }
    
    // Pasre Facebook Data Info
    private func getFaceBookInfoData(data: FacebookDataType) {
        var accessToken = ""
        var fullName = ""
        var avatar = ""
        var facebookId = ""
        
        if let id = data["id"] as? String {
            facebookId = id
        }
        
        if let picture = data["picture"], let data = picture["data"] as? FacebookDataType, let url = data["url"] as? String {
            avatar = url
        }
        
        if let name = data["name"] as? String {
            fullName = name
        }
        
        if FBSDKAccessToken.current() != nil {
            accessToken = FBSDKAccessToken.current().tokenString
        }
        
        self.faceBookInfo = FacebookInfo(accessToken: accessToken, fullName: fullName, avatar: avatar, facebookId: facebookId)
        
    }
    
    private func facebookSignIn() {
        // Go to Facebook
        self.handleLoadingView(isShow: true)
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (data, error) in
            self.handleLoadingView(isShow: false)
            if error == nil {
                guard let data = data else { return }
                self.getFaceBookInfoData(data: data)
                self.tableView.reloadData()
                
                guard let fbInfo = self.faceBookInfo else { return }
                
                APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, accessToken: fbInfo.accessToken, avatar: fbInfo.avatar, displayName: fbInfo.fullName, facebookId: fbInfo.facebookId)
                    .done(on: DispatchQueue.main) { data in
                        
                        DataManager.shared.userID = data.id!

                        //Lay thong tin nguoi dung
                        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                            .done(on: DispatchQueue.main) { model in
                                DataManager.shared.browwerInfo = model
                            }
                            .catch { error in }
                        
                    }
                    .catch { error in
                        
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    private func updateDataLoan() {
        DataManager.shared.loanInfo.currentStep = 5
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                
            }
            .catch { error in }
    }
    
    //MARK: Actions
    @IBAction func btnContinueTapped(_ sender: Any) {
        guard let _ = self.faceBookInfo else {
            self.showAlertView(title: MS_TITLE_ALERT, message: "Vui lòng nhập thông tin Facebook của bạn", okTitle: "OK", cancelTitle: nil)
            return
        }
        
        let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
        
        self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
        
    }
    
    
    
    
}

extension LoanSocialInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoanTypeSocialTBCell", for: indexPath) as! LoanTypeSocialTBCell
            
            cell.socialData = self.faceBookInfo
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.Footer, for: indexPath) as! LoanTypeFooterTBView
        
        cell.lblDesciption?.text = "Chúng tôi cam kết không sử dụng các thông tin Facebook của bạn vào mục đích gì khác ngoài việc xác thực thông tin cá nhân."
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.faceBookInfo == nil {
            self.facebookSignIn()
        }
    }
    
    
    
}
