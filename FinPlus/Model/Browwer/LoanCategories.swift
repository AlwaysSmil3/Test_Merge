//
//  LoanCategories.swift
//
//  Created by Cao Van Hai on 5/25/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanCategories {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let interestRate = "interestRate"
    static let id = "id"
    static let termMin = "termMin"
    static let max = "max"
    static let min = "min"
    static let descriptionValue = "description"
    static let title = "title"
    static let termMax = "termMax"
  }

  // MARK: Properties
  public var interestRate: Double?
  public var id: Int?
  public var termMin: Int?
  public var max: Int?
  public var min: Int?
  public var descriptionValue: String?
  public var title: String?
  public var termMax: Int?

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
    interestRate = json[SerializationKeys.interestRate].double ?? 0.0
    id = json[SerializationKeys.id].int ?? 0
    termMin = json[SerializationKeys.termMin].int ?? 0
    max = json[SerializationKeys.max].int ?? 0
    min = json[SerializationKeys.min].int ?? 0
    descriptionValue = json[SerializationKeys.descriptionValue].string ?? ""
    title = json[SerializationKeys.title].string ?? ""
    termMax = json[SerializationKeys.termMax].int ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = interestRate { dictionary[SerializationKeys.interestRate] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = termMin { dictionary[SerializationKeys.termMin] = value }
    if let value = max { dictionary[SerializationKeys.max] = value }
    if let value = min { dictionary[SerializationKeys.min] = value }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = termMax { dictionary[SerializationKeys.termMax] = value }
    return dictionary
  }

}
