//
//  APIResponseGeneral.swift
//
//  Created by Cao Van Hai on 5/15/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct APIResponseGeneral {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let returnMsg = "returnMsg"
    static let returnCode = "returnCode"
  }

  // MARK: Properties
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
    returnMsg = json[SerializationKeys.returnMsg].string ?? ""
    returnCode = json[SerializationKeys.returnCode].int ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = returnMsg { dictionary[SerializationKeys.returnMsg] = value }
    if let value = returnCode { dictionary[SerializationKeys.returnCode] = value }
    return dictionary
  }

}
