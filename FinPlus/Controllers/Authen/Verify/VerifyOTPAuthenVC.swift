//
//  VerifyOTPAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

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
    @IBOutlet var pinCodeTextField: KAPinField!
    
    var verifyType: VerifyType = .Login
    var loanId: Int32!
    var noteId: Int!
    var account = ""
    var timer = Timer()
    var otp = ""
    
    //Cho Tạo Loan  
    var loanResponseModel: LoanResponseModel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPinView()
        appDelegate.timer.invalidate()
        if verifyType != .Login && verifyType != .SignContract && verifyType != .Loan {
            appDelegate.timeCount = 0
        }
        self.lblLimitTime.text = "\(60 - appDelegate.timeCount) " + "giây"
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer.invalidate()
        appDelegate.createTimer()
    }
    
    private func setupPinView() {

        resendCodeBtn.isHidden = true
        // -- Delegation --
        pinCodeTextField.ka_delegate = self
        
        // -- Properties --
        self.refreshPinField()
        
        // -- Styling --
        pinCodeTextField.ka_tokenColor = UIColor.black.withAlphaComponent(0.4)
        pinCodeTextField.ka_textColor = MAIN_COLOR
        pinCodeTextField.ka_font = .menlo(36)
        pinCodeTextField.ka_kerning = 20
        
        // Get focus
        _ = pinCodeTextField.becomeFirstResponder()
    }
    
    func refreshPinField() {
        // Random ka_token and ka_numberOfCharacters
        pinCodeTextField.ka_token = "—"
        pinCodeTextField.ka_numberOfCharacters = 6
        
    }
    
    // Update timer
    @objc func updateTimer() {
        guard appDelegate.timeCount <= 59 else {
            self.timer.invalidate()
            resendCodeBtn.isHidden = false
            return
        }
        
        if 60 - appDelegate.timeCount < 15 {
            //Gần hết time đổi màu
            self.lblLimitTime.textColor = UIColor(red: 255/255, green: 81/255, blue: 88/255, alpha: 1)
        } else {
            self.lblLimitTime.textColor = TEXT_NORMAL_COLOR
        }
        
        appDelegate.timeCount += 1
        self.lblLimitTime.text = "\(60 - appDelegate.timeCount) " + "giây"
    }
    
    //MARK: Resend - Get OTP
    private func updateOTP() {
        self.otp = ""
        //self.pinCodeTextField.
        self.resendCodeBtn.isHidden = true
        appDelegate.timeCount = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.clearOTP()
    }
    
    private func clearOTP() {
        self.pinCodeTextField.ka_text = ""
        self.otp = ""
    }
    
    private func getOTPLoan() {
        APIClient.shared.getLoanOTP(loanID: DataManager.shared.loanID ?? 0)
            .done(on: DispatchQueue.main) { [weak self] model in
                self?.updateOTP()
                
            }
            .catch { error in }
    }
    
    @objc private func pinCodeNextAction() {
        print("next tapped")
    }
    
    @IBAction func resendCodeBtnAction(_ sender: Any) {
        // call to resend Code API
        
        switch verifyType {
        case .Login:
            self.getAuthenOTP()
        case .SignContract:
            self.getSignContractOTP()
        case .Loan:
            self.getOTPLoan()
        case .RegisInvest:
            self.resendInvestCode()
        case .Forgot:
            //Quen mat khau
            self.getOTPForgetPass()
        }
    }
    
    //Gui yeu cau gui lai otp login, register
    private func getAuthenOTP() {
        APIClient.shared.getAuthenOTP()
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.showToastWithMessage(message: "OTP đã được gửi lại thành công.")
                self?.updateOTP()
            }
            .catch { error in }
    }
    
    /// Gui yeu cau gui otp Ky hợp đồng
    private func getSignContractOTP() {
        guard let loanid_ = self.loanId else { return }
        APIClient.shared.getOTPContract(loanID: loanid_)
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.showToastWithMessage(message: "OTP đã được gửi lại thành công.")
                self?.updateOTP()
            }
            .catch { error in }
    }
    
    /// Gửi yêu cầu gửi lại otp phần quên mật khẩu
    private func getOTPForgetPass() {
        APIClient.shared.getForgetPasswordOTP()
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.showToastWithMessage(message: "OTP đã được gửi lại thành công.")
                self?.updateOTP()
            }
            .catch { error in }
    }
    
    func resendInvestCode() {
        if let loanId = self.loanId {
            if let noteId = self.noteId {
                APIClient.shared.investLoanOTP(loanId: loanId, noteId: noteId)
                    .done { (model) in
                        if let returnCode = model.returnCode, returnCode == 1 {
                            self.showGreenBtnMessage(title: "Thành công", message: "OTP đã được gửi lại thành công.", okTitle: "OK", cancelTitle: nil)
                        } else {
                            if let returnMsg = model.returnMsg {
                                self.showGreenBtnMessage(title: "Thất bại", message: returnMsg, okTitle: "OK", cancelTitle: nil)
                            } else {
                                self.showGreenBtnMessage(title: "Thất bại", message: API_MESSAGE.OTHER_ERROR, okTitle: "OK", cancelTitle: nil)
                            }
                        }
                    }
                    .catch { (error) in
                        self.showGreenBtnMessage(title: "Thất bại", message: API_MESSAGE.OTHER_ERROR, okTitle: "OK", cancelTitle: nil)
                }
            }
        }
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
                        let returnMessage = model.returnMsg ?? API_MESSAGE.OTHER_ERROR
                        self?.showGreenBtnMessage(title: "Lỗi", message: returnMessage, okTitle: "Đồng ý", cancelTitle: nil)
                        return
                    } else {
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
                .catch { error in }
        case .SignContract:
            verifyOTPSignContract()
        case .Loan:
            self.verifyOTPLoan()
        case .RegisInvest:
            print("Register Inves")
            // call to api check OTP
            // success
            break
        case .Forgot:
            self.verifyOTPForgotPass()
        }
        
        self.clearOTP()
    }
    
    //MARK: forgot password
    
    private func verifyOTPForgotPass() {
        APIClient.shared.forgetPasswordOTP(phoneNumber: self.account, otp: self.otp)
            .done(on: DispatchQueue.main) { [weak self] model in
                guard let code = model.returnCode, code == 1 else {
                    self?.showAlertView(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: nil)
                    return
                }
                
                DataManager.shared.currentAccount = self?.account ?? ""
                
                let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
                updatePassVC.setPassOrResetPass = .ResetPass
                self?.navigationController?.pushViewController(updatePassVC, animated: true)
            }
            .catch { error in }
    }
    
    //MARK: Verify sign contract
    func verifyOTPSignContract() {
        guard let loanId = self.loanId else { return }
        APIClient.shared.signContract(otp: self.otp, loanID: loanId)
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

//MARK: KAPinFieldDelegate
extension VerifyOTPAuthenVC: KAPinFieldDelegate {
    
    func ka_pinField(_ field: KAPinField, didFinishWith code: String) {
        
        if code.count >= 6 {
            self.otp = code
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
}

/*
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
*/
