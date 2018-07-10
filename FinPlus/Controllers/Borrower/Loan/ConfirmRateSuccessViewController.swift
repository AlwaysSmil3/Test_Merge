//
//  ConfirmRateSuccessViewController.swift
//  FinPlus
//
//  Created by nghiendv on 22/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ConfirmRateSuccessViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var btnComeHome: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnComeHome.layer.cornerRadius = 8
        self.btnComeHome.layer.masksToBounds = true
        self.btnComeHome.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        
        self.titleLabel.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_BIG)
        self.desLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comHome(_ sender: Any) {
        DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!
                
                //Lay thong tin nguoi dung
                APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.browwerInfo = model
                        
                        let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                        if let window = UIApplication.shared.delegate?.window, let win = window {
                            win.rootViewController = tabbarVC
                        }
                        
                    }
                    .catch { error in
                        
                }
                
            }
            .catch { error in }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
