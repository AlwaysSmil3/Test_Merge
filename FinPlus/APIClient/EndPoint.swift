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
//    static let productURL = "https://api.mony.vn/"
//    static let devURL = "https://dev-api.mony.vn/"
    static let stageURL = "https://stage-api.mony.vn/"
}

enum APIService {
    static let AccountService = "account-service/v1/"
    static let LoanService = "loan-service/v1/"
}

//MARK: API End Point
enum EndPoint {

    // for investor
    enum Invest {
        static let Invests = ""
    }
    
    enum Authen {
        static let Authen = "\(APIService.AccountService)auth"
        static let verifyOTP = "\(APIService.AccountService)auth/otp"
        static let Logout = "\(APIService.AccountService)logout"
        static let resendOTPAuthen = "\(APIService.AccountService)auth/otp?phoneNumber="
        
    }
    
    enum User {
        static let User = "\(APIService.AccountService)users/"
        static let PushToken = "\(APIService.AccountService)users/uid/push-token"
        static let ForgetPassword = "\(APIService.AccountService)users/forget-password"
        static let ForgetPasswordOTP    = "\(APIService.AccountService)users/forget-password/otp"
        static let ForgetPasswordNewPass = "\(APIService.AccountService)users/forget-password/new-password"
        static let ChangePassword = "\(APIService.AccountService)users/:userId/change-password"
        static let GetOTPForgetPassword = "\(APIService.AccountService)users/forget-password/\(DataManager.shared.currentAccount)/otp"
    }
    
    enum Loan {
        static let CreateLoans = "\(APIService.LoanService)loans"
        static let InvesableLoans = "\(APIService.LoanService)loans?page=1&limit=50&sort=status.asc&filter=status.8,9"
        //static let Loans = "loans?page=1&limit=30&sort=createdDate.desc"
        static let Loans = "\(APIService.LoanService)&sort=createdDate.desc"
        static let LoanOTP = "\(APIService.LoanService)loans/:loanId/otp"
        static let Loan = "\(APIService.LoanService)loan"
        static let LoanCategories = "\(APIService.LoanService)loan-categories"
        static let LoanBorrowerFee = "\(APIService.LoanService)configs/get-last-loanBorrowerFee"
    }
    
    enum Config {
        static let Configs = "\(APIService.LoanService)configs"
        static let Cities = "\(APIService.LoanService)cities"
        static let Districts = "districts"
        static let Communes = "communes"
        static let Job = "\(APIService.LoanService)jobs"
        static let Position = "\(APIService.LoanService)positions"
        static let Banks = "\(APIService.LoanService)configs/banks"
    }
    
    enum Wallet {
        static let AddWallet = "\(APIService.AccountService)users/:uid/wallets"
    }
    
    enum Payment {
        static let CalculatorPay = "\(APIService.LoanService)loans/collections"
        static let Transaction = "\(APIService.LoanService)loans/transaction"
        static let GetTransactions = "\(APIService.LoanService)transactions/:userId"
        static let Collections = "\(APIService.LoanService)loans/:loanId/collections"
        static let GetInfoPayment = "\(APIService.LoanService)/loans/:loanId/transactions/payment-info?paymentDate=2018-06-07T23:59:38+00:00"
    }
    
    enum Notification {
        static let GetList = "\(APIService.AccountService)/users/(uID)/notification?page=(pageIndex)&limit=(20)"
        static let UpdateNoti = "\(APIService.AccountService)/users/{uid}/notification"
    }
    
    
    
}
