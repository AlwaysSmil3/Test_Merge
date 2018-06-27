//
//  AddWalletViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var vcbBtn: UIButton!
    @IBOutlet weak var viettinBtn: UIButton!
    @IBOutlet weak var techBtn: UIButton!
    @IBOutlet weak var agriBtn: UIButton!
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var accTextField: HoshiTextField!
    @IBOutlet weak var reAccTextField: HoshiTextField!
    
    var wallet: AccountBank!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vcbBtn.layer.borderWidth = 0.5
        vcbBtn.layer.cornerRadius = 8
        vcbBtn.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        vcbBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        vcbBtn.setTitle(NSLocalizedString("Vietcombank", comment: ""), for: .normal)
        
        viettinBtn.layer.borderWidth = 0.5
        viettinBtn.layer.cornerRadius = 8
        viettinBtn.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        viettinBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        viettinBtn.setTitle(NSLocalizedString("Viettinbank", comment: ""), for: .normal)
        
        techBtn.layer.borderWidth = 0.5
        techBtn.layer.cornerRadius = 8
        techBtn.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        techBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        techBtn.setTitle(NSLocalizedString("Techcombank", comment: ""), for: .normal)
        
        agriBtn.layer.borderWidth = 0.5
        agriBtn.layer.cornerRadius = 8
        agriBtn.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        agriBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        agriBtn.setTitle(NSLocalizedString("Agribank", comment: ""), for: .normal)
        
        nameTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        nameTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
        
        accTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        accTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
        
        reAccTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        reAccTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
        
        self.title = "Thêm tài khoản ngân hàng"
        
        if (wallet != nil)
        {
            self.title = "Sửa tài khoản ngân hàng"
            nameTextField.text = wallet.accountBankName
            accTextField.text = wallet.accountBankNumber
            reAccTextField.text = wallet.district
            
            switch(BankName(rawValue: wallet.bankType!))
            {
            case .Vietcombank?: setBorderColor(button: vcbBtn, isSelect: true)
            case .Viettinbank?: setBorderColor(button: viettinBtn, isSelect: true)
            case .Techcombank?: setBorderColor(button: techBtn, isSelect: true)
            case .Agribank?: setBorderColor(button: agriBtn, isSelect: true)
            case .none:
                break
            }
        }
        else
        {
            self.vcbBtn_selected(sender: self.vcbBtn)
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
    
    @IBAction func vcbBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: true)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: false)
    }
    
    @IBAction func viettinBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: true)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: false)
    }
    
    @IBAction func techBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: true)
        setBorderColor(button: agriBtn, isSelect: false)
    }
    
    @IBAction func agriBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: true)
    }
    
    func setBorderColor(button: UIButton, isSelect: Bool) {
        if (isSelect)
        {
            self.nameTextField.placeholder = "Họ và tên tài khoản \(button.title(for: .normal) ?? "")"
            button.layer.borderColor = MAIN_COLOR.cgColor
            button.isSelected = true
        }
        else
        {
            button.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
            button.isSelected = false
        }
    }

}
