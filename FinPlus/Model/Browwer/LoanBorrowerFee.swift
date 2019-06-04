//
//  LoanBorrowerFee.swift
//  FinPlus
//
//  Created by AlwaysSmile on 6/4/19.
//  Copyright © 2019 Cao Van Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class LoanBorrowerFee: Mappable {
    var name = ""
    var description = ""
    var value: CGFloat = 0
    var collectTerm = 0
    var unit = "%"
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.name               <- map["name"]
        self.description        <- map["description"]
        self.value              <- map["value"]
        self.collectTerm        <- map["collectTerm"]
        self.unit               <- map["unit"]
    }
}

class ListLoanBorrowerFee: Mappable {
    
    var list: [LoanBorrowerFee] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.list <- map["values"]
    }
}
