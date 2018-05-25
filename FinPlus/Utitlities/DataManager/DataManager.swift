//
//  DataManager.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class DataManager {
    // Singeton
    static let shared = DataManager()
    
    
    var currentAccount: String = ""
    var userID: Int32 = 0
    
    // Info for Loan
    var loanInfo: LoanInfo = LoanInfo()
    
    
}
