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
    
    var relationships: [RelationShipPhone] {
        didSet {
            if relationships.count > 1, relationships[0].type > -1, relationships[1].type > -1, relationships[0].type > relationships[1].type {
                self.relationships.reverse()
            }
        }
    }
    var residentAddress: Address
    var temporaryAddress: Address
    
    var typeMobilePhone: Int?
    var typeMobilePhoneTitle: String?
    var phoneUsageTime: Int?
    
    init() {
        
        self.fullName = ""
        self.gender = ""
        self.birthDay = ""
        self.nationalID = ""
        self.relationships = [RelationShipPhone(), RelationShipPhone()]
        
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
        case typeMobilePhone
        case typeMobilePhoneTitle
        case phoneUsageTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(gender, forKey: .gender)
        try container.encode(birthDay, forKey: .birthday)
        try container.encode(nationalID, forKey: .nationalId)
        //try container.encode(relationships, forKey: .relationships)
        try container.encode(residentAddress, forKey: .residentAddress)
        try container.encode(temporaryAddress, forKey: .currentAddress)
        
        var sizes = container.nestedUnkeyedContainer(forKey: .relationships)
        try relationships.forEach {
            try sizes.encode($0)
        }
        
        if let type_ = self.typeMobilePhone {
            try container.encode(type_, forKey: .typeMobilePhone)
        }
        
        if let type_ = self.typeMobilePhoneTitle {
            try container.encode(type_, forKey: .typeMobilePhoneTitle)
        }
        
        if let useTime = self.phoneUsageTime {
            try container.encode(useTime, forKey: .phoneUsageTime)
        }
        
    }
    
    
}
