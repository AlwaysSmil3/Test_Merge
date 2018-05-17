//
//  BrowwerResidence.swift
//
//  Created by Cao Van Hai on 5/17/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerResidence {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let district = "district"
    static let commune = "commune"
    static let lonLat = "lonLat"
    static let city = "city"
    static let zipCode = "zipCode"
    static let address = "address"
  }

  // MARK: Properties
  public var district: String?
  public var commune: String?
  public var lonLat: String?
  public var city: String?
  public var zipCode: String?
  public var address: String?

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
    district = json[SerializationKeys.district].string ?? ""
    commune = json[SerializationKeys.commune].string ?? ""
    lonLat = json[SerializationKeys.lonLat].string ?? ""
    city = json[SerializationKeys.city].string ?? ""
    zipCode = json[SerializationKeys.zipCode].string ?? ""
    address = json[SerializationKeys.address].string ?? ""
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = district { dictionary[SerializationKeys.district] = value }
    if let value = commune { dictionary[SerializationKeys.commune] = value }
    if let value = lonLat { dictionary[SerializationKeys.lonLat] = value }
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = zipCode { dictionary[SerializationKeys.zipCode] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    return dictionary
  }

}
