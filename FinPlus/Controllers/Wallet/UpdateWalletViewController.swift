//
//  UpdateWalletViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class UpdateWalletViewController: BaseViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var vcbBtn: UIButton!
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var accTextField: HoshiTextField!
    
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    //CaoHai tra ve du lieu bank khi chon bank
    var delegate: BankDataDelegate?
    
    var wallet: AccountBank?
    
    var walletAction: WalletAction = .WalletDetail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        self.leftBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        
        vcbBtn.layer.borderWidth = 0.5
        vcbBtn.layer.cornerRadius = 8
        vcbBtn.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        vcbBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        vcbBtn.setTitle(NSLocalizedString("Vietcombank", comment: ""), for: .normal)
        
        self.setBorderColor(button: vcbBtn, isSelect: true)
        
        
        nameTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        nameTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        accTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        accTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        
        self.title = "Thêm tài khoản ngân hàng"
        
        if let wallet_ = self.wallet
        {

            nameTextField.text = wallet_.accountBankName
            accTextField.text = wallet_.accountBankNumber
            self.vcbBtn.setTitle(wallet_.bankName, for: UIControlState.normal)
            
            self.setBtnVCB(wallet: wallet_)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func updateBank() {
        
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
        
        
        let bankName = self.wallet?.bankName ?? "Vietcombank"
        
        let params: JSONDictionary = [
            "type": bankName,
            "accountHolder": self.nameTextField.text!,
            "accountNumber": self.accTextField.text!,
            "branch": "Hai Ba Trung"
        ]
        
        if let wal = self.wallet, let idBank = wal.id {
            self.updateBank(bankId: idBank, params: params)
        }
        
    }
    
    private func setBtnVCB(wallet: AccountBank) {
        
        switch(BankName(rawValue: wallet.bankType!))
        {
        case .Vietcombank?:
            self.vcbBtn.setImage(#imageLiteral(resourceName: "vcb_selected"), for: UIControlState.normal)
            self.vcbBtn.setImage(#imageLiteral(resourceName: "vcb_selected"), for: UIControlState.selected)
            
            break
        case .Viettinbank?:
            self.vcbBtn.setImage(#imageLiteral(resourceName: "viettin_selected"), for: UIControlState.normal)
            self.vcbBtn.setImage(#imageLiteral(resourceName: "viettin_selected"), for: UIControlState.selected)
            break
        case .Techcombank?:
            self.vcbBtn.setImage(#imageLiteral(resourceName: "tech_selected"), for: UIControlState.normal)
            self.vcbBtn.setImage(#imageLiteral(resourceName: "tech_selected"), for: UIControlState.selected)
            break
        case .Agribank?:
            self.vcbBtn.setImage(#imageLiteral(resourceName: "agri_selected"), for: UIControlState.normal)
            self.vcbBtn.setImage(#imageLiteral(resourceName: "agri_selected"), for: UIControlState.selected)
            break
        case .ViettelPay?:
            self.vcbBtn.setImage(#imageLiteral(resourceName: "viettelPay_selected"), for: UIControlState.normal)
            self.vcbBtn.setImage(#imageLiteral(resourceName: "viettelPay_selected"), for: UIControlState.selected)
            break
        case .none:
            break
        }
        
        
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

    

    
    private func updateBank(bankId: Int32, params: JSONDictionary) {
        APIClient.shared.updateBankAccount(bankAccountID: bankId, params: params)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                    
                    if self?.walletAction == .LoanNation {
                        self?.navigationController?.popViewController(animated: true)
                        return
                    }
                    
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
        self.updateBank()
    }
    
    
    
    
}
