//
//  RegisInvestViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class RegisInvestViewController: UIViewController, UITextViewDelegate, DataSelectedFromPopupProtocol {

    @IBOutlet weak var acceptTv: UITextView!
    var isAcceptPolicy = false
    var investDetail : DemoLoanModel!
    // @IBOutlet weak var acceptPolicyLb: UILabel!
    @IBOutlet weak var acceptPolicyBtn: UIButton!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var regisBtn: UIButton!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var serviceFeeLb: UILabel!
    @IBOutlet weak var interestAmount: UILabel!
    @IBOutlet weak var interestLb: UILabel!
    @IBOutlet weak var sumAmountLb: UILabel!
    @IBOutlet weak var amountTf: UITextField!
    let unit : Int = 1000000
    var budgetSelected : Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Đăng ký đầu tư"
        containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        let myRange = NSRange(location: 25, length: 17)
        let policyStr : String = "Tôi đã hiểu và đồng ý với hợp đồng đầu tư."
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: policyStr)
        myMutableString.addAttribute(
            NSAttributedStringKey.link,
            value: "more://",
            range: (myMutableString.string as NSString).range(of: "hợp đồng đầu tư."))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "3BAB63"), range: myRange)
        UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "3BAB63")]

        acceptTv.attributedText = myMutableString
        acceptTv.delegate = self
        acceptTv.isSelectable = true
        acceptTv.isEditable = false
        let avaiableAmount = investDetail.amount - (investDetail.alreadyAmount / 100 * investDetail.amount)
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        var avaiableAmountStr = ""
        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = avaiableAmount.toString()
        }
        self.amountTf.text = avaiableAmountStr
        // acceptPolicyLb.attributedText = myMutableString

        // Do any additional setup after loading the view.
    }

    @IBAction func btnDropdownTapped(_ sender: Any) {
//        guard let field_ = self.field, let data = field_.data else { return }
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.titleString = "Số tiền đầu tư"
        let avaiableAmount = investDetail.amount - (investDetail.alreadyAmount / 100 * investDetail.amount)

        if Int(avaiableAmount) > unit {
            let maxUnit = Int(avaiableAmount) / unit
            if maxUnit > 0 {
                var sourceArray = [LoanBuilderData]()
                for index in 1...maxUnit {
                    let avaiableAmount = index * unit
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currency
                    var avaiableAmountStr = ""
                    if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
                        avaiableAmountStr = formattedTipAmount
                    } else {
                        avaiableAmountStr = "\(avaiableAmount)"
                    }
                    let sourceItem = ["id" : index, "title": avaiableAmountStr] as [String : Any]
                    let item : LoanBuilderData = LoanBuilderData(object: sourceItem)
                    sourceArray.append(item)
                }
                popup.setDataSource(data: sourceArray)
            }
        }
        popup.delegate = self
        popup.show()
    }

    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        budgetSelected = Float(unit * Int(data.id!))
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        var avaiableAmountStr = ""
        if let formattedTipAmount = formatter.string(from: budgetSelected as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = budgetSelected.toString()
        }
        self.amountTf.text = avaiableAmountStr
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "more" {
            let investContractVC = InvestContractViewController(nibName: "InvestContractViewController", bundle: nil)
            self.navigationController?.pushViewController(investContractVC, animated: true)
            return false
        }
        else {
            return true
        }
    }

    @IBAction func acceptPolicyBtnAction(_ sender: Any) {
        isAcceptPolicy = !isAcceptPolicy
        if isAcceptPolicy == true {
            self.acceptPolicyBtn.setImage(#imageLiteral(resourceName: "ic_checkbox_checked"), for: .normal)
        } else {
            self.acceptPolicyBtn.setImage(#imageLiteral(resourceName: "ic_accept_policy"), for: .normal)
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
        budgetAwardsVC.budgetAward = budgetSelected

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
