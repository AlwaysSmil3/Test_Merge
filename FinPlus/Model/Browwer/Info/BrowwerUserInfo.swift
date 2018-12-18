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
    
    static let mobilePhoneType = "mobilePhoneType"
    static let phoneUsageTime = "phoneUsageTime"
  }

  // MARK: Properties
    public var relationships: [BrowwerRelationships]? {
        didSet {
            guard let relations = relationships, relations.count > 1, (relations[0].type ?? 0) > (relations[1].type ?? 0) else { return }
            self.relationships?.reverse()
        }
    }
  public var fullName: String?
  public var residentAddress: BrowwerResidentAddress?
  public var currentAddress: BrowwerCurrentAddress?
  public var gender: String?
  public var birthday: String?
  public var nationalId: String?
    
    public var mobilePhoneType: String?
    public var phoneUsageTime: Int?

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
    if let items = json[SerializationKeys.relationships].array { relationships = items.map { BrowwerRelationships(json: $0) } }
    //relationships = BrowwerRelationships(json: json[SerializationKeys.relationships])
    fullName = json[SerializationKeys.fullName].string
    residentAddress = BrowwerResidentAddress(json: json[SerializationKeys.residentAddress])
    currentAddress = BrowwerCurrentAddress(json: json[SerializationKeys.currentAddress])
    gender = json[SerializationKeys.gender].string
    birthday = json[SerializationKeys.birthday].string
    nationalId = json[SerializationKeys.nationalId].string
    
    mobilePhoneType = json[SerializationKeys.mobilePhoneType].string
    phoneUsageTime = json[SerializationKeys.phoneUsageTime].int
    
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = relationships { dictionary[SerializationKeys.relationships] = value.map { $0.dictionaryRepresentation() } }
    //if let value = relationships { dictionary[SerializationKeys.relationships] = value}
    if let value = fullName { dictionary[SerializationKeys.fullName] = value }
    if let value = residentAddress { dictionary[SerializationKeys.residentAddress] = value.dictionaryRepresentation() }
    if let value = currentAddress { dictionary[SerializationKeys.currentAddress] = value.dictionaryRepresentation() }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = birthday { dictionary[SerializationKeys.birthday] = value }
    if let value = nationalId { dictionary[SerializationKeys.nationalId] = value }
    if let value = mobilePhoneType { dictionary[SerializationKeys.mobilePhoneType] = value }
    if let value = phoneUsageTime { dictionary[SerializationKeys.phoneUsageTime] = value }
    
    return dictionary
  }

}
