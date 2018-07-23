//
//  Wallet.swift
//
//  Created by Cao Van Hai on 5/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

enum MethodType: Int {
    case CashIn = 1
    case ATM = 2
    case ViettelPay = 3
}

public struct PaymentMethod {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let methodTitle = "accountHolder"
    static let methodDescription = "accountNumber"
    static let id = "id"
    static let methodType = "type"
  }

  // MARK: Properties
  public var methodTitle: String?
  public var methodDescription: String?
  public var methodType: Int?
  public var id: Int32?
    public var icon: UIImage?
    public init() {
        methodTitle = ""
        methodDescription = ""
        methodType = 0
        id = 0
        icon = nil
    }
    // MARK: SwiftyJSON manual
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(wID: Int32, wMethodTitle: String, wMethodDescription: String, wMethodType: Int, wIcon: UIImage? = nil) {
        methodTitle = wMethodTitle
        methodDescription = wMethodDescription
        methodType = wMethodType
        id = wID
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
//    methodTitle = json[SerializationKeys.methodTitle].string ?? ""
//    methodDescription = json[SerializationKeys.methodDescription].string ?? ""
//    methodName = json[SerializationKeys.methodName].string ?? ""
//    id = json[SerializationKeys.id].int32 ?? 0
//
//    if bankName == "Vietcombank" || bankName == "VCB" {
//        bankType = 1
//    }
//    else if bankName == "Viettinbank" {
//        bankType = 2
//    }
//    else if bankName == "Techcombank" {
//        bankType = 3
//    }
//    else if bankName == "Agribank" {
//        bankType = 4
//    }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = methodTitle { dictionary[SerializationKeys.methodTitle] = value }
    if let value = methodDescription { dictionary[SerializationKeys.methodDescription] = value }
    if let value = methodType { dictionary[SerializationKeys.methodType] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    return dictionary
  }

}
