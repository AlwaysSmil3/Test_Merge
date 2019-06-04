//
//  ContactParams.swift
//  FinPlus
//
//  Created by Cao Van Hai on 10/4/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct ContactParams: Encodable {
    
    var contactName: String
    var contactPhoneNumber: String
    
    init() {
        self.contactName = ""
        self.contactPhoneNumber = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case contactName
        case contactPhoneNumber
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contactName, forKey: .contactName)
        try container.encode(contactPhoneNumber, forKey: .contactPhoneNumber)
    }
    
}
