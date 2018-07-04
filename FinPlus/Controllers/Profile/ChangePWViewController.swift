//
//  ChangePWViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ChangePWViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentPass: HoshiTextField!
    @IBOutlet weak var showCurrentPassBtn: UIButton!
    @IBOutlet weak var newPass: HoshiTextField!
    @IBOutlet weak var showNewPassBtn: UIButton!
    @IBOutlet weak var renewPass: HoshiTextField!
    @IBOutlet weak var showRenewPassBtn: UIButton!
    
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        self.leftBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CHANG_PASSWORD", comment: "")
        
        currentPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        currentPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        newPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        newPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        renewPass.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        renewPass.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_save(sender: UIButton) {
        if (newPass.text == renewPass.text)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            showAlertView(title: "Lỗi", message: "Mật khẩu nhập lại không trùng khớp", okTitle: "Đồng ý", cancelTitle: nil)
        }
    }
    
    @IBAction func showCurrentPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentPass.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func showNewPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPass.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func showRenewPass_action(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        renewPass.isSecureTextEntry = !sender.isSelected
    }
    
    

}
