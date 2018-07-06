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
        var funded : Float = 0
        if let temp = investDetail.funded {
            funded = temp
        }
        var amount : Float = 0
        if let temp = investDetail.amount {
            amount = Float(temp)
        }
        self.budgetSelected = amount - funded
        containView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
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

        self.amountTf.text = self.budgetSelected.toLocalCurrencyFormat()

        var rate : Float = 20
        if let temp = investDetail.inRate {
            rate = temp
        }
       
        self.interestLb.text = "\(rate) %/năm"
        self.calculateInterest()
        
        self.sumAmountLb.text = self.budgetSelected.toLocalCurrencyFormat()
        // Do any additional setup after loading the view.
    }
    
    func calculateInterest() {
        var rate : Float = 20
        if let temp = investDetail.inRate {
            rate = temp
        }
        var interestAmount :Float = 0
        if let loanCategoryId = investDetail.loanCategoryId {
            if loanCategoryId == 1 {
                if let term = investDetail.term {
                    self.timeLb.text = "\(term) ngày"
                    interestAmount = round(self.budgetSelected * rate * Float(term) / 12 / 30 / 100)
                    self.interestAmount.text = interestAmount.toLocalCurrencyFormat()
                    
                }
            } else {
                if let term = investDetail.term {
                    self.timeLb.text = "\(term/30) tháng"
                    interestAmount = round(self.budgetSelected * rate * Float(term) / 12 / 30 / 100)
                    self.interestAmount.text = interestAmount.toLocalCurrencyFormat()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isHidden = self.navigationController?.isNavigationBarHidden, !isHidden {
            self.navigationController?.isNavigationBarHidden = true
        }
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
            self.view.backgroundColor = UIColor.white

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
            self.containView.backgroundColor = UIColor.white
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
        var avaiableAmount : Float = 0
        var amount : Float = 0
        if let temp = investDetail.amount {
            amount = Float(temp)
        }
        var funded : Float = 0
        if let temp = investDetail.funded {
            funded = temp
        }
        avaiableAmount = amount - funded
        if Int(avaiableAmount) > unit {
            let maxUnit = Int(avaiableAmount) / unit
            if maxUnit > 0 {
                var sourceArray = [LoanBuilderData]()
                for index in 1...maxUnit {
                    let nodeAmount = index * unit
                    let sourceItem = ["id" : index, "title": Float(nodeAmount).toLocalCurrencyFormat() + " (\(index)" + " note)"] as [String : Any]
                    let item : LoanBuilderData = LoanBuilderData(object: sourceItem)
                    sourceArray.append(item)
                }
                popup.setDataSource(data: sourceArray)
            }
        }
        popup.delegate = self
        popup.show()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        budgetSelected = Float(unit * Int(data.id!))
        self.amountTf.text = data.title ?? ""
        self.sumAmountLb.text = data.title ?? ""
        self.calculateInterest()

    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "more" {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "WEBVIEW") as! WebViewViewController
            vc.webViewType = .contractView
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
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
        // check accept policy
        if self.isAcceptPolicy == false {
            self.showGreenBtnMessage(title: "Error", message: "You must read and accept with contract before sign.", okTitle: "Ok", cancelTitle: nil)
            return
        }
        // call to invest api
        let note = self.budgetSelected / Float(unit)
        APIClient.shared.investLoan(loanId: investDetail.loanId!, investorId: DataManager.shared.userID, notes: Int32(note))
            .done(on: DispatchQueue.main) { model in
                if let returnCode = model.returnCode, returnCode == 1 {
                    let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
                    verifyVC.verifyType = .RegisInvest
                    verifyVC.loanId = self.investDetail.loanId
                    verifyVC.noteId = model.data?.noteId!
                    self.navigationController?.pushViewController(verifyVC, animated: true)
                } else {
                    if let returnMsg = model.returnMsg, returnMsg != "" {
                        self.showGreenBtnMessage(title: "Đầu tư thất bại", message: returnMsg, okTitle: "Ok", cancelTitle: nil)
                    } else {
                        self.showGreenBtnMessage(title: "Đầu tư thất bại", message: API_MESSAGE.OTHER_ERROR, okTitle: "Ok", cancelTitle: nil)
                    }
                }
            }
            .catch { error in
        }
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
