//
//  BaseClass.swift
//
//  Created by Lionel Vũ Thành Đô on 6/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Config {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let about = "about"
    static let version = "version"
    static let loanStatus = "loanStatus"
    static let policy = "policy"
    static let faq = "faq"
    static let serviceFee = "serviceFee"
  }

  // MARK: Properties
  public var about: String?
  public var version: String?
  public var loanStatus: LoanStatus?
  public var policy: String?
  public var faq: [Faq]?
  public var serviceFee: Int?

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
    about = json[SerializationKeys.about].string ?? ""
    version = json[SerializationKeys.version].string ?? ""
    loanStatus = LoanStatus(json: json[SerializationKeys.loanStatus])
    policy = json[SerializationKeys.policy].string ?? ""
    if let items = json[SerializationKeys.faq].array { faq = items.map { Faq(json: $0) } }
    serviceFee = json[SerializationKeys.serviceFee].int ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = about { dictionary[SerializationKeys.about] = value }
    if let value = version { dictionary[SerializationKeys.version] = value }
    if let value = loanStatus { dictionary[SerializationKeys.loanStatus] = value.dictionaryRepresentation() }
    if let value = policy { dictionary[SerializationKeys.policy] = value }
    if let value = faq { dictionary[SerializationKeys.faq] = value.map { $0.dictionaryRepresentation() } }
    if let value = serviceFee { dictionary[SerializationKeys.serviceFee] = value }
    return dictionary
  }

}
