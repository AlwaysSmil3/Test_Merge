//
//  LoanBuilderData.swift
//
//  Created by Cao Van Hai on 7/10/18
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct LoanBuilderData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let title = "title"
    static let isTextInput = "isTextInput"
    static let placeholder = "placeholder"
  }

  // MARK: Properties
  public var id: Int16?
  public var title: String?
    public var subTitle: String?
    public var isTextInput: Bool?
    public var placeholder: String?
    public var textValue: String?

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
    id = json[SerializationKeys.id].int16
    title = json[SerializationKeys.title].string
    isTextInput = json[SerializationKeys.isTextInput].boolValue
    placeholder = json[SerializationKeys.placeholder].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = isTextInput { dictionary[SerializationKeys.isTextInput] = value }
    if let value = placeholder { dictionary[SerializationKeys.placeholder] = value }
    return dictionary
  }

}
