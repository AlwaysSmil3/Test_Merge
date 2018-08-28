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

    static let productURL = "https://gateway.mony.vn/"
//    static let productURL = "https://dev-api.mony.vn/"
}

//MARK: API End Point
enum EndPoint {

    // for investor
    enum Invest {
        static let Invests = ""
    }
    
    enum Authen {
        static let Authen = "auth"
        static let verifyOTP = "auth/otp"
        static let Logout = "logout"
        static let resendOTPAuthen = "auth/otp?phoneNumber="
        
    }
    
    enum User {
        static let User = "users/"
        static let PushToken = "users/uid/push-token"
        static let ForgetPassword = "users/forget-password"
        static let ForgetPasswordOTP    = "users/forget-password/otp"
        static let ForgetPasswordNewPass = "users/forget-password/new-password"
        static let ChangePassword = "users/:userId/change-password"
        static let GetOTPForgetPassword = "users/forget-password/\(DataManager.shared.currentAccount)/otp"
    }
    
    enum Loan {
        static let CreateLoans = "loans"
        static let InvesableLoans = "loans?page=1&limit=50&sort=status.asc&filter=status.8,9"
        static let Loans = "loans?page=1&limit=50&sort=status.asc"
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
    
    enum Payment {
        static let CalculatorPay = "loans/collections"
        static let Transaction = "loans/transaction"
        static let GetTransactions = "transactions/:userId"
        static let Collections = "loans/:loanId/collections"
    }
    
    enum Notification {
        static let GetList = "/users/(uID)/notification?page=(pageIndex)&limit=(20)"
        static let UpdateNoti = "/users/{uid}/notification"
    }
    
    
    
}
