//
//  DateLimit.swift
//
//  Created by Cao Van Hai on 8/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct DateLimit {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let rAISINGCAPITAL = "RAISING_CAPITAL"
    static let iNTERESTCONFIRMEXPIRED = "INTEREST_CONFIRM_EXPIRED"
    static let iNTERESTCONFIRM = "INTEREST_CONFIRM"
    static let cONTRACTREADY = "CONTRACT_READY"
    static let eXPIRED = "EXPIRED"
  }

  // MARK: Properties
  public var rAISINGCAPITAL: Int?
  public var iNTERESTCONFIRMEXPIRED: Int?
  public var iNTERESTCONFIRM: Int?
  public var cONTRACTREADY: Int?
  public var eXPIRED: Int?

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
    rAISINGCAPITAL = json[SerializationKeys.rAISINGCAPITAL].int
    iNTERESTCONFIRMEXPIRED = json[SerializationKeys.iNTERESTCONFIRMEXPIRED].int
    iNTERESTCONFIRM = json[SerializationKeys.iNTERESTCONFIRM].int
    cONTRACTREADY = json[SerializationKeys.cONTRACTREADY].int
    eXPIRED = json[SerializationKeys.eXPIRED].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = rAISINGCAPITAL { dictionary[SerializationKeys.rAISINGCAPITAL] = value }
    if let value = iNTERESTCONFIRMEXPIRED { dictionary[SerializationKeys.iNTERESTCONFIRMEXPIRED] = value }
    if let value = iNTERESTCONFIRM { dictionary[SerializationKeys.iNTERESTCONFIRM] = value }
    if let value = cONTRACTREADY { dictionary[SerializationKeys.cONTRACTREADY] = value }
    if let value = eXPIRED { dictionary[SerializationKeys.eXPIRED] = value }
    return dictionary
  }

}
