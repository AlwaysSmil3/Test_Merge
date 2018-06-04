//
//  VerifyOTPAuthenVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import PinCodeTextField


class VerifyOTPAuthenVC: BaseViewController {
    
    @IBOutlet var lblLimitTime: UILabel!
    @IBOutlet var pinCodeTextField: PinCodeTextField!
    
    
    var count = 0
    var timer = Timer()
    var otp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPinView()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.timer.invalidate()
    }
    
    private func setupPinView() {
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .numberPad
        
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
    }
    
    // Update timer
    @objc func updateTimer() {
        guard count <= 59 else {
            self.timer.invalidate()
            
            return
        }
        
        if (60 - count) < 15 {
            //Gần hết time đổi màu
            self.lblLimitTime.textColor = UIColor(red: 255/255, green: 81/255, blue: 88/255, alpha: 1)
        }
        
        count += 1
        self.lblLimitTime.text = "\(60 - self.count) " + "giây"
    }
    
    @objc private func pinCodeNextAction() {
        print("next tapped")
    }

    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        
        let phoneNumber = DataManager.shared.currentAccount
        
        APIClient.shared.verifyOTPAuthen(phoneNumber: phoneNumber, otp: self.otp)
            .then(on: DispatchQueue.main) { model -> Void in
                guard let isNew = model.isNew, isNew else {
                    // Nếu là tài khoản củ sang login
                    let loginVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    
                    return
                }
                // Nếu là tài khoản mới sang cập nhật thông tin(pass, chon là invest hat broww...)
                
                let updatePassVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "SetPassAuthenVC") as! SetPassAuthenVC
                
                self.navigationController?.pushViewController(updatePassVC, animated: true)
                
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
