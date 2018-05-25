//
//  LoanJobInfo.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct LoanJobInfo: Encodable {
    
    var jobType: String
    var position: String
    var company: String
    var salary: Int32
    var companyPhoneNumber: String
    
    var address: Address
    
    init() {
        self.jobType = ""
        self.position = ""
        self.company = ""
        self.salary = 0
        self.companyPhoneNumber = ""
        self.address = Address()
        
    }
    
    enum CodingKeys: String, CodingKey {
        case jobType
        case position
        case company
        case salary
        case companyPhoneNumber
        case address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobType, forKey: .jobType)
        try container.encode(position, forKey: .position)
        try container.encode(company, forKey: .company)
        try container.encode(salary, forKey: .salary)
        try container.encode(companyPhoneNumber, forKey: .companyPhoneNumber)
        try container.encode(address, forKey: .address)
        
    }
    
    
}
