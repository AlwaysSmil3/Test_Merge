//
//  ExFloat.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension Float {
    
    func toString() -> String {
        if floor(self) == self {
            return "\(Int(self))"
        } else {
            return String(format: "%.2f", self)
        }
    }
    
    func toLocalCurrencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        var avaiableAmountStr = ""
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            avaiableAmountStr = formattedTipAmount
        } else {
            avaiableAmountStr = self.toString()
        }
        return avaiableAmountStr
    }
}
