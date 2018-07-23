//
//  BankAccountTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var methodTitleLb: UILabel!
    @IBOutlet weak var methodDesLb: UILabel!
    @IBOutlet weak var methodImg: UIImageView!
    
    var cellData : PaymentMethod!
    var isSelectedCell = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.containView.layer.borderWidth = 1
        self.containView.layer.cornerRadius = 5
    }
    
    func updateCellView() {
        if let methodType = cellData.methodType {
            switch(MethodType(rawValue: methodType))
            {
            case .CashIn? : self.methodImg.image = #imageLiteral(resourceName: "cashin_payment_img")
            case .ATM?: self.methodImg.image = #imageLiteral(resourceName: "atm_payment_img")
            case .ViettelPay?: self.methodImg.image = #imageLiteral(resourceName: "viettel_payment_img")
            case .none:
                break
            }
        }
        
        
        self.methodTitleLb.text = cellData.methodTitle
        self.methodDesLb.text = cellData.methodDescription
        if isSelectedCell == true {
            self.containView.layer.borderColor = MAIN_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_on")
//            if let bankType = cellData.bankType {
//                switch(BankName(rawValue: bankType))
//                {
//                case .Vietcombank?: self.walletImg.image = #imageLiteral(resourceName: "vcb_selected")
//                case .Viettinbank?: self.walletImg.image = #imageLiteral(resourceName: "viettin_selected")
//                case .Techcombank?: self.walletImg.image = #imageLiteral(resourceName: "tech_selected")
//                case .Agribank?: self.walletImg.image = #imageLiteral(resourceName: "agri_selected")
//                case .none:
//                    break
//                }
//            }
            
            
        } else {
            self.containView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            self.selectImg.image = #imageLiteral(resourceName: "ic_radio_off")
//            if let bankType = cellData.bankType {
//                switch(BankName(rawValue: bankType))
//                {
//                case .Vietcombank?: self.walletImg.image = #imageLiteral(resourceName: "vcb")
//                case .Viettinbank?: self.walletImg.image = #imageLiteral(resourceName: "viettin")
//                case .Techcombank?: self.walletImg.image = #imageLiteral(resourceName: "tech")
//                case .Agribank?: self.walletImg.image = #imageLiteral(resourceName: "agri")
//                case .none:
//                    break
//                }
//            }
        }
        // update cell mode
        self.updateCellMode()
    }
    
    func updateCellMode() {
        if (UserDefaults.standard.bool(forKey: APP_MODE) && UserDefaults.standard.bool(forKey: IS_INVESTOR)) {
            self.methodTitleLb.textColor = DARK_BODY_TEXT_COLOR
            self.methodDesLb.textColor = DARK_SUBTEXT_COLOR
        } else {
            self.methodTitleLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.methodDesLb.textColor = LIGHT_SUBTEXT_COLOR
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
