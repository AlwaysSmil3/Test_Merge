//
//  LoanJobInfo.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct LoanJobInfo: Encodable {
    
    var jobType: Int
    var jobTitle: String
    var position: Int
    var positionTitle: String
    var company: String
    var salary: Double
    var companyPhoneNumber: String
    
    var studentId: String
    var strength: Int
    var academicLevel: Int
    var experienceYear: Float
    var academicName: String
    
    
    var jobAddress: Address
    var academicAddress: Address
    
    init() {
        self.jobType = -1
        self.jobTitle = ""
        self.position = -1
        self.positionTitle = ""
        self.company = ""
        self.salary = 0
        self.companyPhoneNumber = ""
        self.jobAddress = Address()
        self.academicAddress = Address()
        
        self.studentId = ""
        self.strength = -1
        self.academicLevel = -1
        self.experienceYear = 0
        self.academicName = ""
        
    }
    
    enum CodingKeys: String, CodingKey {
        case jobType
        case jobTitle
        case position
        case positionTitle
        case company
        case salary
        case companyPhoneNumber
        case jobAddress
        case strength
        case academicLevel
        case experienceYear
        case studentId
        case academicAddress
        case academicName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobType, forKey: .jobType)
        try container.encode(jobTitle, forKey: .jobTitle)
        try container.encode(position, forKey: .position)
        try container.encode(positionTitle, forKey: .positionTitle)
        try container.encode(company, forKey: .company)
        try container.encode(salary, forKey: .salary)
        try container.encode(companyPhoneNumber, forKey: .companyPhoneNumber)
        try container.encode(jobAddress, forKey: .jobAddress)
        try container.encode(academicAddress, forKey: .academicAddress)
    
        try container.encode(strength, forKey: .strength)
        try container.encode(studentId, forKey: .studentId)
        try container.encode(academicName, forKey: .academicName)
        
        try container.encode(academicLevel, forKey: .academicLevel)
        try container.encode(experienceYear, forKey: .experienceYear)
        
        
    }
    
    
}
