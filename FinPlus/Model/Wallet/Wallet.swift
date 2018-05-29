//
//  Wallet.swift
//
//  Created by Cao Van Hai on 5/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Wallet {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let walletAccountName = "walletAccountName"
    static let walletNumber = "walletNumber"
    static let walletName = "walletName"
    static let id = "id"
    static let walletType = "walletType"
  }

  // MARK: Properties
  public var walletAccountName: String?
  public var walletNumber: String?
  public var walletName: String?
  public var id: Int32?
  public var walletType: Int?

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
    walletAccountName = json[SerializationKeys.walletAccountName].string ?? ""
    walletNumber = json[SerializationKeys.walletNumber].string ?? ""
    walletName = json[SerializationKeys.walletName].string ?? ""
    id = json[SerializationKeys.id].int32 ?? 0
    walletType = json[SerializationKeys.walletType].int ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = walletAccountName { dictionary[SerializationKeys.walletAccountName] = value }
    if let value = walletNumber { dictionary[SerializationKeys.walletNumber] = value }
    if let value = walletName { dictionary[SerializationKeys.walletName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = walletType { dictionary[SerializationKeys.walletType] = value }
    return dictionary
  }

}
