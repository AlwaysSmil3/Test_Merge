//
//  DataManager+MissingData.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/31/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension DataManager {
    
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
        
        if self.missingOptionalText != nil || self.missingOptionalMedia != nil {
            if self.missingOptionalText != nil {
                missingListKey.append("optionalText")
            }
            
            if self.missingOptionalMedia != nil {
                missingListKey.append("optionalMedia")
            }
            
            missingListTitle.append("Thông tin bổ sung")
        }
        
        self.listKeyMissingLoanKey = missingListKey
        self.listKeyMissingLoanTitle = missingListTitle
    }
    
    
    func checkIndexLastStepHaveMissingData(index: Int) -> Bool {
        
        guard let data = self.missingLoanDataDictionary else { return false }
        
        if index < 3 {
            if let _ = data["jobInfo"]  {
                return true
            }
        }
        
        
        if index < 4 {
            if let _ = data["bank"]  {
                return true
            }
        }
        
        if index < 5 {
            if let _ = data["nationalIdAllImg"]  {
                return true
            }
            if let _ = data["nationalIdFrontImg"]  {
                return true
            }
            if let _ = data["nationalIdBackImg"]  {
                return true
            }
        }
        
        if index < 6 {
            if let _ = data["optionalMedia"]  {
                return true
            }
            
            if let _ = data["optionalText"]  {
                return true
            }
        }
        
        return false
    }
    
    
    /// Get start index Have Invalid Data
    ///
    /// - Returns: <#return value description#>
    func getStartIndexHaveMissingData() -> Int? {
        
        guard let data = self.missingLoanDataDictionary else { return nil }
        
        if let _ = data["userInfo"]  {
            return 2
        }
        
        if let _ = data["jobInfo"]  {
            return 3
        }
        
        if let _ = data["bank"]  {
            return 4
        }
        
        if let _ = data["nationalIdAllImg"]  {
            return 5
        }
        if let _ = data["nationalIdFrontImg"]  {
            return 5
        }
        if let _ = data["nationalIdBackImg"]  {
            return 5
        }
        
        if let _ = data["optionalMedia"]  {
            return 6
        }
        
        if let _ = data["optionalText"]  {
            return 6
        }
        
        return nil
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
    
    
    /// Check Invalid Data in step persionalInfo did changed
    ///
    /// - Returns: <#return value description#>
    func checkDataInvalidChangedInStepJobInfo() -> Bool {
        guard let data = self.missingLoanDataDictionary else { return true }
        
        guard let jobInfo = data["jobInfo"] as? JSONDictionary else { return true }
        
        if let value = jobInfo["jobTitle"] as? String, value == DataManager.shared.loanInfo.jobInfo.jobTitle {
            return false
        }
        
        if let value = jobInfo["positionTitle"] as? String, value == DataManager.shared.loanInfo.jobInfo.positionTitle {
            return false
        }
        
        if let value = jobInfo["strength"] as? Int, value == DataManager.shared.loanInfo.jobInfo.strength {
            return false
        }
        
        
        if let value = jobInfo["experienceYear"] as? Float, value == DataManager.shared.loanInfo.jobInfo.experienceYear {
            return false
        }
        
        if let value = jobInfo["academicLevel"] as? Int, value == DataManager.shared.loanInfo.jobInfo.academicLevel {
            return false
        }
        
        if let value = jobInfo["studentId"] as? String, value == DataManager.shared.loanInfo.jobInfo.studentId {
            return false
        }
        if let value = jobInfo["academicName"] as? String, value == DataManager.shared.loanInfo.jobInfo.academicName {
            return false
        }
        
        if let value = jobInfo["company"] as? String, value == DataManager.shared.loanInfo.jobInfo.company {
            return false
        }
        
        if let value = jobInfo["salary"] as? Int32, value == DataManager.shared.loanInfo.jobInfo.salary {
            return false
        }
        
        if let value = jobInfo["companyPhoneNumber"] as? String, value == DataManager.shared.loanInfo.jobInfo.companyPhoneNumber {
            return false
        }
        
        if let address = jobInfo["jobAddress"] as? JSONDictionary {
            let currentAdd = DataManager.shared.loanInfo.jobInfo.jobAddress
            if let city = address["city"] as? String, city == currentAdd.city,
                let district = address["district"] as? String, district == currentAdd.district,
                let commune = address["commune"] as? String, commune == currentAdd.commune,
                let street = address["street"] as? String, street == currentAdd.street {
                return false
            }
        }
        
        if let address = jobInfo["academicAddress"] as? JSONDictionary {
            let currentAdd = DataManager.shared.loanInfo.jobInfo.academicAddress
            if let city = address["city"] as? String, city == currentAdd.city,
                let district = address["district"] as? String, district == currentAdd.district,
                let commune = address["commune"] as? String, commune == currentAdd.commune,
                let street = address["street"] as? String, street == currentAdd.street {
                return false
            }
        }
        
        return true
        
    }
    
    
    /// Check Invalid Data in step persionalInfo did changed checkDataInvalidChangedInStepJobInfo
    ///
    /// - Returns: <#return value description#>
    func checkDataInvalidChangedInStepPersionalInfo() -> Bool {
        //guard let list = self.listKeyMissingLoanKey else { return true }
        guard let data = self.missingLoanDataDictionary else { return true }
        
        guard let userInfo = data["userInfo"] as? JSONDictionary else { return true }
        
        if let value = userInfo["fullName"] as? String, value == DataManager.shared.loanInfo.userInfo.fullName {
            return false
        }
        
        if let value = userInfo["gender"] as? String, value == DataManager.shared.loanInfo.userInfo.gender {
            return false
        }
        
        if let value = userInfo["nationalId"] as? String, value == DataManager.shared.loanInfo.userInfo.nationalID {
            return false
        }
        
        
        if let value = userInfo["birthday"] as? String, value == DataManager.shared.loanInfo.userInfo.birthDay {
            return false
        }
        
        if let address = userInfo["residentAddress"] as? JSONDictionary {
            let currentAdd = DataManager.shared.loanInfo.userInfo.residentAddress
            if let city = address["city"] as? String, city == currentAdd.city,
            let district = address["district"] as? String, district == currentAdd.district,
            let commune = address["commune"] as? String, commune == currentAdd.commune,
                let street = address["street"] as? String, street == currentAdd.street {
                return false
            }
        }
        
        if let address = userInfo["currentAddress"] as? JSONDictionary {
            let currentAdd = DataManager.shared.loanInfo.userInfo.temporaryAddress
            if let city = address["city"] as? String, city == currentAdd.city,
                let district = address["district"] as? String, district == currentAdd.district,
                let commune = address["commune"] as? String, commune == currentAdd.commune,
                let street = address["street"] as? String, street == currentAdd.street {
                return false
            }
        }
        
        return true
    }
    
    
    /// Check Invalid Data in step Bank did changed
    ///
    /// - Returns: <#return value description#>
    func checkDataInvalidChangedInStepBank() -> Bool {
        
        return true
    }
    
    
    /// Check Invalid Data in step NationalID did changed
    ///
    /// - Returns: <#return value description#>
    func checkDataInvalidChangedInStepNationalID() -> Bool {
        guard let data = self.missingLoanDataDictionary else { return true }
        
        if let value = data["nationalIdAllImg"] as? String, value == DataManager.shared.loanInfo.nationalIdAllImg {
            return false
        }
        
        if let value = data["nationalIdFrontImg"] as? String, value == DataManager.shared.loanInfo.nationalIdFrontImg {
            return false
        }
        
        if let value = data["nationalIdBackImg"] as? String, value == DataManager.shared.loanInfo.nationalIdBackImg {
            return false
        }
        
        return true
    }
    
    
    /// Check Invalid Data in step OtherInfo did changed
    ///
    /// - Returns: <#return value description#>
    func checkDataInvalidChangedInStepOtherInfo() -> Bool {
        
        guard let data = self.missingLoanDataDictionary else { return true }
        
        if let optionText = data["optionalText"] as? JSONDictionary {
            var index1 = 0
            for text in DataManager.shared.loanInfo.optionalText {
                
                if let value = optionText["\(index1)"] as? String, value == text {
                    return false
                }
                
                index1 += 1
            }
        }
        
        if let optionalMedia = data["optionalMedia"] as? JSONDictionary {
            var index2 = 0
            for media in DataManager.shared.loanInfo.optionalMedia {
                if let value = optionalMedia["\(index2)"] as? [String] {
                    for value_ in value {
                        for media_ in media {
                            if media_ == value_ {
                                return false
                            }
                        }
                    }
                }
                
                index2 += 1
            }
        }


        return true
    }
    
    
    
}
