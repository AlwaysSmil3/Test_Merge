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
    
    @IBOutlet weak var viettelPayBtn: UIButton!
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var accTextField: HoshiTextField!
    
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    //CaoHai tra ve du lieu bank khi chon bank
    var delegate: BankDataDelegate?
    
    var wallet: AccountBank?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.accTextField.delegate = self
        self.nameTextField.delegate = self
        
        self.rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        
        vcbBtn.layer.borderWidth = 0.5
        vcbBtn.layer.cornerRadius = 8
        vcbBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        vcbBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        vcbBtn.setTitle(NSLocalizedString("Vietcombank", comment: ""), for: .normal)
        
        viettinBtn.layer.borderWidth = 0.5
        viettinBtn.layer.cornerRadius = 8
        viettinBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        viettinBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        viettinBtn.setTitle(NSLocalizedString("Viettinbank", comment: ""), for: .normal)
        
        techBtn.layer.borderWidth = 0.5
        techBtn.layer.cornerRadius = 8
        techBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        techBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        techBtn.setTitle(NSLocalizedString("Techcombank", comment: ""), for: .normal)
        
        agriBtn.layer.borderWidth = 0.5
        agriBtn.layer.cornerRadius = 8
        agriBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        agriBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        agriBtn.setTitle(NSLocalizedString("Agribank", comment: ""), for: .normal)
        
        viettelPayBtn.layer.borderWidth = 0.5
        viettelPayBtn.layer.cornerRadius = 8
        viettelPayBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        viettelPayBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        viettelPayBtn.setTitle("ViettelPay", for: .normal)
        
        nameTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        nameTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        accTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        accTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        
        self.title = "Thêm tài khoản ngân hàng"
        
        if (wallet != nil)
        {
            self.rightBarBtn.title = "Lưu"
            
            self.leftBarBtn.image = nil
            self.leftBarBtn.tintColor = MAIN_COLOR
            self.leftBarBtn.title = "Huỷ"
            
            self.title = "Sửa thông tin tài khoản"
            nameTextField.text = wallet!.accountBankName
            accTextField.text = wallet!.accountBankNumber
            
            switch(BankName(rawValue: wallet!.bankType!))
            {
            case .Vietcombank?: setBorderColor(button: vcbBtn, isSelect: true)
            case .Viettinbank?: setBorderColor(button: viettinBtn, isSelect: true)
            case .Techcombank?: setBorderColor(button: techBtn, isSelect: true)
            case .Agribank?: setBorderColor(button: agriBtn, isSelect: true)
            case .ViettelPay?: setBorderColor(button: viettelPayBtn, isSelect: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.wallet != nil {
            self.leftBarBtn.tintColor = MAIN_COLOR
        }
    }
    
    func addNewBank() {
        
        if ((self.nameTextField.text?.length())! < 1)
        {
            self.showAlertView(title: "Thông báo", message: "Bạn chưa điền thông tin họ và tên", okTitle: "Đồng ý", cancelTitle: nil)
            self.nameTextField.becomeFirstResponder()
            return
        }
        
        if ((self.accTextField.text?.length())! < 1)
        {
            self.showAlertView(title: "Thông báo", message: "Bạn chưa điền số tài khoản", okTitle: "Đồng ý", cancelTitle: nil)
            self.accTextField.becomeFirstResponder()
            return
        }
        
        if self.accTextField.text!.count < 9 {
            self.showToastWithMessage(message: "Số tài khoản từ 9 -> 15 ký tự")
            self.accTextField.becomeFirstResponder()
            return
        }
        
        
        var bankName = ""
        
        if self.vcbBtn.isSelected {
            bankName = "Vietcombank"
        }
        else if self.viettinBtn.isSelected {
            bankName = "Viettinbank"
        }
        else if self.techBtn.isSelected {
            bankName = "Techcombank"
        }
        else if self.agriBtn.isSelected {
            bankName = "Agribank"
        } else if self.viettelPayBtn.isSelected {
            bankName = "ViettelPay"
        }
        
        let params: JSONDictionary = [
            "type": bankName,
            "accountHolder": self.nameTextField.text!,
            "accountNumber": self.accTextField.text!,
            "branch": "Hai Ba Trung"
        ]
        
        if let wal = self.wallet, let idBank = wal.id {
            self.updateBank(bankId: idBank, params: params)
        } else {
            self.addBank(params: params)
        }
        
    }
    
    private func addBank(params: JSONDictionary) {
        
        APIClient.shared.addNewBank(uId: DataManager.shared.userID, params: params)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                guard let code = model.returnCode, code > 0 else {
                    self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: model.returnMsg ?? "", okTitle: "OK", cancelTitle: nil)
                    return
                }
                self?.showToastWithMessage(message: model.returnMsg ?? "")
                self?.navigationController?.popViewController(animated: true)
            }
            .catch { error in
        }
    }
    
    private func updateBank(bankId: Int32, params: JSONDictionary) {
        APIClient.shared.updateBankAccount(bankAccountID: bankId, params: params)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: "Cancel", completion: { (status) in
                    self?.navigationController?.popToRootViewController(animated: true)
                })

            }
            .catch { error in }
    }
    
    
    //MARK: Actions
    @IBAction func navi_cancel(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_save(sender: UIButton) {
        self.addNewBank()
    }
    
    @IBAction func vcbBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: true)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: false)
        setBorderColor(button: viettelPayBtn, isSelect: false)
    }
    
    @IBAction func viettinBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: true)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: false)
        setBorderColor(button: viettelPayBtn, isSelect: false)
    }
    
    @IBAction func techBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: true)
        setBorderColor(button: agriBtn, isSelect: false)
        setBorderColor(button: viettelPayBtn, isSelect: false)
    }
    
    @IBAction func agriBtn_selected(sender: UIButton)
    {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: true)
        setBorderColor(button: viettelPayBtn, isSelect: false)
    }
    @IBAction func viettelPayBtn_Selected(_ sender: Any) {
        setBorderColor(button: vcbBtn, isSelect: false)
        setBorderColor(button: viettinBtn, isSelect: false)
        setBorderColor(button: techBtn, isSelect: false)
        setBorderColor(button: agriBtn, isSelect: false)
        setBorderColor(button: viettelPayBtn, isSelect: true)
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
            button.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            button.isSelected = false
        }
    }

}

//MARK: TextField Delegate
extension AddWalletViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        var maxLength = 15
        
        if textField == self.nameTextField {
            maxLength = 50
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
}
