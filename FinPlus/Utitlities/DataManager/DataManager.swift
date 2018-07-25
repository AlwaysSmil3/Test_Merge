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
    var userID: Int32 = 0 {
        didSet {
            loanInfo.userID = self.userID
        }
    }
    
    //header token for API
    var token: String?
    
    //Push Notification Token
    var pushNotificationToken: String?
    
    // User info
    var browwerInfo: BrowwerInfo? {
        didSet {
            self.mapDataBrowwerAndLoan()
        }
    }
    
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
    var missingLoanData: BrowwerActiveLoan? {
        didSet {
            self.updateListMissingKeyData()
        }
    }
    
    
    //List Key missing Loan Data
    var listKeyMissingLoanKey: [String]?
    
    //List Title missing Loan Data
    var listKeyMissingLoanTitle: [String]?
    

    
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
        
        if let status = activeLoan.status {
            DataManager.shared.loanInfo.status = status
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
        
        if let bank = activeLoan.bank, let bankID = bank.id, bankID > 0 {
            DataManager.shared.loanInfo.bankId = bankID
            
        }
        
        if let bankId = activeLoan.bankId, bankId > 0 {
            DataManager.shared.loanInfo.bankId = bankId
        }
        
        
        if let userInfo = activeLoan.userInfo {
            //Thong tin user
            if let fullName = userInfo.fullName {
                DataManager.shared.loanInfo.userInfo.fullName = fullName
            }
            
            if let gender = userInfo.gender {
                DataManager.shared.loanInfo.userInfo.gender = gender
            }
            
            if let relationShips = userInfo.relationships, relationShips.count > 1 {
                
                if let phone1 = relationShips[0].phoneNumber, phone1.length() > 0, let phone2 = relationShips[1].phoneNumber, phone2.length() > 0 {
                    DataManager.shared.loanInfo.userInfo.relationships[0].phoneNumber = phone1
                    DataManager.shared.loanInfo.userInfo.relationships[0].type = Int16(relationShips[0].type ?? 0)
                    DataManager.shared.loanInfo.userInfo.relationships[1].phoneNumber = phone2
                    DataManager.shared.loanInfo.userInfo.relationships[1].type = Int16(relationShips[1].type ?? 0)
                    
                }
                
            }
            
            if let birthDay = userInfo.birthday {
                DataManager.shared.loanInfo.userInfo.birthDay = birthDay
            }
            
            if let nationID = userInfo.nationalId {
                DataManager.shared.loanInfo.userInfo.nationalID = nationID
            }
            
            if let add = userInfo.residentAddress, let city = add.city, let dis = add.district, let commue = add.commune, let street = add.street {
                DataManager.shared.loanInfo.userInfo.residentAddress = Address(city: city, district: dis, commune: commue, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if let add = userInfo.currentAddress, let city = add.city, let dis = add.district, let commue = add.commune, let street = add.street {
                DataManager.shared.loanInfo.userInfo.temporaryAddress = Address(city: city, district: dis, commune: commue, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            
        }
        
        if let jobInfo = activeLoan.jobInfo {
            //Thong tin Job
            if let jobTitle = jobInfo.jobTitle, jobTitle.length() > 0 {
                DataManager.shared.loanInfo.jobInfo.jobTitle = jobTitle
                if let jobType = jobInfo.jobType {
                    DataManager.shared.loanInfo.jobInfo.jobType = jobType
                }
            }
            
            if let position = jobInfo.position {
                DataManager.shared.loanInfo.jobInfo.position = position
            }
            
            if let company = jobInfo.company {
                DataManager.shared.loanInfo.jobInfo.company = company
            }
            
            if let salary = jobInfo.salary {
                DataManager.shared.loanInfo.jobInfo.salary = Int32(salary)
            }
            
            if let phone = jobInfo.companyPhoneNumber {
                DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = phone
            }
            
            if let add = jobInfo.address, let city = add.city, let dis = add.district, let commue = add.commune, let street = add.street {
                DataManager.shared.loanInfo.jobInfo.address = Address(city: city, district: dis, commune: commue, street: street, zipCode: "", long: 0, lat: 0)
            }
            
        }
        
        if let url = activeLoan.nationalIdAllImg {
            DataManager.shared.loanInfo.nationalIdAllImg = url
        }
        
        if let url = activeLoan.nationalIdFrontImg {
            DataManager.shared.loanInfo.nationalIdFrontImg = url
        }
        
        if let url = activeLoan.nationalIdBackImg {
            DataManager.shared.loanInfo.nationalIdBackImg = url
        }
        
        if let text = activeLoan.optionalText {
            DataManager.shared.loanInfo.optionalText = text
        }
        
        if let optionMedia = activeLoan.optionalMedia {
            DataManager.shared.loanInfo.optionalMedia.removeAll()
            for i in optionMedia {
                if i.length() > 0 {
                    DataManager.shared.loanInfo.optionalMedia.append(i)
                }
            }
            
        }
        
        
    }
    
    //Update Các thông tin không hợp lệ
    func updateListMissingKeyData() {
        
        guard let miss = self.missingLoanData else { return }
        
        var missingListKey : [String] = []
        var missingListTitle : [String] = []
        
        if let userInfo = miss.userInfo {
            //Thong tin UserInfo
            if let fullName = userInfo.fullName, fullName.length() > 0 {
                missingListKey.append("fullName")
                missingListTitle.append("Họ và tên")
            }
            
            if let gender = userInfo.gender, gender.length() > 0 {
                missingListKey.append("gender")
                missingListTitle.append("Giới tính")
            }
            
            if let birthday = userInfo.birthday, birthday.length() > 0 {
                missingListKey.append("birthday")
                missingListTitle.append("Ngày sinh")
            }
            
            if let nationalId = userInfo.nationalId, nationalId.length() > 0 {
                missingListKey.append("nationalId")
                missingListTitle.append("Số CMND/thẻ căn cước")
            }
            
            if let relationPhones = userInfo.relationships, relationPhones.count > 0 {
                missingListKey.append("relationships")
                missingListTitle.append("Số điện thoại liên lạc của người thân")
            }
            
            if let add = userInfo.residentAddress, let city = add.city, city.length() > 0 {
                missingListKey.append("residentAddress")
                missingListTitle.append("Địa chỉ nhà thường trú")
            }
            
            if let add = userInfo.currentAddress, let city = add.city, city.length() > 0 {
                missingListKey.append("currentAddress")
                missingListTitle.append("Địa chỉ nhà tạm trú")
            }
            
        }
        
        if let jobInfo = miss.jobInfo {
            //Thong tin JobInfo
            if let value = jobInfo.jobTitle, value.length() > 0 {
                missingListKey.append("jobType")
                missingListTitle.append("Nghề nghiệp")
            }
            
            if let value = jobInfo.position, value.length() > 0 {
                missingListKey.append("position")
                missingListTitle.append("Cấp bậc")
            }
            
            if let value = jobInfo.company, value.length() > 0 {
                missingListKey.append("company")
                missingListTitle.append("Tên cơ quan")
            }
            
            if let sa = jobInfo.salary, sa > 0 {
                missingListKey.append("salary")
                missingListTitle.append("Thu nhập hàng tháng")
            }
            
            if let value = jobInfo.companyPhoneNumber, value.length() > 0 {
                missingListKey.append("companyPhoneNumber")
                missingListTitle.append("SĐT cơ quan")
            }
            
            if let add = jobInfo.address, let city = add.city, city.length() > 0 {
                missingListKey.append("address")
                missingListTitle.append("Địa chỉ cơ quan")
            }
            
        }
        
        if let value = miss.nationalIdAllImg, value.length() > 0 {
            missingListKey.append("nationalIdAllImg")
            missingListTitle.append("Ảnh bạn đang cầm CMND")
        }
        
        if let value = miss.nationalIdFrontImg, value.length() > 0 {
            missingListKey.append("nationalIdFrontImg")
            missingListTitle.append("Ảnh mặt trước CMND")
        }
        
        if let value = miss.nationalIdBackImg, value.length() > 0 {
            missingListKey.append("nationalIdBackImg")
            missingListTitle.append("Ảnh mặt sau CMND")
        }
        
        if let value = miss.optionalText, value.length() > 0 {
            missingListKey.append("optionalText")
            missingListTitle.append("Lương hàng tháng của bạn")
        }
        
        self.listKeyMissingLoanKey = missingListKey
        self.listKeyMissingLoanTitle = missingListTitle
    }
    
    
    /// check field missing in list Missing
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    func checkFieldIsMissing(key: String) -> Bool {
        guard let list = self.listKeyMissingLoanKey else { return false }
        let listFields = list.filter { $0 == key }
        
        if listFields.count > 0 {
            return true
        }
        
        return false
    }
    
    
    /// Title RelationShip
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    class func getTitleRelationShip(id: Int) -> String {
        
        switch id {
        case 0:
            return "Vợ"
        case 1:
            return "Chồng"
        case 2:
            return "Bố"
        case 3:
            return "Mẹ"
        case 4:
            return "Bạn bè"
        case 5:
            return "Đồng nghiệp"
            
        default:
            return "Người thân"
        }
        
        
    }
    
    
    
    
    
}
