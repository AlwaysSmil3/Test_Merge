//
//  FinPlusHelper.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

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
    
    
    
    
    
    
}

