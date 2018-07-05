//
//  InvestorSignupWaitingViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorSignupWaitingViewController: UIViewController {

    @IBOutlet weak var nextToTabbarBtn: UIButton!
    @IBOutlet weak var showRejectBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var turnOnNotiBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileBtn.layer.borderColor = UIColor.white.cgColor
        showRejectBtn.layer.borderColor = UIColor.white.cgColor
        nextToTabbarBtn.layer.borderColor = UIColor.white.cgColor

        // Do any additional setup after loading the view.
    }
    @IBAction func nextToTabbarAction(_ sender: Any) {
        let homeVC = UIStoryboard(name: "HomeInvestor", bundle: nil).instantiateViewController(withIdentifier: "InvestorTabBarController")
        self.present(homeVC, animated: true, completion: nil)
//        self.navigationController?.present(homeVC, animated: true, completion: {
//
//        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func showRejectAction(_ sender: Any) {
        let rejectVC = InvestorSignUpRejectedViewController(nibName: "InvestorSignUpRejectedViewController", bundle: nil)
        self.navigationController?.pushViewController(rejectVC, animated: true)
//        self.present(rejectVC, animated: true, completion: nil)
    }
    @IBAction func editProfileAction(_ sender: Any) {
        
//        if let navi = self.navigationController {
//            navi.popViewController(animated: true)
//        } else {
            let registerInvestor = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "RegisterInvestorVC") as! RegisterInvestorVC
            registerInvestor.pw = ""
            registerInvestor.accountType = .Investor
            registerInvestor.isRegisterNew = false
            self.navigationController?.pushViewController(registerInvestor, animated: true)
//            self.present(registerInvestor, animated: true, completion: nil)
//        }
        
    }
    @IBAction func turnOnNotiAction(_ sender: Any) {
        let enableNotiVC = InvestorSignupEnableNotiViewController(nibName: "InvestorSignupEnableNotiViewController", bundle: nil)
        self.present(enableNotiVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
