//
//  LoanStatus.swift
//
//  Created by Lionel Vũ Thành Đô on 6/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanStatus {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let aCCEPTED = "ACCEPTED"
    static let rAISINGCAPITAL = "RAISING_CAPITAL"
    static let fINISHED = "FINISHED"
    static let wAITINGFORAPPROVAL = "WAITING_FOR_APPROVAL"
    static let cANCELED = "CANCELED"
    static let pENDING = "PENDING"
    static let rEJECTED = "REJECTED"
    static let dRAFT = "DRAFT"
  }

  // MARK: Properties
  public var aCCEPTED: Int?
  public var rAISINGCAPITAL: Int?
  public var fINISHED: Int?
  public var wAITINGFORAPPROVAL: Int?
  public var cANCELED: Int?
  public var pENDING: Int?
  public var rEJECTED: Int?
  public var dRAFT: Int?

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
    aCCEPTED = json[SerializationKeys.aCCEPTED].int
    rAISINGCAPITAL = json[SerializationKeys.rAISINGCAPITAL].int
    fINISHED = json[SerializationKeys.fINISHED].int
    wAITINGFORAPPROVAL = json[SerializationKeys.wAITINGFORAPPROVAL].int
    cANCELED = json[SerializationKeys.cANCELED].int
    pENDING = json[SerializationKeys.pENDING].int
    rEJECTED = json[SerializationKeys.rEJECTED].int
    dRAFT = json[SerializationKeys.dRAFT].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = aCCEPTED { dictionary[SerializationKeys.aCCEPTED] = value }
    if let value = rAISINGCAPITAL { dictionary[SerializationKeys.rAISINGCAPITAL] = value }
    if let value = fINISHED { dictionary[SerializationKeys.fINISHED] = value }
    if let value = wAITINGFORAPPROVAL { dictionary[SerializationKeys.wAITINGFORAPPROVAL] = value }
    if let value = cANCELED { dictionary[SerializationKeys.cANCELED] = value }
    if let value = pENDING { dictionary[SerializationKeys.pENDING] = value }
    if let value = rEJECTED { dictionary[SerializationKeys.rEJECTED] = value }
    if let value = dRAFT { dictionary[SerializationKeys.dRAFT] = value }
    return dictionary
  }

}
