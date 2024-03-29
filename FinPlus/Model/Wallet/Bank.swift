//
//  Bank.swift
//
//  Created by Cao Van Hai on 11/6/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Bank {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let displayName = "displayName"
    static let id = "id"
    static let bankName = "bankName"
    static let type = "type" //type
    static let image = "image"
    static let bankNo = "bankNo"
  }

  // MARK: Properties
  public var displayName: String?
  public var id: String?
  public var bankName: String?
  public var type: String?
  public var image: String?
    public var bankNo: String?

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
    displayName = json[SerializationKeys.displayName].string ?? ""
    id = json[SerializationKeys.id].string ?? ""
    bankName = json[SerializationKeys.bankName].string ?? ""
    type = json[SerializationKeys.type].string ?? ""
    image = json[SerializationKeys.image].string ?? ""
    bankNo = json[SerializationKeys.bankNo].string ?? ""
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = displayName { dictionary[SerializationKeys.displayName] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = bankName { dictionary[SerializationKeys.bankName] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = bankNo { dictionary[SerializationKeys.bankNo] = value }
    return dictionary
  }

}
