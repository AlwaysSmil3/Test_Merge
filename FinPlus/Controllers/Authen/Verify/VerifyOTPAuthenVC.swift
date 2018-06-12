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
}
class VerifyOTPAuthenVC: BaseViewController {

    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet var lblLimitTime: UILabel!
    @IBOutlet var pinCodeTextField: PinCodeTextField!
    var verifyType : VerifyType = .Login
    
    var count = 0
    var timer = Timer()
    var otp: String = ""
    
    //Cho Tạo Loan
    var loanResponseModel: LoanResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let phoneNumber = DataManager.shared.currentAccount
            APIClient.shared.verifyOTPAuthen(phoneNumber: phoneNumber, otp: self.otp)
                .done(on: DispatchQueue.main) { [weak self] model in
                    guard let isNew = model.isNew, isNew else {
                        
                        // Nếu là tài khoản củ sang login
                        let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

                        self?.navigationController?.pushViewController(loginVC, animated: true)

                        return
                    }
                    // Nếu là tài khoản mới sang cập nhật thông tin(pass, chon là invest hat broww...)

                    let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
                    updatePassVC.setPassOrResetPass = .SetPass
                    self?.navigationController?.pushViewController(updatePassVC, animated: true)
            }
                .catch { error in}
            break
            
        case .Loan:
            self.verifyOTPLoan()
        
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
