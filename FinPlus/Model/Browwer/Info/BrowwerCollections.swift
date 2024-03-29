//
//  BrowwerCollections.swift
//
//  Created by Cao Van Hai on 8/22/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerCollections {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let interestRate = "interestRate"
    static let status = "status"
    static let id = "id"
    static let createdDate = "createdDate"
    static let principal = "principal"
    static let interest = "interest"
    static let dueDatetime = "dueDatetime"
    static let overdue = "overdue"
    static let loanId = "loanId"
    static let feeOverdue = "feeOverdue"
    
    static let repayPrincipal = "repayPrincipal"
    static let repayInterest = "repayInterest"
    static let repayOverdue = "repayOverdue"
    static let repayFeeOverdue = "repayFeeOverdue"
  }

  // MARK: Properties
  public var interestRate: Int?
  public var status: Int?
  public var id: Int?
  public var createdDate: String?
  public var principal: Int?
  public var interest: Int?
  public var dueDatetime: String?
  public var overdue: Int?
  public var loanId: Int?
  public var feeOverdue: Int?
    
    public var repayPrincipal: Double?
    public var repayInterest: Double?
    public var repayOverdue: Double?
    public var repayFeeOverdue: Double?

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
    interestRate = json[SerializationKeys.interestRate].int ?? 0
    status = json[SerializationKeys.status].int ?? 0
    id = json[SerializationKeys.id].int ?? 0
    createdDate = json[SerializationKeys.createdDate].string ?? ""
    principal = json[SerializationKeys.principal].int ?? 0
    interest = json[SerializationKeys.interest].int ?? 0
    dueDatetime = json[SerializationKeys.dueDatetime].string ?? ""
    overdue = json[SerializationKeys.overdue].int ?? 0
    loanId = json[SerializationKeys.loanId].int ?? 0
    feeOverdue = json[SerializationKeys.feeOverdue].int ?? 0
    
    repayPrincipal = json[SerializationKeys.repayPrincipal].double ?? 0
    repayInterest = json[SerializationKeys.repayInterest].double ?? 0
    repayOverdue = json[SerializationKeys.repayOverdue].double ?? 0
    repayFeeOverdue = json[SerializationKeys.repayFeeOverdue].double ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = interestRate { dictionary[SerializationKeys.interestRate] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
    if let value = principal { dictionary[SerializationKeys.principal] = value }
    if let value = interest { dictionary[SerializationKeys.interest] = value }
    if let value = dueDatetime { dictionary[SerializationKeys.dueDatetime] = value }
    if let value = overdue { dictionary[SerializationKeys.overdue] = value }
    if let value = loanId { dictionary[SerializationKeys.loanId] = value }
    if let value = feeOverdue { dictionary[SerializationKeys.feeOverdue] = value }
    
    if let value = repayFeeOverdue { dictionary[SerializationKeys.repayFeeOverdue] = value }
    if let value = repayOverdue { dictionary[SerializationKeys.repayOverdue] = value }
    if let value = repayInterest { dictionary[SerializationKeys.repayInterest] = value }
    if let value = repayPrincipal { dictionary[SerializationKeys.repayPrincipal] = value }
    
    return dictionary
  }

}
