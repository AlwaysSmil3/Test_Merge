//
//  DemoLoanModel.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class DemoLoanModel: NSObject {
    var id : Int!
    var reliability : LoanReliability
    var name : String!
    var interestRate : Float = 0
    var amount : Float = 0
    var alreadyAmount : Float = 0
    var dueMonth : Int = 0

    init(id: Int, reliability: LoanReliability, name: String, interestRate: Float, amount: Float, alreadyAmount: Float, dueMonth: Int) {
        self.id = id
        self.reliability = reliability
        self.name = name
        self.interestRate = interestRate
        self.amount = amount
        self.alreadyAmount = alreadyAmount
        self.dueMonth = dueMonth
    }
}
