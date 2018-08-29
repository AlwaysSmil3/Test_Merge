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
    //var loanBuilder: [LoanBuilderBase] = []
    //var loanBuilder: [LoanCategories] = []
    
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
            
            if let relation = relationShip["0"] as? JSONDictionary, let isPhone = relation["checkphoneNumber"] as? Bool, isPhone {
                self.isRelationPhone1Invalid = true
            }
            
            if let relation = relationShip["1"] as? JSONDictionary, let isPhone = relation["checkphoneNumber"] as? Bool, isPhone {
                self.isRelationPhone2Invalid = true
            }
        }
    }
    
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
    }
    
    func reloadOptionalData() {
        DataManager.shared.loanInfo.optionalMedia = [[]]
        DataManager.shared.loanInfo.optionalText = []
    }
    
    func reloadDataFirstLoanVC() {
        DataManager.shared.loanInfo.amount = 0
        DataManager.shared.loanInfo.term = 0
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
    
    //Get phone invalid from missing Data
    func getPhoneInValid(index: String) -> String {
        var phone = ""
        
        guard let data = DataManager.shared.missingLoanDataDictionary, let userInfo = data["userInfo"] as? JSONDictionary, let relationPhone = userInfo["relationships"] as? JSONDictionary else {
            return phone
        }
        
        if let relation = relationPhone[index] as? JSONDictionary, let phone_ = relation["phoneNumber"] as? String {
            phone = phone_
        }
        
        
        return phone
    }
    
    
    /// <#Description#>
    func mapDataBrowwerAndLoan() {
        
        guard let brow = self.browwerInfo, let activeLoan = brow.activeLoan,let loanId = activeLoan.loanId, loanId > 0 else { return }
        
        if let cateID = activeLoan.loanCategoryId, cateID > 0 {
            DataManager.shared.loanInfo.loanCategoryID = cateID
            self.currentIndexCategoriesSelectedPopup = Int(cateID)
        }
        
        if let intRate = activeLoan.inRate {
            DataManager.shared.loanInfo.intRate = intRate
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
                DataManager.shared.loanInfo.jobInfo.salary = Int32(salary)
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
                if i.count > 0 {
                    DataManager.shared.loanInfo.optionalMedia.append(i as! [String])
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
            if let fullName = userInfo.fullName, fullName.length() > 0, fullName == self.browwerInfo?.activeLoan?.userInfo?.fullName {
                missingListKey.append("fullName")
                missingListTitle.append("Họ và tên")
            }
            
            if let gender = userInfo.gender, gender.length() > 0, gender == self.browwerInfo?.activeLoan?.userInfo?.gender {
                missingListKey.append("gender")
                missingListTitle.append("Giới tính")
            }
            
//            if let relationShip = userInfo.relationships, relationShip.count > 0 {
//                missingListKey.append("relationships")
//                missingListTitle.append("Số điện thoại liên lạc của người thân")
//            }
            
            if let birthday = userInfo.birthday, birthday.length() > 0, birthday == self.browwerInfo?.activeLoan?.userInfo?.birthday {
                missingListKey.append("birthday")
                missingListTitle.append("Ngày sinh")
            }
            
            if let nationalId = userInfo.nationalId, nationalId.length() > 0, nationalId == self.browwerInfo?.activeLoan?.userInfo?.nationalId {
                missingListKey.append("nationalId")
                missingListTitle.append("Số CMND/thẻ căn cước")
            }
            
            if self.missingRelationsShip != nil, userDefault.value(forKey: UserDefaultInValidRelationPhone) == nil {
                missingListKey.append("relationships")
                missingListTitle.append("Số điện thoại liên lạc của người thân")
            }
            
//            if let relationPhones = userInfo.relationships, relationPhones.count > 0 {
//                missingListKey.append("relationships")
//                missingListTitle.append("Số điện thoại liên lạc của người thân")
//            }
            
            if let add = userInfo.residentAddress, let city = add.city, city.length() > 0, userDefault.value(forKey: UserDefaultInValidResidentAddress) == nil {
                missingListKey.append("residentAddress")
                missingListTitle.append("Địa chỉ nhà thường trú")
            }
            
            if let add = userInfo.currentAddress, let city = add.city, city.length() > 0, userDefault.value(forKey: UserDefaultInValidCurrentAddress) == nil {
                missingListKey.append("currentAddress")
                missingListTitle.append("Địa chỉ nhà tạm trú")
            }
            
        }
        
        if let jobInfo = miss.jobInfo {
            //Thong tin JobInfo
            if let value = jobInfo.jobTitle, value.length() > 0, value == self.browwerInfo?.activeLoan?.jobInfo?.jobTitle {
                missingListKey.append("jobType")
                missingListKey.append("jobTitle")
                missingListTitle.append("Nghề nghiệp")
            }
            
            if let value = jobInfo.positionTitle, value.length() > 0, value == self.browwerInfo?.activeLoan?.jobInfo?.positionTitle {
                missingListKey.append("position")
                missingListKey.append("positionTitle")
                missingListTitle.append("Cấp bậc")
            }

            
            if let strength = jobInfo.strength, strength == self.browwerInfo?.activeLoan?.jobInfo?.strength {
                missingListKey.append("strength")
                missingListTitle.append("Học lực")
            }
            
            if let ace = jobInfo.academicLevel, ace != self.browwerInfo?.activeLoan?.jobInfo?.academicLevel {
                missingListKey.append("academicLevel")
                missingListTitle.append("Trình độ học vấn")
            }
            
            if let exp = jobInfo.experienceYear, exp > 0, exp == self.browwerInfo?.activeLoan?.jobInfo?.experienceYear {
                missingListKey.append("experienceYear")
                missingListTitle.append("Số năm kinh nghiệm")
            }
            
            if let value = jobInfo.company, value.length() > 0, value == self.browwerInfo?.activeLoan?.jobInfo?.company {
                missingListKey.append("company")
                missingListTitle.append("Tên cơ quan")
            }
            
            if let value = jobInfo.academicName, value.length() > 0, value == self.browwerInfo?.activeLoan?.jobInfo?.academicName {
                missingListKey.append("academicName")
                missingListTitle.append("Tên trường học")
            }
            
            if let sa = jobInfo.salary, sa > 0, sa == self.browwerInfo?.activeLoan?.jobInfo?.salary {
                missingListKey.append("salary")
                missingListTitle.append("Thu nhập hàng tháng")
            }
            
            if let value = jobInfo.companyPhoneNumber, value.length() > 0, value == self.browwerInfo?.activeLoan?.jobInfo?.companyPhoneNumber {
                missingListKey.append("companyPhoneNumber")
                missingListTitle.append("SĐT cơ quan")
            }
            
            if let add = jobInfo.jobAddress, let city = add.city, city.length() > 0, userDefault.value(forKey: UserDefaultInValidJobAddress) == nil {
                missingListKey.append("jobAddress")
                missingListTitle.append("Địa chỉ cơ quan")
            }
            
            if let add = jobInfo.academicAddress, let city = add.city, city.length() > 0, userDefault.value(forKey: UserDefaultInValidAcademicAddress) == nil {
                missingListKey.append("academicAddress")
                missingListTitle.append("Địa chỉ trường học")
            }
            
        }
        
        //if let bank = miss.bank,
        if let bank = miss.bank, userDefault.value(forKey: UserDefaultInValidBank) == nil {
            var isAdd = false
            if let accountHolder = bank.accountHolder, accountHolder.count > 0 {
                isAdd = true
            }
            
            if let accountNumber = bank.accountNumber, accountNumber.count > 0 {
                isAdd = true
            }
            
            if isAdd {
                missingListKey.append("bank")
                missingListTitle.append("Tài khoản nhận tiền")
            }
        }
        
        if let value = miss.nationalIdAllImg, value.length() > 0, value == self.browwerInfo?.activeLoan?.nationalIdAllImg {
            missingListKey.append("nationalIdAllImg")
            missingListTitle.append("Ảnh bạn đang cầm CMND")
        }
        
        if let value = miss.nationalIdFrontImg, value.length() > 0, value == self.browwerInfo?.activeLoan?.nationalIdFrontImg {
            missingListKey.append("nationalIdFrontImg")
            missingListTitle.append("Ảnh mặt trước CMND")
        }
        
        if let value = miss.nationalIdBackImg, value.length() > 0, value == self.browwerInfo?.activeLoan?.nationalIdBackImg {
            missingListKey.append("nationalIdBackImg")
            missingListTitle.append("Ảnh mặt sau CMND")
        }
        
        if self.missingOptionalText != nil {
            missingListKey.append("optionalText")
            missingListTitle.append("Thông tin bổ sung")
        }
        
        if self.missingOptionalMedia != nil {
            missingListKey.append("optionalMedia")
            missingListTitle.append("Thông tin bổ sung Media")
        }
        
    
        
//        if let value = miss.optionalText, value.count > 0 {
//            missingListKey.append("optionalText")
//            missingListTitle.append("Thông tin bổ sung")
//        }
        
        self.listKeyMissingLoanKey = missingListKey
        self.listKeyMissingLoanTitle = missingListTitle
    }
    
    
    func checkIndexLastStepHaveMissingData(index: Int) -> Bool {
        
        guard let data = self.missingLoanDataDictionary else { return false }
        
//        switch index {
//        case 3:
            if index < 3 {
                if let _ = data["jobInfo"]  {
                    return true
                }
            }
            
//            break
//        case 4:
            if index < 4 {
                if let _ = data["bank"]  {
                    return true
                }
            }
//            break
//        case 5:
            if index < 5 {
                if let _ = data["optionalMedia"]  {
                    return true
                }
                
                if let _ = data["optionalText"]  {
                    return true
                }
            }

//            break
//        case 6:
//            break
//        default:
//            break
//        }
        
        
        return false
    }
    
    
    /// Check missing bankData
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - currentBankHolder: <#currentBankHolder description#>
    ///   - currenAccount: <#currenAccount description#>
    /// - Returns: <#return value description#>
    func checkMissingBankData(key: String, currentBankHolder: String? = nil, currenAccount: String? = nil) -> Bool {
        guard let list = self.listKeyMissingLoanKey else { return false }
        guard let data = self.missingLoanDataDictionary, let bankData = data["bank"] as? JSONDictionary else { return false }
        
        let listFields = list.filter { $0 == key }
        
        if listFields.count == 0 {
            return false
        }
        
        if let invalidValue = bankData["accountHolder"] as? String, currentBankHolder == invalidValue {
            return true
        }
        
        if let invalidValue = bankData["accountNumber"] as? String, currenAccount == invalidValue {
            return true
        }
        
        
        return false
    }
    
    
    /// Get Value Invalid from missing Data
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - parentKey: <#parentKey description#>
    /// - Returns: <#return value description#>
    func getValueInvalid(key: String, parentKey: String?) -> Any {
        
        guard let list = self.listKeyMissingLoanKey else { return "" }
        guard let data = self.missingLoanDataDictionary else { return "" }
        
        let listFields = list.filter { $0 == key }
        
        if listFields.count == 0 {
            return ""
        }
        
        if let parentKey_ = parentKey {
            if let parent = data[parentKey_] as? JSONDictionary, let invalidValue = parent[key] as? String {
                return invalidValue
            }
            
            if let parent = data[parentKey_] as? JSONDictionary, let invalidValue = parent[key] as? Int {
                return invalidValue
            }
            
        } else {
            if let invalidValue = data[key] as? String {
                return invalidValue
            }
            
            if let invalidValue = data[key] as? Int {
                return invalidValue
            }
        }
        
        return ""
    }
    
    
    /// check field missing in list Missing
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    func checkFieldIsMissing(key: String, parentKey: String? = nil, currentValue: String? = nil, currentValueIndex: Int? = nil) -> Bool {
        guard let list = self.listKeyMissingLoanKey else { return false }
        guard let data = self.missingLoanDataDictionary else { return false }
        
        let listFields = list.filter { $0 == key }
        
        if listFields.count == 0 {
            return false
        }
        
        if currentValue == nil {
            return true
        }
        
        if let parentKey_ = parentKey {
            if let parent = data[parentKey_] as? JSONDictionary, let invalidValue = parent[key] as? String, currentValue == invalidValue {
                return true
            }
            
            if let parent = data[parentKey_] as? JSONDictionary, let invalidValue = parent[key] as? Int, currentValueIndex == invalidValue {
                return true
            }
            
        } else {
            if let invalidValue = data[key] as? String, currentValue == invalidValue {
                return true
            }
            
            if let invalidValue = data[key] as? Int, currentValueIndex == invalidValue {
                return true
            }
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
            return "Bố"
        case 1:
            return "Mẹ"
        case 2:
            return "Vợ"
        case 3:
            return "Chồng"
        case 4:
            return "Bạn bè"
        case 5:
            return "Đồng nghiệp"
            
        default:
            return "Người thân"
        }
        
        
    }
    
    
    
    
    
}
