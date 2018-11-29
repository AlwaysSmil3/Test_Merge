//
//  AddWalletNewViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 11/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class AddWalletNewViewController: BaseViewController {
    
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var accTextField: HoshiTextField!

    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var lblBankName: UILabel!
    
    
    //CaoHai tra ve du lieu bank khi chon bank
    weak var delegate: BankDataDelegate?
    var currentIndexSelected: Int?
    var currentBank: Bank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInit()
    
    }
    
    private func setupInit() {
        
        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.accTextField.delegate = self
        self.nameTextField.delegate = self
        
        
        self.rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR], for: .normal)
        
        nameTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        nameTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        accTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        accTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        
        self.title = "Thêm tài khoản ngân hàng"
        
        
    }
    
    func addNewBank() {
        
        guard let bank = self.currentBank else {
            self.showToastWithMessage(message: "Vui lòng chọn ngân hàng")
            return
        }
        
        if ((self.nameTextField.text?.count ?? 0) < 1)
        {
            self.showToastWithMessage(message: "Bạn chưa nhập thông tin họ và tên chủ tài khoản")
            return
        }
        
        if ((self.accTextField.text?.count ?? 0) < 1)
        {
            self.showToastWithMessage(message: "Bạn chưa nhập số tài khoản")
            return
        }
        
        if self.accTextField.text!.count < 9 {
            self.showToastWithMessage(message: "Vui lòng nhập đúng số tài khoản")
            return
        }
        
        
        let bankName = bank.type!
        
        let params: JSONDictionary = [
            "type": bankName,
            "accountHolder": self.nameTextField.text!,
            "accountNumber": self.accTextField.text!,
            "branch": "Hai Ba Trung"
        ]
        
        self.addBank(params: params)
        
    }
    
    private func addBank(params: JSONDictionary) {
        
        APIClient.shared.addNewBank(uId: DataManager.shared.userID, params: params)
            .done(on: DispatchQueue.main) { [weak self]model in
                
                guard let code = model.returnCode, code > 0 else {
                    self?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: model.returnMsg!, okTitle: "OK", cancelTitle: nil)
                    return
                }
                
                if let accountNumber = params["accountNumber"] as? String {
                    self?.delegate?.isReloadBankData(isReload: true, newAccountNumber: accountNumber)
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }
            .catch { error in
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func navi_cancel(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_save(sender: UIButton) {
        self.addNewBank()
    }
    
    @IBAction func btnSelectBankTapped(_ sender: Any) {
        let bankPopup = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "BankPopupViewController") as! BankPopupViewController
        bankPopup.bankSelectedDelegate = self
        if let index = self.currentIndexSelected {
            bankPopup.currentIndex = index
        }
        bankPopup.show {
            //bankPopup.scrollToSelection()
        }
        
    }
    
    
    
    
}

//MARK: BankPopupSelectedProtocol
extension AddWalletNewViewController: BankPopupSelectedProtocol {
    func bankSelected(bank: Bank, index: Int) {
        self.lblBankName?.text = bank.type
        self.currentIndexSelected = index
        self.currentBank = bank
    }
}

//MARK: TextField Delegate
extension AddWalletNewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        var maxLength = 20
        
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

extension AddWalletNewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
