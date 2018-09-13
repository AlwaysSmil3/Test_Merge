//
//  BankAccountTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BankAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var accountNumberLb: UILabel!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var walletImg: UIImageView!
    var cellData : AccountBank!
    var isSelectedCell = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
    }

    func updateCellView() {
        if let bankType = cellData.bankType {
            switch(BankName(rawValue: bankType))
            {
            case .Vietcombank?: self.walletImg.image = #imageLiteral(resourceName: "vcb")
            case .Viettinbank?: self.walletImg.image = #imageLiteral(resourceName: "viettin")
            case .Techcombank?: self.walletImg.image = #imageLiteral(resourceName: "tech")
            case .Agribank?: self.walletImg.image = #imageLiteral(resourceName: "agri")
            case .ViettelPay?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
            case .Momo?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
            case .none:
                break
            }
        }
        
        
        self.walletNameLb.text = cellData.bankName
        self.accountNumberLb.text = cellData.accountBankNumber
        if isSelectedCell == true {
            self.containView.layer.borderColor = MAIN_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
            if let bankType = cellData.bankType {
                switch(BankName(rawValue: bankType))
                {
                case .Vietcombank?: self.walletImg.image = #imageLiteral(resourceName: "vcb_selected")
                case .Viettinbank?: self.walletImg.image = #imageLiteral(resourceName: "viettin_selected")
                case .Techcombank?: self.walletImg.image = #imageLiteral(resourceName: "tech_selected")
                case .Agribank?: self.walletImg.image = #imageLiteral(resourceName: "agri_selected")
                case .ViettelPay?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
                case .Momo?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
                case .none:
                    break
                }
            }
                
            
        } else {
            self.containView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")
            if let bankType = cellData.bankType {
                switch(BankName(rawValue: bankType))
                {
                case .Vietcombank?: self.walletImg.image = #imageLiteral(resourceName: "vcb")
                case .Viettinbank?: self.walletImg.image = #imageLiteral(resourceName: "viettin")
                case .Techcombank?: self.walletImg.image = #imageLiteral(resourceName: "tech")
                case .Agribank?: self.walletImg.image = #imageLiteral(resourceName: "agri")
                case .ViettelPay?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
                case .Momo?: self.walletImg.image = #imageLiteral(resourceName: "viettelPay_selected")
                case .none:
                    break
                }
            }
        }
        // update cell mode
        //self.updateCellMode()
    }

//    func updateCellMode() {
//        if (UserDefaults.standard.bool(forKey: APP_MODE) && UserDefaults.standard.bool(forKey: IS_INVESTOR)) {
//            self.walletNameLb.textColor = DARK_BODY_TEXT_COLOR
//            self.accountNumberLb.textColor = DARK_SUBTEXT_COLOR
//        } else {
//            self.walletNameLb.textColor = LIGHT_BODY_TEXT_COLOR
//            self.accountNumberLb.textColor = LIGHT_SUBTEXT_COLOR
//        }
//
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
