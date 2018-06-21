//
//  BrowwerUserInfo.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerUserInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let relationships = "relationships"
    static let fullName = "fullName"
    static let residentAddress = "residentAddress"
    static let currentAddress = "currentAddress"
    static let gender = "gender"
    static let birthday = "birthday"
    static let nationalId = "nationalId"
  }

  // MARK: Properties
  public var relationships: BrowwerRelationships?
  public var fullName: String?
  public var residentAddress: BrowwerResidentAddress?
  public var currentAddress: BrowwerCurrentAddress?
  public var gender: String?
  public var birthday: String?
  public var nationalId: String?

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
    relationships = BrowwerRelationships(json: json[SerializationKeys.relationships])
    fullName = json[SerializationKeys.fullName].string
    residentAddress = BrowwerResidentAddress(json: json[SerializationKeys.residentAddress])
    currentAddress = BrowwerCurrentAddress(json: json[SerializationKeys.currentAddress])
    gender = json[SerializationKeys.gender].string
    birthday = json[SerializationKeys.birthday].string
    nationalId = json[SerializationKeys.nationalId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = relationships { dictionary[SerializationKeys.relationships] = value}
    if let value = fullName { dictionary[SerializationKeys.fullName] = value }
    if let value = residentAddress { dictionary[SerializationKeys.residentAddress] = value.dictionaryRepresentation() }
    if let value = currentAddress { dictionary[SerializationKeys.currentAddress] = value.dictionaryRepresentation() }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = birthday { dictionary[SerializationKeys.birthday] = value }
    if let value = nationalId { dictionary[SerializationKeys.nationalId] = value }
    return dictionary
  }

}
