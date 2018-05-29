//
//  AddWalletViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/28/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

enum WalletType: Int {
    case Momo = 0
}

protocol WalletDataProtocol {
    func getWalletData(wallet: [Wallet])
}

class AddWalletViewController: BaseViewController {
    
    @IBOutlet var tfWallet: UITextField!
    @IBOutlet var btnWalletType: UIButton!
    @IBOutlet var tfWalletOwnerFullName: UITextField!
    @IBOutlet var tfWalletAccount: UITextField!
    @IBOutlet var tfWalletReAccount: UITextField!
    
    var delegate: WalletDataProtocol?
    var walletType: WalletType = .Momo
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //MAKR
    @IBAction func btnAddWalletTapped(_ sender: Any) {
        
        if self.tfWalletOwnerFullName.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập tên chủ thẻ")
            return
        }
        
        if self.tfWalletAccount.text?.length() == 0 {
            self.showToastWithMessage(message: "Vui lòng nhập số tài khoản")
            return
        }
        
        if self.tfWalletReAccount.text?.length() == 0 {
            self.showToastWithMessage(message: "Số tài khoản nhập lại không trùng nhau")
            return
        }
        
        APIClient.shared.addWallet(walletNumber: self.tfWalletAccount.text!, type: self.walletType.rawValue)
            .then() { [weak self] model -> Void in
                
                self?.delegate?.getWalletData(wallet: model)
                self?.navigationController?.popViewController(animated: true)
            }
            .catch { error in }
        

    }
    
    
    
}
