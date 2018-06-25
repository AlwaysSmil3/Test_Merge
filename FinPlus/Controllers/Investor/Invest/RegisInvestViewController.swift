//
//  RegisInvestViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class RegisInvestViewController: UIViewController {
    var isAcceptPolicy = false
    @IBOutlet weak var acceptPolicyLb: UILabel!
    @IBOutlet weak var acceptPolicyBtn: UIButton!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var regisBtn: UIButton!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var serviceFeeLb: UILabel!
    @IBOutlet weak var interestAmount: UILabel!
    @IBOutlet weak var interestLb: UILabel!
    @IBOutlet weak var sumAmountLb: UILabel!
    @IBOutlet weak var amountTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Đăng ký đầu tư"
        self.acceptPolicyBtn.layer.cornerRadius = 2
        self.acceptPolicyBtn.layer.borderWidth = 1
        self.acceptPolicyBtn.layer.borderColor = UIColor(hexString: "#B8C9D3").cgColor
        containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        let myRange = NSRange(location: 25, length: 17)
        let policyStr : String = "Tôi đã hiểu và đồng ý với hợp đồng đầu tư."
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "3BAB63"), range: myRange)

        acceptPolicyLb.attributedText = myMutableString

        // Do any additional setup after loading the view.
    }

    @IBAction func acceptPolicyBtnAction(_ sender: Any) {
        isAcceptPolicy = !isAcceptPolicy
        if isAcceptPolicy == true {
            self.acceptPolicyBtn.layer.borderColor = UIColor.clear.cgColor
            self.acceptPolicyBtn.backgroundColor = UIColor(hexString: "#3BAB63")
            self.acceptPolicyBtn.imageView?.image = #imageLiteral(resourceName: "ic_accept_policy_selected")
        } else {
            self.acceptPolicyBtn.layer.borderColor = UIColor(hexString: "#B8C9D3").cgColor
            self.acceptPolicyBtn.backgroundColor = UIColor.clear
            self.acceptPolicyBtn.imageView?.image = nil
        }
    }



    @IBAction func regisBtnAction(_ sender: Any) {
        // push to OTP view controller
        self.view.endEditing(true)
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = .RegisInvest
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }

    func pushToBudgetAwardsVC() {
        let budgetAwardsVC = BudgetAwardsViewController(nibName: "BudgetAwardsViewController", bundle: nil)
        self.navigationController?.pushViewController(budgetAwardsVC, animated: true)
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
