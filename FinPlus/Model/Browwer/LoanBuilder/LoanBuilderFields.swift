//
//  LoanBuilderFields.swift
//
//  Created by Cao Van Hai on 6/10/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanBuilderFields {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let suffix = "suffix"
    static let data = "data"
    static let selectorTitle = "selector_title"
    static let multipleLine = "multiple_line"
    static let descriptionValue = "description"
    static let showData = "show_data"
    static let type = "type"
    static let index = "index"
    static let id = "id"
    static let isRequired = "is_required"
    static let title = "title"
    static let placeholder = "placeholder"
    static let keyboard = "keyboard"
    static let showTime = "show_time"
  }

  // MARK: Properties
  public var suffix: String?
  public var data: [LoanBuilderData]?
  public var selectorTitle: String?
  public var multipleLine: Bool? = false
  public var descriptionValue: String?
  public var showData: Bool? = false
  public var type: String?
  public var index: Int?
  public var id: String?
  public var isRequired: Bool? = false
  public var title: String?
  public var placeholder: String?
  public var keyboard: String?
  public var showTime: Bool? = false

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
    suffix = json[SerializationKeys.suffix].string
    if let items = json[SerializationKeys.data].array { data = items.map { LoanBuilderData(json: $0) } }
    selectorTitle = json[SerializationKeys.selectorTitle].string
    multipleLine = json[SerializationKeys.multipleLine].boolValue
    descriptionValue = json[SerializationKeys.descriptionValue].string
    showData = json[SerializationKeys.showData].boolValue
    type = json[SerializationKeys.type].string
    index = json[SerializationKeys.index].int
    id = json[SerializationKeys.id].string
    isRequired = json[SerializationKeys.isRequired].boolValue
    title = json[SerializationKeys.title].string
    placeholder = json[SerializationKeys.placeholder].string
    keyboard = json[SerializationKeys.keyboard].string
    showTime = json[SerializationKeys.showTime].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = suffix { dictionary[SerializationKeys.suffix] = value }
    if let value = data { dictionary[SerializationKeys.data] = value.map { $0.dictionaryRepresentation() } }
    if let value = selectorTitle { dictionary[SerializationKeys.selectorTitle] = value }
    dictionary[SerializationKeys.multipleLine] = multipleLine
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    dictionary[SerializationKeys.showData] = showData
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = index { dictionary[SerializationKeys.index] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    dictionary[SerializationKeys.isRequired] = isRequired
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = placeholder { dictionary[SerializationKeys.placeholder] = value }
    if let value = keyboard { dictionary[SerializationKeys.keyboard] = value }
    dictionary[SerializationKeys.showTime] = showTime
    return dictionary
  }

}
