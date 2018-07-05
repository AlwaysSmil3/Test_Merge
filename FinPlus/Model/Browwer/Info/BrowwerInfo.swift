//
//  BrowwerInfo.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phoneNumber = "phoneNumber"
    static let gender = "gender"
    static let contacts = "contacts"
    static let works = "works"
    static let wallets = "wallets"
    static let residence = "residence"
    static let activeLoan = "activeLoan"
    static let birthday = "birthday"
    static let role = "role"
    static let fullName = "fullName"
    static let id = "id"
    static let cic = "cic"
    static let displayName = "displayName"
    static let nationalId = "nationalId"
    static let createdAt = "createdAt"
    
    static let email = "email"
    static let uuidDevice = "uuidDevice"
    static let token = "token"
    static let avatar = "avatar"
    static let banks = "banks"
    
  }

  // MARK: Properties
  public var phoneNumber: String?
  public var gender: String?
  public var contacts: BrowwerContacts?
  public var works: [BrowwerWorks]?
  public var wallets: [BrowwerWallets]?
  public var residence: BrowwerResidence?
  public var activeLoan: BrowwerActiveLoan?
  public var birthday: String?
  public var role: String?
  public var fullName: String?
  public var id: Int32?
  public var cic: String?
  public var displayName: String?
  public var nationalId: String?
    public var createdAt: String?
    public var email: String?
    public var token: String?
    public var uuidDevice: String?
    public var avatar: String?
    public var banks : [AccountBank]?

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
    phoneNumber = json[SerializationKeys.phoneNumber].string
    gender = json[SerializationKeys.gender].string
    contacts = BrowwerContacts(json: json[SerializationKeys.contacts])
    if let items = json[SerializationKeys.works].array { works = items.map { BrowwerWorks(json: $0) } }
    if let items = json[SerializationKeys.wallets].array { wallets = items.map { BrowwerWallets(json: $0) } }
    residence = BrowwerResidence(json: json[SerializationKeys.residence])
    activeLoan = BrowwerActiveLoan(json: json[SerializationKeys.activeLoan])
    birthday = json[SerializationKeys.birthday].string
    role = json[SerializationKeys.role].string
    fullName = json[SerializationKeys.fullName].string
    id = json[SerializationKeys.id].int32
    cic = json[SerializationKeys.cic].string
    displayName = json[SerializationKeys.displayName].string
    nationalId = json[SerializationKeys.nationalId].string
    createdAt = json[SerializationKeys.createdAt].string
    
    email = json[SerializationKeys.email].string
    token = json[SerializationKeys.token].string
    uuidDevice = json[SerializationKeys.uuidDevice].string
    avatar = json[SerializationKeys.avatar].string
    if let items = json[SerializationKeys.banks].array { banks = items.map { AccountBank(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = contacts { dictionary[SerializationKeys.contacts] = value }
    if let value = works { dictionary[SerializationKeys.works] = value.map { $0.dictionaryRepresentation() } }
    if let value = wallets { dictionary[SerializationKeys.wallets] = value.map { $0.dictionaryRepresentation() } }
    if let value = residence { dictionary[SerializationKeys.residence] = value.dictionaryRepresentation() }
    if let value = activeLoan { dictionary[SerializationKeys.activeLoan] = value.dictionaryRepresentation() }
    if let value = birthday { dictionary[SerializationKeys.birthday] = value }
    if let value = role { dictionary[SerializationKeys.role] = value }
    if let value = fullName { dictionary[SerializationKeys.fullName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = cic { dictionary[SerializationKeys.cic] = value }
    if let value = displayName { dictionary[SerializationKeys.displayName] = value }
    if let value = nationalId { dictionary[SerializationKeys.nationalId] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = email { dictionary[SerializationKeys.createdAt] = value }
    if let value = token { dictionary[SerializationKeys.token] = value }
    if let value = uuidDevice { dictionary[SerializationKeys.uuidDevice] = value }
    if let value = avatar { dictionary[SerializationKeys.avatar] = value }
    if let value = banks { dictionary[SerializationKeys.banks] = value.map { $0.dictionaryRepresentation() } }

    return dictionary
  }

}
