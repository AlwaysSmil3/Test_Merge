//
//  LoanBuilderMultipleData.swift
//
//  Created by Cao Van Hai on 7/10/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct LoanBuilderMultipleData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let placeholder = "placeholder"
    static let options = "options"
  }

  // MARK: Properties
  public var placeholder: String?
  public var options: [LoanBuilderOptions]?
    
    public var phoneNumber: String?
    public var type: Int?

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
    placeholder = json[SerializationKeys.placeholder].string
    if let items = json[SerializationKeys.options].array { options = items.map { LoanBuilderOptions(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = placeholder { dictionary[SerializationKeys.placeholder] = value }
    if let value = options { dictionary[SerializationKeys.options] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
