//
//  DataManager.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreLocation

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
    
    //thêm field cho step 4
    var listFieldForStep4: [LoanBuilderFields]?
    
    // ID của Loan
    var loanID: Int32?
    
    // Version, config
    var config: Config?
    
    // Cần cập nhật data khi có thay đổi version ở api Config
    var isUpdateFromConfig: Bool = true
    
    //List Lãi xuất dự kiến
    var listRateInfo: [RateInfo] = []
    
    //Category đang chọn hiện tại
    var currentIndexCategoriesSelectedPopup: Int? {
        didSet {
            if let i = self.currentIndexCategoriesSelectedPopup {
                self.loanInfo.loanCategoryID = Int16(i)
                self.updateIntRate()
            }
        }
    }
    //So dien thoai nguoi than 1
    var currentIndexRelationPhoneSelectedPopup1: Int?
    
    //So dien thoai nguoi than 2
    var currentIndexRelationPhoneSelectedPopup2: Int?
    
    //Job hien tai dang chon
    var currentIndexJobSelectedPopup: Int?
    
    //Job Position hien tai dang chon
    var currentIndexJobPositionSelectedPopup: Int?
    
    //Acedemic Level hien tai dang chon
    var currentIndexAcedemicLevelSelectedPopup: Int?
    
    //Hoc luc hien tai dang chon
    var currentIndexStrengthSelectedPopup: Int?
    
    //Loai dien thoai hien tai dang chon
    var currentIndexTypeMobilePhoneSelectedPopup: Int?
    
    //Loai dien thoai hien tai dang chon
    var currentIndexCareerHusbandOrWifeSelectedPopup: Int?
    
    //Loai dien thoai hien tai dang chon
    var currentListIndexLoanedFromSelectedPopup: String?
    
    //Các trường không hợp lệ của loan
    var missingLoanData: BrowwerActiveLoan? {
        didSet {
            self.updateListMissingKeyData()
        }
    }
    
    var missingLoanDataDictionary: JSONDictionary? {
        
        didSet {
            guard let miss = self.missingLoanDataDictionary else { return }
            
            guard let userInfo = miss["userInfo"] as? JSONDictionary, let relationShip = userInfo["relationships"] as? JSONDictionary else { return }
            
            if let relation = relationShip["0"] as? JSONDictionary {
                
                if let isPhone = relation["checkphoneNumber"] as? Bool, isPhone {
                    self.isRelationPhone1Invalid = true
                }
                
                if let value = relation["checkname"] as? Bool, value {
                    self.isRelationPhone1Invalid = true
                }
                
                if let value = relation["checkaddress"] as? Bool, value {
                    self.isRelationPhone1Invalid = true
                }
                
            }
            
            if let relation = relationShip["1"] as? JSONDictionary {
                
                if let isPhone = relation["checkphoneNumber"] as? Bool, isPhone {
                    self.isRelationPhone2Invalid = true
                }
                
                if let value = relation["checkname"] as? Bool, value {
                    self.isRelationPhone2Invalid = true
                }
                
                if let value = relation["checkaddress"] as? Bool, value {
                    self.isRelationPhone2Invalid = true
                }
                
            }
        }
    }
    
    //For additional missingData
    var titleAdditionalOptinalMediaMissingData: String?
    
    //MissingData optionalText
    var missingOptionalText: JSONDictionary?
    
    //MissingData optionalMedia
    var missingOptionalMedia: [String: Any]?
    var missingRelationsShip: [String: Any]?
    
    //List Key missing Loan Data
    var listKeyMissingLoanKey: [String]?
    
    //List Title missing Loan Data
    var listKeyMissingLoanTitle: [String]?
    
    //Nếu số có số điện thoại người thân không hợp lệ
    var isRelationPhone1Invalid: Bool = false
    var isRelationPhone2Invalid: Bool = false
    
    //Data when push notification
    var notificationData: NSDictionary?
    
    //Khi co thong bao chuyen trang thai loan cần update LoanStatusVC
    var isNeedReloadLoanStatusVC: Bool?
    
    //Check khi back tu Loan Status
    var isBackFromLoanStatusVC: Bool?
    
    
    var isNoShowAlertTimeout: Bool?
    
    //Show error when call api Error
    var isCanShowAlertAPIError: Bool = true
    //Show popup Select
    var isCanShowPopup: Bool = true
    var isCanShowPopupNeedUpdate: Bool = true
    
    //Data Vercode from Config
    var jsonDataVercodeFromConfig: JSONDictionary?
    
    //CurrentLocation
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = self.currentLocation else { return }
            
            if DataManager.shared.loanInfo.status == 0 {
                DataManager.shared.loanInfo.longitudeCreateLoan = location.longitude
                DataManager.shared.loanInfo.latitudeCreateLoan = location.latitude
            } else if DataManager.shared.loanInfo.status == STATUS_LOAN.INTEREST_CONFIRM.rawValue || DataManager.shared.loanInfo.status == STATUS_LOAN.INTEREST_CONFIRM_EXPIRED.rawValue || DataManager.shared.loanInfo.status == STATUS_LOAN.RAISING_CAPITAL.rawValue {
                DataManager.shared.loanInfo.longitudeAccepted = location.longitude
                DataManager.shared.loanInfo.latitudeAccepted = location.latitude
            }
            
        }
    }
    
    //List Bank
    var listBankData: [Bank]?
    
    func setCurrentAccount(account: String) {
        guard account.count > 0 else { return }
        DataManager.shared.currentAccount = account
        userDefault.set(account, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
        userDefault.synchronize()
    }
    
    
    /// Get List Bank
    ///
    /// - Parameter completion: <#completion description#>
    func getListBank(completion: @escaping() -> Void) {
        guard DataManager.shared.listBankData == nil else {
            completion()
            return
        }
        APIClient.shared.getBanks()
            .done(on: DispatchQueue.global(qos: .utility)) { model in
                guard model.count > 0 else { return }
                DataManager.shared.listBankData = model
                completion()
            }
            .catch { error in }
        
    }
    
    /// Get Data from JSON
    func getDataLoanFromJSON() {
        if let path = Bundle.main.path(forResource: "LoanBuilder", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Any] {
                    // do stuff

                    jsonResult.forEach({ (data) in
                        let toll = LoanCategories(object: data)
                        //self.loanBuilder.append(toll)
                        self.loanCategories.append(toll)
                    })

                }
            } catch {
                // handle error
            }
        }
    }
    
    func clearMissingLoanData() {
        DataManager.shared.missingRelationsShip = nil
        DataManager.shared.missingLoanDataDictionary = nil
        DataManager.shared.missingOptionalText = nil
        DataManager.shared.missingOptionalMedia = nil
        DataManager.shared.missingLoanData = nil
        DataManager.shared.listKeyMissingLoanKey = nil
        DataManager.shared.listKeyMissingLoanTitle = nil
        DataManager.shared.isRelationPhone1Invalid = false
        DataManager.shared.isRelationPhone2Invalid = false
        DataManager.shared.titleAdditionalOptinalMediaMissingData = nil
    }
    
    func reloadOptionalData() {
        DataManager.shared.loanInfo.optionalMedia = [[]]
        DataManager.shared.loanInfo.optionalText = []
    }
    
    func reloadDataFirstLoanVC() {
        DataManager.shared.loanInfo.amount = 0
        DataManager.shared.loanInfo.term = 0
        DataManager.shared.browwerInfo?.activeLoan?.amount = 0
        DataManager.shared.browwerInfo?.activeLoan?.term = 0
    }
    
    //Xoa du lieu khi logout
    func clearData(completion: () -> Void) {
        clearValueInValidUserDefaultData()
        clearMissingLoanData()
        self.browwerInfo = nil
        self.currentAccount = ""
        self.loanID = nil
        self.loanInfo = LoanInfo()
        self.userID = 0
        userDefault.set(nil, forKey: fUSER_DEFAUT_ACCOUNT_NAME)
        userDefault.set(nil, forKey: fUSER_DEFAUT_TOKEN)
        self.token = nil
        
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
    
    
    /// Check khoan vay hien tai co phai sinh vien
    ///
    /// - Returns: <#return value description#>
    func isLendingforStudent() -> Bool {
        var value = false
        if self.loanInfo.loanCategoryID == Loan_Student_Category_ID {
            value = true
        }
        
        return value
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
    
    
    /// Update IntRate
    func updateIntRate() {
        guard let cate = self.getCurrentCategory() else { return }
        DataManager.shared.loanInfo.intRate = Float(cate.interestRate ?? 0)
    }
    
    /// <#Description#>
    func mapDataBrowwerAndLoan() {
        
        guard let brow = self.browwerInfo, let activeLoan = brow.activeLoan,let loanId = activeLoan.loanId, loanId > 0 else { return }
        
        if let cateID = activeLoan.loanCategoryId, cateID > 0 {
            self.currentIndexCategoriesSelectedPopup = Int(cateID)
        }
        
        if let intRate = activeLoan.inRate {
            DataManager.shared.loanInfo.intRate = intRate
        }
        
        if let status = activeLoan.status {
            DataManager.shared.loanInfo.status = status
        }
        
        if let loanId = activeLoan.loanId {
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
        
        if let bankId = activeLoan.bankId {
            DataManager.shared.loanInfo.bankId = bankId
        }
        
        if let value = activeLoan.borrowedPlace {
            DataManager.shared.loanInfo.borrowedPlace = value
        }
        
        if let value = activeLoan.totalBorrowedAmount {
            DataManager.shared.loanInfo.totalBorrowedAmount = value
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
                
                if let name1 = relationShips[0].name, name1.count > 0, let name2 = relationShips[1].name, name2.count > 0 {
                    DataManager.shared.loanInfo.userInfo.relationships[0].name = name1
                    DataManager.shared.loanInfo.userInfo.relationships[1].name = name2
                }
                
                if let add1 = relationShips[0].address, add1.count > 0, let add2 = relationShips[1].address, add2.count > 0 {
                    DataManager.shared.loanInfo.userInfo.relationships[0].address = add1
                    DataManager.shared.loanInfo.userInfo.relationships[1].address = add2
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
            
            if let value = userInfo.mobilePhoneType {
                DataManager.shared.loanInfo.userInfo.typeMobilePhone = value
            }
            
            if let value = userInfo.phoneUsageTime {
                DataManager.shared.loanInfo.userInfo.phoneUsageTime = value
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
            
            if let positionTitle = jobInfo.positionTitle, positionTitle.count > 0 {
                DataManager.shared.loanInfo.jobInfo.positionTitle = positionTitle
            }
            
            if let company = jobInfo.company {
                DataManager.shared.loanInfo.jobInfo.company = company
            }
            
            if let company = jobInfo.academicName {
                DataManager.shared.loanInfo.jobInfo.academicName = company
            }
            
            if let salary = jobInfo.salary {
                DataManager.shared.loanInfo.jobInfo.salary = salary
            }
            
            if let phone = jobInfo.companyPhoneNumber {
                DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = phone
            }
            
            if let strength = jobInfo.strength {
                DataManager.shared.loanInfo.jobInfo.strength = strength
            }
            
            if let ace = jobInfo.academicLevel {
                DataManager.shared.loanInfo.jobInfo.academicLevel = ace
            }
            
            if let exp = jobInfo.experienceYear {
                DataManager.shared.loanInfo.jobInfo.experienceYear = exp
            }
            
            if let add = jobInfo.jobAddress, let city = add.city, let dis = add.district, let commue = add.commune, let street = add.street {
                DataManager.shared.loanInfo.jobInfo.jobAddress = Address(city: city, district: dis, commune: commue, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if let add = jobInfo.academicAddress, let city = add.city, let dis = add.district, let commue = add.commune, let street = add.street {
                DataManager.shared.loanInfo.jobInfo.academicAddress = Address(city: city, district: dis, commune: commue, street: street, zipCode: "", long: 0, lat: 0)
            }
            
            if let value = jobInfo.jobDescription {
                DataManager.shared.loanInfo.jobInfo.jobDescription = value
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
            if text.count > 0 && text.count == getCountOptionalText(cateId: DataManager.shared.loanInfo.loanCategoryID) {
                DataManager.shared.loanInfo.optionalText = text
            }
        }
        
        if let optionMedia = activeLoan.optionalMedia {
            
            let countInit = getCountOptionalMedia(cateId: DataManager.shared.loanInfo.loanCategoryID)
            
            if optionMedia.count == countInit {
                
                var temp: [[String]] = []
                for i in optionMedia {
                    if let item = i as? [String] {
                        temp.append(item)
                    }
                }
                
                if temp.count > 0 {
                    DataManager.shared.loanInfo.optionalMedia.removeAll()
                    DataManager.shared.loanInfo.optionalMedia = temp
                }
                
            } else if optionMedia.count < countInit {
                
            } else {
                
                let count = countInit
                if count > 0 {
                    var temp: [[String]] = []
                    for i in 0...count - 1 {
                        if let item = optionMedia[i] as? [String] {
                            temp.append(item)
                        }
                    }
                    
                    if temp.count > 0 {
                        DataManager.shared.loanInfo.optionalMedia.removeAll()
                        DataManager.shared.loanInfo.optionalMedia = temp
                    }
                }
                
            }
            
        }
        
        self.updateFieldsDisplay {
            
        }
        
    }
    
    
    /// Title RelationShip
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    class func getTitleRelationShip(id: Int) -> String {
        guard let cate = DataManager.shared.getCurrentCategory(), (cate.builders?.count ?? 0) > 0, let fields = cate.builders![0].fieldsDisplay else { return "Người thân" }
        
        var field: LoanBuilderFields?
        for f in fields {
            if f.id == "relationships" {
                field = f
                break
            }
        }
        
        guard let muiltiData = field?.multipleData else { return "Người thân" }
        
        for mu in muiltiData {
            if let options = mu.options {
                for op in options {
                    if id == Int(op.id ?? 0) {
                        return op.title ?? "Người thân"
                    }
                }
            }
        }
        return "Người thân"
        
        
    }
    
    
    /// Update LoanCategories for dynamic ui display
    ///
    /// - Parameter completion: <#completion description#>
    func updateFieldsDisplay(completion: @escaping () -> Void) {
        for (index, value) in self.loanCategories.enumerated() {
            if value.id == self.loanInfo.loanCategoryID {
                self.loanCategories[index].updateFieldsDisplay()
                break
            }
        }
        
        completion()
        
    }
    
    
    
    
}
