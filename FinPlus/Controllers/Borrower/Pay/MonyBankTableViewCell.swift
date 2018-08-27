//
//  MonyBankTableViewCell.swift
//  Investor
//
//  Created by Vu Thanh Do on 7/19/18.
//  Copyright © 2018 nghiendv. All rights reserved.
//

import UIKit

class MonyBankAccount {
    var bankType : Int = 0
    var bankNameDetail : String?
    var bankNumber : String?
    var bankUsername : String?
    var amount : Double = 0
    var content : String?
    init() {
        
    }
    init(bankType : Int, bankNameDetail : String, bankNumber: String, bankUsername : String, amount : Double, content : String) {
        self.bankType = bankType
        self.bankNameDetail = bankNameDetail
        self.bankNumber = bankNumber
        self.bankUsername = bankUsername
        self.amount = amount
        self.content = content
    }
}

class MonyBankTableViewCell: UITableViewCell {
    var bankData : MonyBankAccount!
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var bankUsernameLb: UILabel!
    @IBOutlet weak var bankNumber: UILabel!
    @IBOutlet weak var bankNameDetailLb: UILabel!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankNameLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        containView.layer.borderWidth = 1
        containView.layer.cornerRadius = 5
        containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        // Initialization code
    }
    
    func updateCellView() {
        // switch and set bank name by bank type
        
        self.bankNameDetailLb.text = bankData.bankNameDetail
        self.bankNumber.text = bankData.bankNumber
        self.bankUsernameLb.text = bankData.bankUsername
        self.amountLb.text = FinPlusHelper.formatDisplayCurrency(bankData.amount) + "đ"
        self.contentLb.text = bankData.content
        if self.isSelected == true {
            containView.layer.borderColor = UIColor(hexString: "#3BAB63").cgColor
        } else {
            containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Actions
    
    @IBAction func btnCopyBankNameTapped(_ sender: Any) {
        UIPasteboard.general.string = bankData.bankNameDetail
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.showToastWithMessage(message: "Đã copy thông tin ra clipboard.")
    }
    
    @IBAction func btnCopyBankAccountNumberTapped(_ sender: Any) {
        UIPasteboard.general.string = bankData.bankNumber
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.showToastWithMessage(message: "Đã copy thông tin ra clipboard.")
    }
    
    @IBAction func btnCopyBankAccountOwnerNameTapped(_ sender: Any) {
        UIPasteboard.general.string = bankData.bankUsername
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.showToastWithMessage(message: "Đã copy thông tin ra clipboard.")
    }
    
    @IBAction func btnCopyAmountTapped(_ sender: Any) {
        UIPasteboard.general.string = "\(bankData.amount)"
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.showToastWithMessage(message: "Đã copy thông tin ra clipboard.")
    }
    
    @IBAction func btnCopyDescriptionPayTapped(_ sender: Any) {
        UIPasteboard.general.string = bankData.content
        guard let topVC = UIApplication.shared.topViewController() else { return }
        topVC.showToastWithMessage(message: "Đã copy thông tin ra clipboard.")
    }
    
    
    
}
