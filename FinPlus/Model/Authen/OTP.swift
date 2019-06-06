//
//  OTPOTP.swift
//
//  Created by Lionel Vũ Thành Đô on 6/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OTP {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let data = "data"
    static let returnMsg = "returnMsg"
    static let returnCode = "returnCode"
  }

  // MARK: Properties
  public var data: OTPData?
  public var returnMsg: String?
  public var returnCode: Int?

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
    data = OTPData(json: json[SerializationKeys.data])
    returnMsg = json[SerializationKeys.returnMsg].string
    returnCode = json[SerializationKeys.returnCode].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = data { dictionary[SerializationKeys.data] = value.dictionaryRepresentation() }
    if let value = returnMsg { dictionary[SerializationKeys.returnMsg] = value }
    if let value = returnCode { dictionary[SerializationKeys.returnCode] = value }
    return dictionary
  }

}
