//
//  RegisInvestViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class RegisInvestViewController: UIViewController, UITextViewDelegate, DataSelectedFromPopupProtocol {

    // title outlet
    @IBOutlet weak var timeTitleLb: UILabel!
    @IBOutlet weak var serviceFeeTitleLb: UILabel!
    @IBOutlet weak var interestAmountTitleLb: UILabel!
    @IBOutlet weak var interestTitleLb: UILabel!
    @IBOutlet weak var sumAmountTitleLb: UILabel!
    @IBOutlet weak var investAmountTitleLb: UILabel!
    @IBOutlet weak var investDetailTitleLb: UILabel!
    @IBOutlet weak var acceptTv: UITextView!
    var isAcceptPolicy = false
    var investDetail : BrowwerActiveLoan!
    var mode = false
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
        var avaiableAmount = 0
        if let temp = investDetail.amount {
            avaiableAmount = Int(temp)
        }


//        let avaiableAmount = investDetail.amount - (investDetail.alreadyAmount / 100 * investDetail.amount)
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        var avaiableAmountStr = ""
        if let formattedTipAmount = formatter.string(from: avaiableAmount as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = "\(avaiableAmount)"
        }
        self.amountTf.text = avaiableAmountStr
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mode = UserDefaults.standard.bool(forKey: APP_MODE)
        setupMode()
    }

    func setupMode() {
        if (self.mode) {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = DARK_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = DARK_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: DARK_BODY_TEXT_COLOR]
            self.view.backgroundColor = DARK_BACKGROUND_COLOR
            // policy text
//            let myRange = NSRange(location: 25, length: 17)
            let policyStr : String = "Tôi đã hiểu và đồng ý với hợp đồng đầu tư."
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: policyStr)
            let myRange = (myMutableString.string as NSString).range(of: "Tôi đã hiểu và đồng ý với")
            myMutableString.addAttribute(
                NSAttributedStringKey.link,
                value: "more://",
                range: (myMutableString.string as NSString).range(of: "hợp đồng đầu tư."))
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: DARK_BODY_TEXT_COLOR, range: myRange)
            UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "3BAB63")]

            acceptTv.attributedText = myMutableString

            self.investAmountTitleLb.textColor = DARK_SUBTEXT_COLOR
            self.amountTf.textColor = DARK_BODY_TEXT_COLOR
            self.investDetailTitleLb.textColor = DARK_SUBTEXT_COLOR
            self.containView.backgroundColor = DARK_BACKGROUND_COLOR
            self.sumAmountTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.sumAmountLb.textColor = DARK_SUBTEXT_COLOR
            self.interestTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.interestLb.textColor = DARK_SUBTEXT_COLOR
            self.interestAmountTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.interestAmount.textColor = DARK_SUBTEXT_COLOR
            self.serviceFeeTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.serviceFeeLb.textColor = DARK_SUBTEXT_COLOR
            self.timeTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.timeLb.textColor = DARK_SUBTEXT_COLOR

        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = LIGHT_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = LIGHT_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: LIGHT_BODY_TEXT_COLOR]
            self.view.backgroundColor = LIGHT_BACKGROUND_COLOR

            let policyStr : String = "Tôi đã hiểu và đồng ý với hợp đồng đầu tư."

            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: policyStr)
            let myRange = (myMutableString.string as NSString).range(of: "Tôi đã hiểu và đồng ý với")
            myMutableString.addAttribute(
                NSAttributedStringKey.link,
                value: "more://",
                range: (myMutableString.string as NSString).range(of: "hợp đồng đầu tư."))
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: LIGHT_BODY_TEXT_COLOR, range: myRange)
            UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexString: "3BAB63")]

            acceptTv.attributedText = myMutableString
            self.investAmountTitleLb.textColor = LIGHT_SUBTEXT_COLOR
            self.amountTf.textColor = LIGHT_BODY_TEXT_COLOR
            self.investDetailTitleLb.textColor = LIGHT_SUBTEXT_COLOR
            self.containView.backgroundColor = LIGHT_BACKGROUND_COLOR
            self.sumAmountTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.sumAmountLb.textColor = LIGHT_SUBTEXT_COLOR
            self.interestTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.interestLb.textColor = LIGHT_SUBTEXT_COLOR
            self.interestAmountTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.interestAmount.textColor = LIGHT_SUBTEXT_COLOR
            self.serviceFeeTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.serviceFeeLb.textColor = LIGHT_SUBTEXT_COLOR
            self.timeTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.timeLb.textColor = LIGHT_SUBTEXT_COLOR
        }
    }

    @IBAction func btnDropdownTapped(_ sender: Any) {
//        guard let field_ = self.field, let data = field_.data else { return }
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.titleString = "Số tiền đầu tư"
        var avaiableAmount = 0
        if let temp = investDetail.amount {
            avaiableAmount = Int(temp)
        }
//        let avaiableAmount = investDetail.amount - (investDetail.alreadyAmount / 100 * investDetail.amount)

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
