//
//  ContactParamsList.swift
//  FinPlus
//
//  Created by Cao Van Hai on 10/4/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct ContactParamsList: Encodable {
    var contacts: [ContactParams]
    
    init() {
        self.contacts = []
    }
    
    enum CodingKeys: String, CodingKey {
        case contacts
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var sizes = container.nestedUnkeyedContainer(forKey: .contacts)
        try contacts.forEach {
            try sizes.encode($0)
        }
    }
}
