//
//  FinPlusHelper.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreData
import SystemConfiguration
import FirebaseRemoteConfig

class FinPlusHelper {
    
    
    /// Display Current Money
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    static func formatDisplayCurrency(_ value: Double) -> String {
        let valueNumber = value as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0;
        
        let stringFormatVND = formatter.string(from: valueNumber)!
        let stringFormatVNDResult = stringFormatVND.replacingOccurrences(of: ",", with: ".")
        
        return stringFormatVNDResult
    }
    
    // Open url
    static func openUrl(stUrl : String) {
        
        if let url = URL(string: stUrl),  UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Validate email
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /// Get current date
    ///
    /// - Parameter format: <#format description#>
    static func getCurrentDate(format: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: Make Call
    static func isMakeCallAvailable() -> Bool {
        
        return UIApplication.shared.canOpenURL(URL.init(string: "tel://")!)
    }
    
    static func makeCall(forPhoneNumber number: String) {
        let mHotline = number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        
        if let url = URL(string: String(format: "tel://%@", mHotline)) {
            if FinPlusHelper.isMakeCallAvailable() == true {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open((url as URL), options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
            else {
                UIViewController.showToastWithMessage(message: "Không thể thực hiện cuộc gọi từ thiết bị này!")
            }
        }
        else {
            UIViewController.showToastWithMessage(message: "Số điện thoại không đúng hoặc chưa được cập nhật!")
        }
        
    }
    
    
    /**
     Resize image
     
     - parameter image:    <#image description#>
     - parameter newWidth: <#newWidth description#>
     
     - returns: <#return value description#>
     */
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    /// Lấy lãi xuất từ LoanCategoryID
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    static func getInterestRateFromLoanCategoryID(id: Int16) -> Double? {
        let cates = DataManager.shared.loanCategories.filter { $0.id == id }
        guard cates.count >= 1 else { return nil }
        return cates[0].interestRate!
    }
    
    //MARK: Color Gradient
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - colorBottom: <#colorBottom description#>
    ///   - colorTop: <#colorTop description#>
    /// - Returns: <#return value description#>
    static func setGradientColor(colorBottom: UIColor, colorTop: UIColor, frame: CGRect) -> CAGradientLayer {
        let gl = CAGradientLayer()
        gl.colors = [colorTop.cgColor, colorBottom.cgColor]
        gl.locations = [0.0, 1.0]
        gl.frame = frame
        
        return gl
    }
    
    
    /// Set Space Display CollectionView similar
    ///
    /// - Parameter indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    class func setCellSizeDisplayFitThird(_ indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 3 - 1
        
        return CGSize(width: width, height: 144)
    }
    
    
    /// set caption text cho loan
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    class func setAttributeTextForLoan(text: String) -> NSMutableAttributedString {
        let input = text + " "
        let font = FONT_CAPTION
        
        let attribute = [ NSAttributedStringKey.font: font,NSAttributedStringKey.foregroundColor:TEXT_NORMAL_COLOR]
        let attribute1 = [ NSAttributedStringKey.font: font,NSAttributedStringKey.foregroundColor:UIColor.red]
        let end = NSAttributedString(string: "*", attributes: attribute1)
        let attrString = NSMutableAttributedString(string: input, attributes: attribute)
        attrString.append(end)
        
        return attrString
    }
 
    // CoreData
    // MARK: - Helper Methods
    
    class func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject? = nil
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        return result
    }
    
    class func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter input: <#input description#>
    /// - Returns: <#return value description#>
    class func addCharactorToString(input: String) -> String {
        var result = ""
        
        let arrayString = input.components(separatedBy: " ")
        
        var count = 0
        for str in arrayString {
            
            if count == arrayString.count {
                result.append(str)
                return result
            }
            
            if count == 2 {
                result.append("\n\(str) ")
            } else {
                result.append("\(str) ")
            }
            
           count = count + 1
        }
        
        return result
    }
    
    
    /// Tinh số tiền phải trả hàng tháng
    ///
    /// - Parameters:
    ///   - mounth: Số tiền
    ///   - term: Kỳ hạn
    ///   - rate: lãi xuất
    class func CalculateMoneyPayMonth(month: Double, term: Double, rate: Double, isSlider: Bool = false, sliderValue: Double = 0) -> Double {
        
        var value = term
        
        if value < 1 {
            value = 1
//            if let terms = DataManager.shared.browwerInfo?.activeLoan?.term {
//                return (month + Double(terms) * month * rate/(100 * 12 * 30)) / value
//            }
            
            if isSlider {
                return (month + Double(sliderValue) * month * rate/(100 * 365)) / value
            }
            
            if DataManager.shared.loanInfo.term > 0 {
                return (month + Double(DataManager.shared.loanInfo.term) * month * rate/(100 * 365)) / value
            }
        }
        
        let amount = (month + term * month * rate/(100 * 12)) / value
        
        return amount
    }
    
    /// Lấy dữ liệu từ CoreData
    ///
    /// - Parameter completion: <#completion description#>
    class func fetchCoreData(context: NSManagedObjectContext, completion: () -> Void) {
        //guard let context = managedContext else { return }
        //Lay list entity
        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
        
        guard list.count > 0 else { return }
        
        DataManager.shared.loanCategories.removeAll()
        
        for entity in list {
            
            var loan = LoanCategories(object: NSObject())
            
            if let title = entity.value(forKey: CDLoanCategoryTitle) as? String {
                loan.title = title
            }
            if let desc = entity.value(forKey: CDLoanCategoryDescription) as? String {
                loan.descriptionValue = desc
            }
            if let id = entity.value(forKey: CDLoanCategoryID) as? Int16 {
                loan.id = id
            }
            if let max = entity.value(forKey: CDLoanCategoryMax) as? Int32 {
                loan.max = max
            }
            if let min = entity.value(forKey: CDLoanCategoryMin) as? Int32 {
                loan.min = min
            }
            if let termMax = entity.value(forKey: CDLoanCategoryTermMax) as? Int16 {
                loan.termMax = termMax
            }
            if let termMin = entity.value(forKey: CDLoanCategoryTermMin) as? Int16 {
                loan.termMin = termMin
            }
            if let interestRate = entity.value(forKey: CDLoanCategoryInterestRate) as? Double {
                loan.interestRate = interestRate
            }
            if let url = entity.value(forKey: CDLoanCategoryImageURL) as? String {
                loan.imageUrl = url
            }
            
            DataManager.shared.loanCategories.append(loan)
            
        }
        
        completion()
        
    }
    
    
//    /// Get info user phone
//    class func getPersionalInfo() {
//        let defaultContainer = CKContainer.default()
//        let publicDatabase = defaultContainer.publicCloudDatabase
//
//        if #available(iOS 10.0, *) {
//            defaultContainer.discoverUserIdentity(withPhoneNumber: DataManager.shared.currentAccount) { (info, error) in
//                guard let componentName = info?.nameComponents else { return }
//
//                print("InfoCloud familyName \(componentName.familyName)")
//                print("InfoCloud givenName \(componentName.givenName)")
//                print("InfoCloud middleName \(componentName.middleName)")
//
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//
//    }
    
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    class func updateCount(fields: [LoanBuilderFields]) -> [Int] {
        var countOptionalText = 0
        var countOptionalMedia = 0
        
        for field in fields {
            if field.id!.contains("optionalText") {
                countOptionalText += 1
            } else if field.id!.contains("optionalMedia") {
                countOptionalMedia += 1
            }
            
        }
        
        return [countOptionalText, countOptionalMedia]
    }
    
    
    /// Return Prefix BankName
    ///
    /// - Parameter bankName: <#bankName description#>
    /// - Returns: <#return value description#>
    class func getPrefixBankName(bankName: String) -> String {
        var prefixBankName = "TK ngân hàng "
        if FinPlusHelper.checkIsWallet(bankName: bankName) {
            prefixBankName = "Ví "
        }
        return prefixBankName
    }
    
    
    /// Check is Wallet
    ///
    /// - Parameter bankName: <#bankName description#>
    /// - Returns: <#return value description#>
    class func checkIsWallet(bankName: String) -> Bool {
        if bankName.removeVietnameseMark().contains("momo") || bankName.removeVietnameseMark().contains("viettelpay") {
            return true
        }
        return false
    }
    
    
    /// Check current version with fireBase Remote Config
    ///
    /// - Parameter versionConfig: <#versionConfig description#>
    /// - Returns: <#return value description#>
    class func checkVersionFromConfig(versionConfig: String) -> Bool {
        var configList = versionConfig.components(separatedBy: ".")
        
        guard let dict = Bundle.main.infoDictionary, let currentVersionString = dict["CFBundleShortVersionString"] as? String  else {
            return false
        }
        var versionList = currentVersionString.components(separatedBy: ".")
        
        if configList.count == 1 {
            configList.append("0")
            configList.append("0")
        }
        else if configList.count == 2 {
            configList.append("0")
        }
        
        if versionList.count == 1 {
            versionList.append("0")
            versionList.append("0")
        }
        else if versionList.count == 2 {
            versionList.append("0")
        }
        
        guard configList.count > 2, versionList.count > 2 else {
            return false
        }
        
        guard let x0 = Int(configList[0]), let y0 = Int(versionList[0]), let x1 = Int(configList[1]), let y1 = Int(versionList[1]), let x2 = Int(configList[2]), let y2 = Int(versionList[2]) else {
            return false
        }
        
        if x0 > y0 {
            return true
        }
        
        if x0 == y0, x1 > y1 {
            return true
        }
        
        if x0 == y0, x1 == y1, x2 > y2 {
            return true
        }
        
        return false
    }
    
    
    /// Check status need Update App
    ///
    /// - Returns: <#return value description#>
    class func checkStatusVersionIsNeedUpdate() -> Bool {
        return false
        do {
            let data = RemoteConfig.remoteConfig().configValue(forKey: "minBorrowerAppVersion").dataValue
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
            if let jsonDict = jsonResult as? JSONDictionary, let model = jsonDict["ios"] as? JSONDictionary {
                
                guard let version = model["versionCode"] as? String, FinPlusHelper.checkVersionFromConfig(versionConfig: version) else {
                    return false
                }
                
                return true
            }
            
        } catch {
            // handle error
            print("remote config hanle error")
            return false
        }
        return false
    }
    
    
    /// Show alert Need Update
    class func checkVersionWithConfigAndShowAlert(completion: @escaping () -> Void) {
        guard FinPlusHelper.isConnectedToNetwork() else { return }
        guard let model = DataManager.shared.jsonDataVercodeFromConfig else { return }
        
        guard let version = model["versionCode"] as? String, FinPlusHelper.checkVersionFromConfig(versionConfig: version) else {
            return
        }
        
        guard let topVC = UIApplication.shared.topViewController(), DataManager.shared.isCanShowPopupNeedUpdate else { return }
        
        let title = model["title"] as? String ?? ""
        let messeage = model["message"] as? String ?? ""
        DataManager.shared.isCanShowPopupNeedUpdate = false
        topVC.showAlertView(title: title, message: messeage, okTitle: "Cập nhật", cancelTitle: nil) { (status) in
            DataManager.shared.isCanShowPopupNeedUpdate = true
            if status {
                if let url = URL(string: "https://itunes.apple.com/au/app/mony/id1433420009?mt=8"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                completion()
            } else {
                completion()
            }
            
        }
        
    }
    
    
    /// Show alert Need Update
    class func checkVersionWithFireBaseConfigAndShowAlert(completion: @escaping () -> Void) {
        guard FinPlusHelper.isConnectedToNetwork() else { return }
        do {
            let data = RemoteConfig.remoteConfig().configValue(forKey: "minBorrowerAppVersion").dataValue
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
            if let jsonDict = jsonResult as? JSONDictionary, let model = jsonDict["ios"] as? JSONDictionary {
                
                guard let version = model["versionCode"] as? String, FinPlusHelper.checkVersionFromConfig(versionConfig: version) else {
                    return
                }
                
                guard let topVC = UIApplication.shared.topViewController(), DataManager.shared.isCanShowPopupNeedUpdate else { return }
                let title = model["title"] as? String ?? ""
                let messeage = model["message"] as? String ?? ""
                DataManager.shared.isCanShowPopupNeedUpdate = false
                topVC.showAlertView(title: title, message: messeage, okTitle: "Cập nhật", cancelTitle: nil) { (status) in
                    DataManager.shared.isCanShowPopupNeedUpdate = true
                    if status {
                        if let url = URL(string: "https://itunes.apple.com/au/app/mony/id1433420009?mt=8"), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        completion()
                    } else {
                        completion()
                    }
                    
                }
            }
            
        } catch {
            // handle error
            print("remote config hanle error")
           
        }
    }
    
    //MARK: Kiểm tra cập nhật đầu số mới
    class func updatePhoneNumber(phone: String) -> String {
        guard phone.count > 6 else { return phone }
        
        let headSixNumber = phone.prefix(6)
        let lastSixNumber = phone.suffix(phone.count - 6)
        
        if let temp = ListHeadPhoneUpdate["\(headSixNumber)"] as? String, temp.count > 0 {
            return temp + lastSixNumber
        }
        
        let headFiveNumber = phone.prefix(5)
        let lastFiveNumber = phone.suffix(phone.count - 5)
        
        if let temp = ListHeadPhoneUpdate["\(headFiveNumber)"] as? String, temp.count > 0 {
            return temp + lastFiveNumber
        }
        
        let headFourNumber = phone.prefix(4)
        let lastFourNumber = phone.suffix(phone.count - 4)
        
        if let temp = ListHeadPhoneUpdate["\(headFourNumber)"] as? String, temp.count > 0 {
            return temp + lastFourNumber
        }
        
        return phone
    }
    
    
    /// Get Max Length Phone
    ///
    /// - Parameter phoneNumber: <#phoneNumber description#>
    /// - Returns: <#return value description#>
    class func getMaxLengthPhone(phoneNumber: String?) -> Int {
        var maxLength = 10
        guard let phone = phoneNumber, phone.count > 2 else { return maxLength }
        
        let first1 = phone.prefix(1)
        let first2 = phone.prefix(2)
        guard first2 == "01" else {
            if first1 != "0" && first1 != "1" {
                maxLength = 9
            }
            
            return maxLength
        }
        maxLength = 11
        return maxLength
    }
    
    
}

