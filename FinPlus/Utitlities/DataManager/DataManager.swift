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
    
    //Push Notification Token
    var pushNotificationToken: String?
    
    // User info
    var browwerInfo: BrowwerInfo?
    
    // Info for Loan
    var loanInfo: LoanInfo = LoanInfo()
    
    // Danh sách các loại khoản vay
    var loanCategories: [LoanCategories] = []
    
    // ID của Loan
    var loanID: Int32?
    
    // Version, config
    var config: Config?
    
    // Cần cập nhật data khi có thay đổi version ở api Config
    var isUpdateFromConfig: Bool = true
    
    //Data from LoanBuilder json
    var loanBuilder: [LoanBuilderBase] = []
    
    //List Lãi xuất dự kiến
    var listRateInfo: [RateInfo] = []
    
    //Category đang chọn hiện tại
    var currentIndexCategoriesSelectedPopup: Int?
    //So dien thoai nguoi than
    var currentIndexRelationPhoneSelectedPopup: Int?
    //Job hien tai dang chon
    var currentIndexJobSelectedPopup: Int?
    //Job Position hien tai dang chon
    var currentIndexJobPositionSelectedPopup: Int?
    
    //Các trường không hợp lệ của loan
    var missingLoanData: BrowwerActiveLoan?
    
    //List Key missing Loan Data
    var listKeyMissingLoan: [String]?
    
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
    
    //Xoa du lieu khi logout
    func clearData(completion: () -> Void) {
        
        self.browwerInfo = nil
        self.currentAccount = ""
        self.loanID = nil
        self.loanInfo = LoanInfo()
        self.userID = 0
        userDefault.set(nil, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
        userDefault.set(nil, forKey: fUSER_DEFAUT_TOKEN)
        
        completion()
    }
    
    //Cập nhật push Notification Token
    func updatePushNotificationToken() {
        APIClient.shared.pushNotificationToken()
            .done(on: DispatchQueue.main) { model in
                print("update fcm token to server")
            }
            .catch { error in}
        
    }
    
    
    /// Get Category hiện tại
    ///
    /// - Returns: <#return value description#>
    func getCurrentCategory() -> LoanCategories? {
        let id = self.loanInfo.loanCategoryID
        let cates = self.loanCategories.filter{ $0.id == id }
        
        guard cates.count > 0 else { return nil }
        return cates[0]
    }
    
    
    /// <#Description#>
    func mapDataBrowwerAndLoan() {
        
        guard let brow = self.browwerInfo, let activeLoan = brow.activeLoan,let loanId = activeLoan.loanId, loanId > 0 else { return }
        
        if let cateID = activeLoan.loanCategoryId, cateID > 0 {
            DataManager.shared.loanInfo.loanCategoryID = cateID
            self.currentIndexCategoriesSelectedPopup = Int(cateID) - 1
        }
        
        if let loanId = activeLoan.loanId, loanId > 0 {
            DataManager.shared.loanID = loanId
        }
        
        if let term = activeLoan.term, term > 0 {
            DataManager.shared.loanInfo.term = term
        }
        
        if let amount = activeLoan.amount, amount > 0 {
            DataManager.shared.loanInfo.amount = amount
        }
    }
    
    
    func getListMissingKeyData() -> [String]? {
        guard let miss = self.missingLoanData else { return nil }
        
        var missingList : [String] = []
        
        if let userInfo = miss.userInfo {
            //Thong tin UserInfo
            if let fullName = userInfo.fullName, fullName.length() > 0 {
                missingList.append("fullName")
            }
            
            if let gender = userInfo.gender, gender.length() > 0 {
                missingList.append("gender")
            }
            
            if let birthday = userInfo.birthday, birthday.length() > 0 {
                missingList.append("birthday")
            }
            
            if let nationalId = userInfo.nationalId, nationalId.length() > 0 {
                missingList.append("nationalId")
            }
            
            if let phone = userInfo.relationships?.phoneNumber, phone.length() > 0 {
                missingList.append("phoneNumber")
            }
            
            if let _ = userInfo.residentAddress {
                missingList.append("residentAddress")
            }
            
            if let _ = userInfo.currentAddress {
                missingList.append("currentAddress")
            }
            
        }
        
        if let jobInfo = miss.jobInfo {
            //Thong tin JobInfo
            if let _ = jobInfo.jobType {
                missingList.append("jobType")
            }
            
            if let _ = jobInfo.position {
                missingList.append("position")
            }
            
            if let _ = jobInfo.company {
                missingList.append("company")
            }
            
            if let sa = jobInfo.salary, sa > 0 {
                missingList.append("salary")
            }
            
            if let _ = jobInfo.companyPhoneNumber {
                missingList.append("companyPhoneNumber")
            }
            
            if let _ = jobInfo.address {
                missingList.append("address")
            }
            
            
            
            
        }
        
        if let _ = miss.nationalIdAllImg {
            missingList.append("nationalIdAllImg")
        }
        
        if let _ = miss.nationalIdFrontImg {
            missingList.append("nationalIdFrontImg")
        }
        
        if let _ = miss.nationalIdBackImg {
            missingList.append("nationalIdBackImg")
        }
        
        if let _ = miss.optionalText {
            missingList.append("optionalText")
        }
        
        
        
        return missingList
    }
    
    
    /// check field missing in list Missing
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    func checkFieldIsMissing(key: String) -> Bool {
        
        guard let list = self.listKeyMissingLoan else { return false }
        
        let listFields = list.filter { $0 == key }
        
        if listFields.count > 0 {
            return true
        }
        
        return false
    }
    
    
    
    
    
    
    
}
