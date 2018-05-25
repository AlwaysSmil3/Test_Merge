//
//  LoanUserInfo.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct LoanUserInfo: Encodable {
    
    var fullName: String
    var gender: String
    
    var birthDay: String
    var nationalID: String
    
    var relationships: [RelationShipPhone]
    var residentAddress: Address
    var temporaryAddress: Address
    
    init() {
        
        self.fullName = ""
        self.gender = "0"
        self.birthDay = ""
        self.nationalID = ""
        self.relationships = []
        
        self.residentAddress = Address()
        self.temporaryAddress = Address()
        
    }
    
    enum CodingKeys: String, CodingKey {
        case fullName
        case gender
        case birthday
        case nationalId
        case relationships
        case residentAddress
        case currentAddress
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(gender, forKey: .gender)
        try container.encode(birthDay, forKey: .birthday)
        try container.encode(nationalID, forKey: .nationalId)
        try container.encode(relationships, forKey: .relationships)
        try container.encode(residentAddress, forKey: .residentAddress)
        try container.encode(temporaryAddress, forKey: .currentAddress)
        
        for phone in relationships {
            
        }
        
    }
    
    
}
