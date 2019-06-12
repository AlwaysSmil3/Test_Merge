//
//  AuthenticationData.swift
//
//  Created by Cao Van Hai on 6/22/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AuthenticationData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let uuidDevice = "uuidDevice"
    static let email = "email"
    static let id = "id"
    static let phoneNumber = "phoneNumber"
    static let accessToken = "accessToken"
    static let deviceType = "deviceType"
    static let avatar = "avatar"
    static let fullname = "fullname"
    static let accountType = "accountType"
    static let gender = "gender"
    static let displayName = "displayName"
    static let birthday = "birthday"
    static let nationalId = "nationalId"
    static let jwtToken = "jwtToken"
  }

  // MARK: Properties
  public var uuidDevice: String?
  public var email: String?
  public var id: Int32?
  public var phoneNumber: String?
  public var accessToken: String?
  public var deviceType: String?
  public var avatar: String?
  public var fullname: String?
    public var accountType: String?
  public var gender: String?
  public var displayName: String?
  public var birthday: String?
  public var nationalId: String?
    public var jwtToken: String?

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
    uuidDevice = json[SerializationKeys.uuidDevice].string
    email = json[SerializationKeys.email].string
    id = json[SerializationKeys.id].int32
    phoneNumber = json[SerializationKeys.phoneNumber].string
    accessToken = json[SerializationKeys.accessToken].string
    deviceType = json[SerializationKeys.deviceType].string
    avatar = json[SerializationKeys.avatar].string
    fullname = json[SerializationKeys.fullname].string
    accountType = json[SerializationKeys.accountType].string
    gender = json[SerializationKeys.gender].string
    displayName = json[SerializationKeys.displayName].string
    birthday = json[SerializationKeys.birthday].string
    nationalId = json[SerializationKeys.nationalId].string
    jwtToken = json[SerializationKeys.jwtToken].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = uuidDevice { dictionary[SerializationKeys.uuidDevice] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = accessToken { dictionary[SerializationKeys.accessToken] = value }
    if let value = deviceType { dictionary[SerializationKeys.deviceType] = value }
    if let value = avatar { dictionary[SerializationKeys.avatar] = value }
    if let value = fullname { dictionary[SerializationKeys.fullname] = value }
    if let value = accountType { dictionary[SerializationKeys.accountType] = value }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = displayName { dictionary[SerializationKeys.displayName] = value }
    if let value = birthday { dictionary[SerializationKeys.birthday] = value }
    if let value = nationalId { dictionary[SerializationKeys.nationalId] = value }
    if let value = jwtToken { dictionary[SerializationKeys.jwtToken] = value }
    return dictionary
  }

}
