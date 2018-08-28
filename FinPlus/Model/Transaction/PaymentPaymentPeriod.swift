//
//  PaymentPaymentPeriod.swift
//
//  Created by Cao Van Hai on 8/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PaymentPaymentPeriod {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let interest = "interest"
    static let overdue = "overdue"
    static let feeOverdue = "feeOverdue"
    static let principal = "principal"
  }

  // MARK: Properties
  public var interest: Double?
  public var overdue: Double?
  public var feeOverdue: Double?
  public var principal: Double?

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
    interest = json[SerializationKeys.interest].double ?? 0
    overdue = json[SerializationKeys.overdue].double ?? 0
    feeOverdue = json[SerializationKeys.feeOverdue].double ?? 0
    principal = json[SerializationKeys.principal].double ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = interest { dictionary[SerializationKeys.interest] = value }
    if let value = overdue { dictionary[SerializationKeys.overdue] = value }
    if let value = feeOverdue { dictionary[SerializationKeys.feeOverdue] = value }
    if let value = principal { dictionary[SerializationKeys.principal] = value }
    return dictionary
  }

}
