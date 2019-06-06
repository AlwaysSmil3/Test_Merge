//
//  ChoiceKindUserVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
//import JWT

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
    @IBOutlet var imgGrowth: UIImageView!
    
    
    @IBOutlet var investView: UIView!
    @IBOutlet var imgBgInvest: UIImageView!
    @IBOutlet var lblInvest1: UILabel!
    @IBOutlet var lblInvest2: UILabel!
    @IBOutlet var lblInvest3: UILabel!
    @IBOutlet var imgGrowth1: UIImageView!
    
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    var pw: String = ""
    
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: TypeAccount? {
        didSet {
            self.updateUIForSelectedType()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.browView.dropShadow(color: DROP_SHADOW_COLOR)
        self.browView.layer.cornerRadius = 5
        self.investView.dropShadow(color: DROP_SHADOW_COLOR)
        self.investView.layer.cornerRadius = 5
        
        self.accountType = .Browwer
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
            self.imgGrowth.image = #imageLiteral(resourceName: "ic_growth_selected")
            
            self.imgBgInvest.image = #imageLiteral(resourceName: "img_bg_growth1")
            self.lblInvest1.textColor = UIColor(hexString: "#08121E")
            self.lblInvest2.textColor = UIColor(hexString: "#4D6678")
            self.lblInvest3.textColor = UIColor(hexString: "#3EAA5F")
            self.investView.dropShadow(color: DROP_SHADOW_COLOR)
            self.imgGrowth1.image = #imageLiteral(resourceName: "ic_growth1")
            
        } else {
            self.imgBgBrow.image = #imageLiteral(resourceName: "img_bg_growth1")
            self.lblBrow1.textColor = UIColor(hexString: "#08121E")
            self.lblBrow2.textColor = UIColor(hexString: "#4D6678")
            self.lblBrow3.textColor = UIColor(hexString: "#3EAA5F")
            self.browView.dropShadow(color: DROP_SHADOW_COLOR)
            self.imgGrowth.image = #imageLiteral(resourceName: "ic_growth")
            
            self.imgBgInvest.image = #imageLiteral(resourceName: "img_bg_growth")
            self.lblInvest1.textColor = UIColor.white
            self.lblInvest2.textColor = UIColor.white
            self.lblInvest3.textColor = UIColor.white
            self.investView.dropShadow(color: MAIN_COLOR)
            self.imgGrowth1.image = #imageLiteral(resourceName: "ic_growth1_selected")
        }
    }
    
    private func updateUserInfo() {
        APIClient.shared.updateInfoFromFacebook(phoneNumber: DataManager.shared.currentAccount, pass: pw, accountType: self.accountType!.rawValue)
            .done(on: DispatchQueue.main) { [weak self]data in
                
                DataManager.shared.userID = data.id!
                
                //Lay thong tin nguoi dung
                APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.browwerInfo = model
                        
                        let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                        
                        self?.navigationController?.present(tabbarVC, animated: true, completion: {
                            
                        })
                    }
                    .catch { error in }
                
            }
            .catch { error in
                
        }
        
    }
    
    // MARK Actions
    
    @IBAction func btnInvestorSelectedTapped(_ sender: Any) {

        if self.accountType != .Investor {
            self.accountType = .Investor
        }

        //var mess = "Bạn sẽ được chuyển sang app phiên bản bên cho vay. Bạn có chắc chắn không?"
        self.showGreenBtnMessage(title: "Chuyển app", message: "Phiên bản cho bên cho vay đang được phát triển. Vui lòng thử lại sau.", okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
            if status {
               //self.gotoAppInvestor()
                
            }
        })

    }
    
    
    @IBAction func btnBrowwerSelectedTapped(_ sender: Any) {
        
        if self.accountType == nil {
            self.accountType = .Browwer
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: "Bạn chắc chắn muốn trở thành người vay tiền?", okTitle: "Đồng ý", cancelTitle: "Huỷ bỏ", completion: { (status) in
                if status {
                    self.updateUserInfo()
                    
                }
            })
        }
        
        guard self.accountType != .Browwer else { return }
        self.accountType = .Browwer
    
    }

    
}
