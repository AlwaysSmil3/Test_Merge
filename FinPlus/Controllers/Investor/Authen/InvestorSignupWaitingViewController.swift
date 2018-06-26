//
//  InvestorSignupWaitingViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorSignupWaitingViewController: UIViewController {

    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var turnOnNotiBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileBtn.layer.borderColor = UIColor.white.cgColor

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func showRejectAction(_ sender: Any) {
        let rejectVC = InvestorSignUpRejectedViewController(nibName: "InvestorSignUpRejectedViewController", bundle: nil)
        self.present(rejectVC, animated: true, completion: nil)
    }
    @IBAction func editProfileAction(_ sender: Any) {
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
