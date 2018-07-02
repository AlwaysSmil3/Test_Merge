//
//  InvestLoanBaseClass.swift
//
//  Created by Lionel Vũ Thành Đô on 7/2/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct InvestLoanBaseClass {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let returnCode = "returnCode"
    static let data = "data"
    static let returnMsg = "returnMsg"
  }

  // MARK: Properties
  public var returnCode: Int?
  public var data: InvestLoanData?
  public var returnMsg: String?

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
    returnCode = json[SerializationKeys.returnCode].int
    data = InvestLoanData(json: json[SerializationKeys.data])
    returnMsg = json[SerializationKeys.returnMsg].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = returnCode { dictionary[SerializationKeys.returnCode] = value }
    if let value = data { dictionary[SerializationKeys.data] = value.dictionaryRepresentation() }
    if let value = returnMsg { dictionary[SerializationKeys.returnMsg] = value }
    return dictionary
  }

}
