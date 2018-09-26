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
    var loanCategoryID: Int16 {
        didSet {
            guard self.loanCategoryID > 0 else { return }
            //OptionalText
            if self.optionalText.count < self.initOptionalText(cateId: loanCategoryID).count {
                self.optionalText = self.initOptionalText(cateId: loanCategoryID)
            }
            
            
            //OptionalMedia
            
            if self.optionalMedia.count < self.initOptionalMedia(cateId: loanCategoryID).count  {
                self.optionalMedia = self.initOptionalMedia(cateId: loanCategoryID)
            }
    
        }
    }
    
    
    var intRate: Float
    var amount: Int32
    var term: Int
    var status: Int
    var currentStep: Int
    
    var userInfo: LoanUserInfo
    var jobInfo: LoanJobInfo
    
    var walletId: Int32
    var bankId: Int32
    
    var nationalIdAllImg: String
    var nationalIdFrontImg: String
    var nationalIdBackImg: String
    
    var optionalText: [String]
    var optionalMedia:  [[String]]
    
    var longitudeCreateLoan: Double
    var latitudeCreateLoan: Double
    
    var longitudeAccepted: Double
    var latitudeAccepted: Double
    
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
        
        self.optionalText = []
        
        self.optionalMedia = [[]]
        self.userID = 0
        self.intRate = 0
        
        self.longitudeCreateLoan = 0
        self.latitudeCreateLoan = 0
        
        self.longitudeAccepted = 0
        self.latitudeAccepted = 0
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
        case intRate
        case longitudeCreateLoan
        case latitudeCreateLoan
        case longitudeAccepted
        case latitudeAccepted
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
        try container.encode(intRate, forKey: .intRate)
        
        if status == 0 {
            if self.longitudeCreateLoan > 0 {
                try container.encode(longitudeCreateLoan, forKey: .longitudeCreateLoan)
            }
            
            if self.latitudeCreateLoan > 0 {
                try container.encode(latitudeCreateLoan, forKey: .latitudeCreateLoan)
            }
        } else if status == STATUS_LOAN.RAISING_CAPITAL.rawValue {
            if self.longitudeAccepted > 0 {
                try container.encode(longitudeAccepted, forKey: .longitudeAccepted)
            }
            
            if self.latitudeAccepted > 0 {
                try container.encode(latitudeAccepted, forKey: .latitudeAccepted)
            }
        }
        
        
    }
    
    
    /// init optionalText
    ///
    /// - Parameter cateId: <#cateId description#>
    func initOptionalText(cateId: Int16) -> [String] {
        var value: [String] = []
        for _ in 0...getCountOptionalText(cateId: cateId) - 1 {
            value.append("")
        }
        
        return value
    }
    
    
    /// init optionalMedia
    ///
    /// - Parameter cateId: <#cateId description#>
    func initOptionalMedia(cateId: Int16) -> [[String]] {
        var value: [[String]] = [[]]
        for _ in 0...getCountOptionalMedia(cateId: cateId) - 1 {
            value.append([])
        }
        
        return value
    }

    
    
}

