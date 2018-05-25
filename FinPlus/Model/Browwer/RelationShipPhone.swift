//
//  RelationShipPhone.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct RelationShipPhone: Encodable {
    
    var type: Int
    var phoneNumber: String
    
    init() {
        self.type = 0
        self.phoneNumber = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case phoneNumber
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
}

