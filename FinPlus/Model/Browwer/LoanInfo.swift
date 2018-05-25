//
//  LoanInfo.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct LoanInfo: Encodable {
    
    var loanCategoryID: Int
    var amount: Int32
    var term: Int
    
    var userInfo: LoanUserInfo
    var jobInfo: LoanJobInfo
    
    var walletId: Int
    var nationalIdFrontImg: String
    var nationalIdBackImg: String
    
    var optionalText: String
    var optionalMedia: [String]
    
    init() {
        
        self.loanCategoryID = 0
        self.amount = 0
        self.term = 0
        
        self.userInfo = LoanUserInfo()
        self.jobInfo = LoanJobInfo()
        
        self.walletId = 0
        self.nationalIdFrontImg = ""
        self.nationalIdBackImg = ""
        
        self.optionalText = ""
        self.optionalMedia = []
        
    }
    
    enum CodingKeys: String, CodingKey {
        case loanCategoryId
        case amount
        case term
        case userInfo
        case jobInfo
        case walletId
        case nationalIdFrontImg
        case nationalIdBackImg
        case optionalText
        case optionalMedia
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(loanCategoryID, forKey: .loanCategoryId)
        try container.encode(amount, forKey: .amount)
        try container.encode(term, forKey: .term)
        try container.encode(userInfo, forKey: .userInfo)
        try container.encode(jobInfo, forKey: .jobInfo)
        try container.encode(walletId, forKey: .walletId)
        try container.encode(nationalIdFrontImg, forKey: .nationalIdFrontImg)
        try container.encode(nationalIdBackImg, forKey: .nationalIdBackImg)
        try container.encode(optionalText, forKey: .optionalText)
        try container.encode(optionalMedia, forKey: .optionalMedia)
        
    }
    
    
}

