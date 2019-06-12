//
//  LoanStatus.swift
//
//  Created by Cao Van Hai on 8/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanStatus {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sALEPENDING = "SALE_PENDING"
    static let rAISINGCAPITAL = "RAISING_CAPITAL"
    static let rISKREVIEW = "RISK_REVIEW"
    static let fILLED = "FILLED"
    static let cANCELED = "CANCELED"
    static let rEJECTED = "REJECTED"
    static let oVERDUEDEPT = "OVERDUE_DEPT"
    static let dRAFT = "DRAFT"
    static let rISKPENDING = "RISK_PENDING"
    static let pARTIALFILLED = "PARTIAL_FILLED"
    static let sETTLED = "SETTLED"
    static let cONTRACTREADY = "CONTRACT_READY"
    static let cONTRACTSIGNED = "CONTRACT_SIGNED"
    static let sALEREVIEW = "SALE_REVIEW"
    static let tIMELYDEPT = "TIMELY_DEPT"
    static let iNTERESTCONFIRM = "INTEREST_CONFIRM"
    static let iNTERESTCONFIRMEXPIRED = "INTEREST_CONFIRM_EXPIRED"
    static let dISBURSAL = "DISBURSAL"
    static let eXPIRED = "EXPIRED"
  }

  // MARK: Properties
  public var sALEPENDING: Int?
  public var rAISINGCAPITAL: Int?
  public var rISKREVIEW: Int?
  public var fILLED: Int?
  public var cANCELED: Int?
  public var rEJECTED: Int?
  public var oVERDUEDEPT: Int?
  public var dRAFT: Int?
  public var rISKPENDING: Int?
  public var pARTIALFILLED: Int?
  public var sETTLED: Int?
  public var cONTRACTREADY: Int?
  public var cONTRACTSIGNED: Int?
  public var sALEREVIEW: Int?
  public var tIMELYDEPT: Int?
  public var iNTERESTCONFIRM: Int?
  public var iNTERESTCONFIRMEXPIRED: Int?
  public var dISBURSAL: Int?
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
    sALEPENDING = json[SerializationKeys.sALEPENDING].int
    rAISINGCAPITAL = json[SerializationKeys.rAISINGCAPITAL].int
    rISKREVIEW = json[SerializationKeys.rISKREVIEW].int
    fILLED = json[SerializationKeys.fILLED].int
    cANCELED = json[SerializationKeys.cANCELED].int
    rEJECTED = json[SerializationKeys.rEJECTED].int
    oVERDUEDEPT = json[SerializationKeys.oVERDUEDEPT].int
    dRAFT = json[SerializationKeys.dRAFT].int
    rISKPENDING = json[SerializationKeys.rISKPENDING].int
    pARTIALFILLED = json[SerializationKeys.pARTIALFILLED].int
    sETTLED = json[SerializationKeys.sETTLED].int
    cONTRACTREADY = json[SerializationKeys.cONTRACTREADY].int
    cONTRACTSIGNED = json[SerializationKeys.cONTRACTSIGNED].int
    sALEREVIEW = json[SerializationKeys.sALEREVIEW].int
    tIMELYDEPT = json[SerializationKeys.tIMELYDEPT].int
    iNTERESTCONFIRM = json[SerializationKeys.iNTERESTCONFIRM].int
    iNTERESTCONFIRMEXPIRED = json[SerializationKeys.iNTERESTCONFIRMEXPIRED].int
    dISBURSAL = json[SerializationKeys.dISBURSAL].int
    eXPIRED = json[SerializationKeys.eXPIRED].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = sALEPENDING { dictionary[SerializationKeys.sALEPENDING] = value }
    if let value = rAISINGCAPITAL { dictionary[SerializationKeys.rAISINGCAPITAL] = value }
    if let value = rISKREVIEW { dictionary[SerializationKeys.rISKREVIEW] = value }
    if let value = fILLED { dictionary[SerializationKeys.fILLED] = value }
    if let value = cANCELED { dictionary[SerializationKeys.cANCELED] = value }
    if let value = rEJECTED { dictionary[SerializationKeys.rEJECTED] = value }
    if let value = oVERDUEDEPT { dictionary[SerializationKeys.oVERDUEDEPT] = value }
    if let value = dRAFT { dictionary[SerializationKeys.dRAFT] = value }
    if let value = rISKPENDING { dictionary[SerializationKeys.rISKPENDING] = value }
    if let value = pARTIALFILLED { dictionary[SerializationKeys.pARTIALFILLED] = value }
    if let value = sETTLED { dictionary[SerializationKeys.sETTLED] = value }
    if let value = cONTRACTREADY { dictionary[SerializationKeys.cONTRACTREADY] = value }
    if let value = cONTRACTSIGNED { dictionary[SerializationKeys.cONTRACTSIGNED] = value }
    if let value = sALEREVIEW { dictionary[SerializationKeys.sALEREVIEW] = value }
    if let value = tIMELYDEPT { dictionary[SerializationKeys.tIMELYDEPT] = value }
    if let value = iNTERESTCONFIRM { dictionary[SerializationKeys.iNTERESTCONFIRM] = value }
    if let value = iNTERESTCONFIRMEXPIRED { dictionary[SerializationKeys.iNTERESTCONFIRMEXPIRED] = value }
    if let value = dISBURSAL { dictionary[SerializationKeys.dISBURSAL] = value }
    if let value = eXPIRED { dictionary[SerializationKeys.eXPIRED] = value }
    return dictionary
  }

}
