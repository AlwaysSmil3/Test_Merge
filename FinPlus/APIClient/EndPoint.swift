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
    static let productURL = "https://bca50ea2-6208-4bdb-bd8a-5e34e2bd4281.mock.pstmn.io/"
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
