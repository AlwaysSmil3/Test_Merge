//
//  VerifyOTPAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import PinCodeTextField

enum VerifyType {
    case Login
    case Loan
    case Forgot
    case RegisInvest
    case SignContract
}
class VerifyOTPAuthenVC: BaseViewController {

    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet var lblLimitTime: UILabel!
    @IBOutlet var pinCodeTextField: PinCodeTextField!
    var verifyType : VerifyType = .Login
    var account = ""
    var count = 0
    var timer = Timer()
    var otp: String = ""
    
    //Cho Tạo Loan
    var loanResponseModel: LoanResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        switch verifyType {
//        case .Login:
//            self.descriptionLb.text = "Hãy điền 6 số được gửi kèm tin nhắn được gửi vào số điện thoại của bạn. Thời gian còn lại:"
//            break
//        case .Forgot :
//            self.descriptionLb.text = "Vui lòng nhập mã xác thực gồm 6 chữ số đã được gửi đến số điện thoại của bạn. Thời gian còn lại:"
//            break
//        default:
//            break
//        }
        self.setupPinView()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.timer.invalidate()
    }

    @IBAction func resendCodeBtnAction(_ sender: Any) {
        // call to resend Code API
        print("Resend Code API")
        self.otp = ""
        self.resendCodeBtn.isHidden = true
        count = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func setupPinView() {
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad
        pinCodeTextField.becomeFirstResponder()
        
        let toolbar = UIToolbar()
        let nextButtonItem = UIBarButtonItem(title: NSLocalizedString("Tiếp theo",
                                                                      comment: ""),
                                             style: .done,
                                             target: self,
                                             action: #selector(pinCodeNextAction))
        toolbar.items = [nextButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        pinCodeTextField.inputAccessoryView = toolbar
        resendCodeBtn.isHidden = true
    }
    
    // Update timer
    @objc func updateTimer() {
        guard count <= 59 else {
            self.timer.invalidate()
            resendCodeBtn.isHidden = false
            return
        }
        
        if (60 - count) < 15 {
            //Gần hết time đổi màu
            self.lblLimitTime.textColor = UIColor(red: 255/255, green: 81/255, blue: 88/255, alpha: 1)
        } else {
            self.lblLimitTime.textColor = TEXT_NORMAL_COLOR
        }
        
        count += 1
        self.lblLimitTime.text = "\(60 - self.count) " + "giây"
    }
    
    @objc private func pinCodeNextAction() {
        print("next tapped")
    }
    
    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        switch verifyType {
        case .Login:
            var phoneNumber = ""
            if DataManager.shared.currentAccount != "" {
                phoneNumber = DataManager.shared.currentAccount
            } else if let phone = userDefault.value(forKey: fNEW_ACCOUNT_NAME) as? String {
                phoneNumber = phone
            }
            APIClient.shared.verifyOTPAuthen(phoneNumber: phoneNumber, otp: self.otp)
                .done(on: DispatchQueue.main) { [weak self] model in
                    if model.returnCode != 1 {
                        self?.otp = ""
                        // show alert
                        if let returnMessage = model.returnMsg {
                            self?.showGreenBtnMessage(title: "Verify OTP Failed", message: returnMessage, okTitle: "OK", cancelTitle: nil)
                            return
                        }
                    } else {
                        print(model.data?.isNew)
                        
                        guard let isNew = model.data?.isNew, isNew else {
                            // Nếu là tài khoản cũ -> sang login
                            // save account
                            if self?.account != "" {
                                userDefault.set(self?.account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
                                DataManager.shared.currentAccount = (self?.account)!
                            }
                            self?.pushToLoginVC()
                            return
                        }
                        self?.pushToSetPassword()
                    }
            }
                .catch { error in}
            break
            
        case .SignContract:
            verifyOTPSignContract()
            
            break
        case .Loan:
            self.verifyOTPLoan()
        
            break
        case .RegisInvest:
            print("Register Inves")
            // call to api check OTP
            // success
            // push delegate to invest register to Budget Awards
            let budgetAwardsVC = BudgetAwardsViewController(nibName: "BudgetAwardsViewController", bundle: nil)
//            self.present(budgetAwardsVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(budgetAwardsVC, animated: true)
            break
        default:
            print("Forgot Password Verify")
            let phoneNumber = DataManager.shared.currentAccount
            APIClient.shared.verifyOTPAuthen(phoneNumber: phoneNumber, otp: self.otp)
                .done(on: DispatchQueue.main) { [weak self] model in
                    let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
                    updatePassVC.setPassOrResetPass = .ResetPass
                    self?.navigationController?.pushViewController(updatePassVC, animated: true)
            }
            .catch { error in}
        }

    }
    
    //MARK: Verify sign contract
    func verifyOTPSignContract() {
        guard let loan = self.loanResponseModel else { return }
        APIClient.shared.signContract(otp: self.otp, loanID: loan.loanId!)
        .done(on: DispatchQueue.main) { [weak self] model in
            let vc = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "CONTRACT_SUCCESS")
            self?.navigationController?.isNavigationBarHidden = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        .catch { error in }
    }
    
    func pushToLoginVC() {
        let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    func pushToSetPassword() {
        let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
        updatePassVC.setPassOrResetPass = .SetPass
        self.navigationController?.pushViewController(updatePassVC, animated: true)
    }

}

extension VerifyOTPAuthenVC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        print("value changed: \(value)")
        if value.length() >= 6 {
            self.otp = value
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_enable_login")
            self.btnContinue!.dropShadow(color: MAIN_COLOR)
            self.btnContinue!.isEnabled = true
            self.view.endEditing(true)
            self.btnVerifyTapped(btnContinue!)
        } else {
            self.imgBgBtnContinue!.image = #imageLiteral(resourceName: "bg_button_disable_login")
            self.btnContinue!.dropShadow(color: DISABLE_BUTTON_COLOR)
            self.btnContinue!.isEnabled = false
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
}
