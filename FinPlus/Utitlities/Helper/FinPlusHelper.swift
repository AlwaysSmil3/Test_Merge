//
//  FinPlusHelper.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

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
                return (month + Double(sliderValue) * month * rate/(100 * 12 * 30)) / value
            }
            
            if DataManager.shared.loanInfo.term > 0 {
                return (month + Double(DataManager.shared.loanInfo.term) * month * rate/(100 * 12 * 30)) / value
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
    
    
    /// Get info user phone
    class func getPersionalInfo() {
        let defaultContainer = CKContainer.default()
        let publicDatabase = defaultContainer.publicCloudDatabase
        
        if #available(iOS 10.0, *) {
            defaultContainer.discoverUserIdentity(withPhoneNumber: DataManager.shared.currentAccount) { (info, error) in
                guard let componentName = info?.nameComponents else { return }
                
                print("InfoCloud familyName \(componentName.familyName)")
                print("InfoCloud givenName \(componentName.givenName)")
                print("InfoCloud middleName \(componentName.middleName)")
                
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    
    
}

