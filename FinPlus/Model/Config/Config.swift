//
//  Config.swift
//
//  Created by Cao Van Hai on 8/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Config {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let pAYMENTTHRESHOLD = "PAYMENT_THRESHOLD"
    static let investorFee = "investorFee"
    static let faq = "faq"
    static let rateInfo = "rateInfo"
    static let about = "about"
    static let version = "version"
    static let loanStatus = "loanStatus"
    static let policy = "policy"
    static let serviceFee = "serviceFee"
    static let role = "role"
    static let dateLimit = "dateLimit"
    static let relationships = "relationships"
    static let policyBorrow = "policy_borrow"
  }

  // MARK: Properties
  public var pAYMENTTHRESHOLD: Int?
  public var investorFee: Int?
  public var faq: [Faq]?
  public var rateInfo: [RateInfo]?
  public var about: String?
  public var version: String?
  public var loanStatus: LoanStatus?
  public var policy: String?
  public var serviceFee: Int?
  public var role: [Role]?
  public var dateLimit: DateLimit?
  public var relationships: [Relationships]?
    public var policyBorrow: String?

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
    pAYMENTTHRESHOLD = json[SerializationKeys.pAYMENTTHRESHOLD].int
    investorFee = json[SerializationKeys.investorFee].int
    if let items = json[SerializationKeys.faq].array { faq = items.map { Faq(json: $0) } }
    if let items = json[SerializationKeys.rateInfo].array { rateInfo = items.map { RateInfo(json: $0) } }
    about = json[SerializationKeys.about].string
    version = json[SerializationKeys.version].string ?? ""
    loanStatus = LoanStatus(json: json[SerializationKeys.loanStatus])
    policy = json[SerializationKeys.policy].string
    serviceFee = json[SerializationKeys.serviceFee].int
    policyBorrow = json[SerializationKeys.policyBorrow].string
    if let items = json[SerializationKeys.role].array { role = items.map { Role(json: $0) } }
    dateLimit = DateLimit(json: json[SerializationKeys.dateLimit])
    if let items = json[SerializationKeys.relationships].array { relationships = items.map { Relationships(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = pAYMENTTHRESHOLD { dictionary[SerializationKeys.pAYMENTTHRESHOLD] = value }
    if let value = investorFee { dictionary[SerializationKeys.investorFee] = value }
    if let value = faq { dictionary[SerializationKeys.faq] = value.map { $0.dictionaryRepresentation() } }
    if let value = rateInfo { dictionary[SerializationKeys.rateInfo] = value.map { $0.dictionaryRepresentation() } }
    if let value = about { dictionary[SerializationKeys.about] = value }
    if let value = version { dictionary[SerializationKeys.version] = value }
    if let value = loanStatus { dictionary[SerializationKeys.loanStatus] = value.dictionaryRepresentation() }
    if let value = policy { dictionary[SerializationKeys.policy] = value }
    if let value = serviceFee { dictionary[SerializationKeys.serviceFee] = value }
    if let value = role { dictionary[SerializationKeys.role] = value.map { $0.dictionaryRepresentation() } }
    if let value = dateLimit { dictionary[SerializationKeys.dateLimit] = value.dictionaryRepresentation() }
    if let value = relationships { dictionary[SerializationKeys.relationships] = value.map { $0.dictionaryRepresentation() } }
    
    if let value = policyBorrow { dictionary[SerializationKeys.policyBorrow] = value }
    
    return dictionary
  }

}
