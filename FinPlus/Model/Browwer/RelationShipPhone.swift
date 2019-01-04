//
//  RelationShipPhone.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct RelationShipPhone: Encodable {
    
    var type: Int16
    var phoneNumber: String
    
    var name: String?
    var address: String?
    
    var loanPurpose: String?
    
    init() {
        self.type = -1
        self.phoneNumber = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case phoneNumber
        case name
        case address
        case loanPurpose
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        
        if let name_ = name {
            try container.encode(name_, forKey: .name)
        }
        
        if let add_ = address {
            try container.encode(add_, forKey: .address)
        }
        
        if let loanPurpose_ = loanPurpose {
            try container.encode(loanPurpose_, forKey: .loanPurpose)
        }
        
    }
    
}

