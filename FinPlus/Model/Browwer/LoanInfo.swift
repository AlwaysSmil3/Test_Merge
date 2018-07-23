//
//  LoanInfo.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct LoanInfo: Encodable {
    
    var userID: Int32
    var loanCategoryID: Int16
    var amount: Int32
    var term: Int
    var status: Int
    var currentStep: Int
    
    var userInfo: LoanUserInfo
    var jobInfo: LoanJobInfo
    
    var walletId: Int32
    var bankId: Int
    
    var nationalIdAllImg: String
    var nationalIdFrontImg: String
    var nationalIdBackImg: String
    
    var optionalText: String
    var optionalMedia: [String]
    
    init() {
        
        self.loanCategoryID = 0
        self.amount = 0
        self.term = 0
        self.status = 0
        self.currentStep = 0
        
        self.userInfo = LoanUserInfo()
        self.jobInfo = LoanJobInfo()
        
        self.walletId = 0
        self.bankId = 0
        
        self.nationalIdAllImg = ""
        self.nationalIdFrontImg = ""
        self.nationalIdBackImg = ""
        
        self.optionalText = ""
        self.optionalMedia = []
        self.userID = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case loanCategoryId
        case amount
        case term
        case status
        case currentStep
        case userInfo
        case jobInfo
        case walletId
        case bankId
        case nationalIdAllImg
        case nationalIdFrontImg
        case nationalIdBackImg
        case optionalText
        case optionalMedia
        case userId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(loanCategoryID, forKey: .loanCategoryId)
        try container.encode(amount, forKey: .amount)
        try container.encode(term, forKey: .term)
        try container.encode(status, forKey: .status)
        try container.encode(currentStep, forKey: .currentStep)
        try container.encode(userInfo, forKey: .userInfo)
        try container.encode(jobInfo, forKey: .jobInfo)
        try container.encode(walletId, forKey: .walletId)
        try container.encode(bankId, forKey: .bankId)
        try container.encode(nationalIdAllImg, forKey: .nationalIdAllImg)
        try container.encode(nationalIdFrontImg, forKey: .nationalIdFrontImg)
        try container.encode(nationalIdBackImg, forKey: .nationalIdBackImg)
        try container.encode(optionalText, forKey: .optionalText)
        try container.encode(optionalMedia, forKey: .optionalMedia)
        try container.encode(userID, forKey: .userId)
        
    }
    
    
}

