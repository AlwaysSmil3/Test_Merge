//
//  Wallet.swift
//
//  Created by Cao Van Hai on 5/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

enum BankName: Int {
    case Vietcombank = 1
    case Viettinbank = 2
    case Techcombank = 3
    case Agribank = 4
}

public struct AccountBank {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let accountBankName = "accountHolder"
    static let accountBankNumber = "accountNumber"
    static let bankName = "type"
    static let id = "id"
    static let bankType = "type"
    static let district = "branch"
  }

  // MARK: Properties
  public var accountBankName: String?
  public var accountBankNumber: String?
  public var bankName: String?
  public var id: Int32?
  public var bankType: Int?
  public var district: String?
    public var icon: UIImage?
    public init() {
        accountBankName = ""
        accountBankNumber = ""
        bankName = ""
        id = 0
        bankType = 0
        district = ""
        icon = nil
    }
    // MARK: SwiftyJSON manual
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(wID: Int32, wType: Int, wAccountName: String, wBankName: String, wNumber: String, wDistrict: String , wIcon: UIImage? = nil) {
        accountBankName = wAccountName
        accountBankNumber = wNumber
        bankName = wBankName
        id = wID
        bankType = wType
        district = wDistrict
        icon = wIcon
    }
    
  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    accountBankName = json[SerializationKeys.accountBankName].string ?? ""
    accountBankNumber = json[SerializationKeys.accountBankNumber].string ?? ""
    bankName = json[SerializationKeys.bankName].string ?? ""
    id = json[SerializationKeys.id].int32 ?? 0
    district = json[SerializationKeys.district].string ?? ""
    
    if bankName == "Vietcombank" || bankName == "VCB" {
        bankType = 1
    }
    else if bankName == "Viettinbank" {
        bankType = 2
    }
    else if bankName == "Techcombank" {
        bankType = 3
    }
    else if bankName == "Agribank" {
        bankType = 4
    }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = accountBankName { dictionary[SerializationKeys.accountBankName] = value }
    if let value = accountBankNumber { dictionary[SerializationKeys.accountBankNumber] = value }
    if let value = bankName { dictionary[SerializationKeys.bankName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = bankType { dictionary[SerializationKeys.bankType] = value }
    if let value = district { dictionary[SerializationKeys.district] = value }
    return dictionary
  }

}
