//
//  ChangePWViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import TextFieldEffects

class ChangePWViewController: UIViewController {

    @IBOutlet weak var currentPass: HoshiTextField!
    @IBOutlet weak var showCurrentPassBtn: UIButton!
    @IBOutlet weak var newPass: HoshiTextField!
    @IBOutlet weak var showNewPassBtn: UIButton!
    @IBOutlet weak var renewPass: HoshiTextField!
    @IBOutlet weak var showRenewPassBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CHANG_PASSWORD", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
