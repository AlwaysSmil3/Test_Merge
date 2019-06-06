//
//  BrowwerWallets.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerWallets {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let walletType = "walletType"
    static let walletNumber = "walletNumber"
  }

  // MARK: Properties
  public var id: String?
  public var walletType: String?
  public var walletNumber: String?

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
    id = json[SerializationKeys.id].string
    walletType = json[SerializationKeys.walletType].string
    walletNumber = json[SerializationKeys.walletNumber].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = walletType { dictionary[SerializationKeys.walletType] = value }
    if let value = walletNumber { dictionary[SerializationKeys.walletNumber] = value }
    return dictionary
  }

}
