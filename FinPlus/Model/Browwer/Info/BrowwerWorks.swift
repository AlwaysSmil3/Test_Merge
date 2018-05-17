//
//  BrowwerWorks.swift
//
//  Created by Cao Van Hai on 5/17/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerWorks {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let position = "position"
    static let level = "level"
    static let phoneNumber = "phoneNumber"
    static let company = "company"
    static let salary = "salary"
    static let address = "address"
  }

  // MARK: Properties
  public var position: String?
  public var level: String?
  public var phoneNumber: String?
  public var company: String?
  public var salary: String?
  public var address: String?

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
    position = json[SerializationKeys.position].string ?? ""
    level = json[SerializationKeys.level].string ?? ""
    phoneNumber = json[SerializationKeys.phoneNumber].string ?? ""
    company = json[SerializationKeys.company].string ?? ""
    salary = json[SerializationKeys.salary].string ?? ""
    address = json[SerializationKeys.address].string ?? ""
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = position { dictionary[SerializationKeys.position] = value }
    if let value = level { dictionary[SerializationKeys.level] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = company { dictionary[SerializationKeys.company] = value }
    if let value = salary { dictionary[SerializationKeys.salary] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    return dictionary
  }

}
