//
//  AddWalletViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddWalletViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var momoBtn: UIButton!
    @IBOutlet weak var paypalBtn: UIButton!
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var accTextField: HoshiTextField!
    @IBOutlet weak var reAccTextField: HoshiTextField!
    
    var wallet: Wallet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        momoBtn.layer.borderWidth = 0.5
        momoBtn.layer.cornerRadius = 8
        momoBtn.layer.borderColor = MAIN_COLOR.cgColor
        momoBtn.setTitle(NSLocalizedString("MOMO_WALLET", comment: ""), for: .normal)
        
        paypalBtn.layer.borderWidth = 0.5
        paypalBtn.layer.cornerRadius = 8
        paypalBtn.layer.borderColor = MAIN_COLOR.cgColor
        paypalBtn.setTitle(NSLocalizedString("PAYPAL_ACCOUNT", comment: ""), for: .normal)
        
        self.title = "Thêm ví"
        
        if ((wallet) != nil)
        {
            self.title = "Sửa thông tin ví"
            nameTextField.text = wallet.walletAccountName
            accTextField.text = wallet.walletNumber
            reAccTextField.text = wallet.walletNumber
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_cancel(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_save(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
