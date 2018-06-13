//
//  EndPoint.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

//MARK: Base Host
enum Host {
    static let alphaURL = ""
    // mock
    static let productURL = "https://b10644cc-7d66-4541-aa97-770206b05b43.mock.pstmn.io/"
 //   static let productURL = "http://192.168.104.70:31018/"
}

//MARK: API End Point
enum EndPoint {
    
    enum Authen {
        static let Authen = "auth"
        static let verifyOTP = "auth/otp"

    }
    
    enum User {
        static let User = "users/"
    }
    
    enum Loan {
        static let Loans = "loans"
        static let LoanOTP = "loans/:loanId/otp"
        static let Loan = "loan"
        static let LoanCategories = "loan-categories"
    }
    
    enum Config {
        static let Configs = "configs"
        static let Cities = "cities"
        static let Districts = "districts"
        static let Communes = "communes"
        static let Job = "jobs"
        static let Position = "positions"
    }
    
    enum Wallet {
        static let AddWallet = "users/:uid/wallets"
        
    }
    
    
    
}
