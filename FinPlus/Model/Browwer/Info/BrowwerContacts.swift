//
//  BrowwerContacts.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerContacts {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let type = "type"
    static let phoneNumber = "phoneNumber"
  }

  // MARK: Properties
  public var type: String?
  public var phoneNumber: String?

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
    type = json[SerializationKeys.type].string
    phoneNumber = json[SerializationKeys.phoneNumber].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    return dictionary
  }

}
