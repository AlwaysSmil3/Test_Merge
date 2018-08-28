//
//  PaymentLiquidation.swift
//
//  Created by Cao Van Hai on 8/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PaymentLiquidation {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let outstanding = "outstanding"
    static let interest = "interest"
    static let fee = "fee"
    static let debt = "debt"
  }

  // MARK: Properties
  public var outstanding: Double?
  public var interest: Double?
  public var fee: Double?
  public var debt: Double?

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
    outstanding = json[SerializationKeys.outstanding].double ?? 0
    interest = json[SerializationKeys.interest].double ?? 0
    fee = json[SerializationKeys.fee].double ?? 0
    debt = json[SerializationKeys.debt].double ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = outstanding { dictionary[SerializationKeys.outstanding] = value }
    if let value = interest { dictionary[SerializationKeys.interest] = value }
    if let value = fee { dictionary[SerializationKeys.fee] = value }
    if let value = debt { dictionary[SerializationKeys.debt] = value }
    return dictionary
  }

}
