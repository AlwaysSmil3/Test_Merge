//
//  BrowwerRelationships.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerRelationships {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let type = "type"
    static let phoneNumber = "phoneNumber"
    
    static let name = "name"
    static let address = "address"
    static let loanPurpose = "loanPurpose"
  }

  // MARK: Properties
  public var type: Int?
  public var phoneNumber: String?
    
    public var name: String?
    public var address: String?
    public var loanPurpose: String?

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
    type = json[SerializationKeys.type].int
    phoneNumber = json[SerializationKeys.phoneNumber].string
    name = json[SerializationKeys.name].string
    address = json[SerializationKeys.address].string
    loanPurpose = json[SerializationKeys.loanPurpose].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = loanPurpose { dictionary[SerializationKeys.loanPurpose] = value }
    return dictionary
  }

}
