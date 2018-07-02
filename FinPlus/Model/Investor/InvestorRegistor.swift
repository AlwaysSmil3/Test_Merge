//
//  InvestorRegistor.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/26/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct InvestorRegister {
    
    var title: String?
    var value: String?
    var icon: UIImage?
    var placeHolder: String?
    
}

struct BankModel: Encodable {
    var type: String
    var accountHolder: String
    var accountNumber: String
    var branch: String
    
    init() {
        self.type = ""
        self.accountHolder = ""
        self.accountNumber = ""
        self.branch = ""
        
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case accountHolder
        case accountNumber
        case branch
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(accountHolder, forKey: .accountHolder)
        try container.encode(accountNumber, forKey: .accountNumber)
        try container.encode(branch, forKey: .branch)
        
    }
    
    
}

struct InvestorRegisterModel: Encodable {
    var phoneNumber: String?
    var password: String?
    var accountType: Int
    var accessToken: String?
    var avatar: String?
    var displayName: String?
    var fullname: String?
    var birthday: String?
    var nationalId: String?
    var email: String?
    var residentAddress: Address?
    var bank: BankModel?
    
    init() {
        
        self.phoneNumber = ""
        self.password = ""
        self.accountType = 1
        self.accessToken = ""
        self.avatar = ""
        
        self.displayName = ""
        self.birthday = ""
        
        self.fullname = ""
        self.nationalId = ""
        self.email = ""
        
        self.residentAddress = Address()
        self.bank = BankModel()
        
    }
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case password
        case accountType
        case accessToken
        case avatar
        case displayName
        case birthday
        case fullname
        case nationalId
        case email
        case residentAddress
        case bank
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(password, forKey: .password)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(email, forKey: .email)
        try container.encode(residentAddress, forKey: .residentAddress)
        try container.encode(bank, forKey: .bank)
        
    }
    
    
}
