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
    
    // User info
    var browwerInfo: BrowwerInfo?
    
    // Info for Loan
    var loanInfo: LoanInfo = LoanInfo()
    
    // Danh sách các loại khoản vay
    var loanCategories: [LoanCategories] = []
    
    // ID của Loan
    var loanID: Int32?
    
    // Version, config
    var version: Version?
    
    var loanBuilder: [LoanBuilderBase] = []
    
    
    /// Get Data from JSON
    func getDataLoanFromJSON() {
        if let path = Bundle.main.path(forResource: "LoanBuilder", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Any] {
                    // do stuff
                    
                    jsonResult.forEach({ (data) in
                        let toll = LoanBuilderBase(object: data)
                        self.loanBuilder.append(toll)
                    })

                }
            } catch {
                // handle error
            }
        }
    }
    
    
}
