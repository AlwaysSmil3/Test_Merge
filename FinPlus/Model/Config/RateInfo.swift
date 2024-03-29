//
//  RateInfo.swift
//
//  Created by Cao Van Hai on 8/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RateInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let rate = "interestRate"
  }

  // MARK: Properties
  public var name: String?
  public var rate: Int?

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
    name = json[SerializationKeys.name].string ?? ""
    rate = json[SerializationKeys.rate].int ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = rate { dictionary[SerializationKeys.rate] = value }
    return dictionary
  }

}
