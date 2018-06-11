//
//  LoanBuilderBase.swift
//
//  Created by Cao Van Hai on 6/10/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanBuilderBase {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let fields = "fields"
    static let title = "title"
  }

  // MARK: Properties
  public var fields: [LoanBuilderFields]?
  public var title: String?

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
    if let items = json[SerializationKeys.fields].array { fields = items.map { LoanBuilderFields(json: $0) } }
    title = json[SerializationKeys.title].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = fields { dictionary[SerializationKeys.fields] = value.map { $0.dictionaryRepresentation() } }
    if let value = title { dictionary[SerializationKeys.title] = value }
    return dictionary
  }

}
