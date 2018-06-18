//
//  BrowwerActiveLoan.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerActiveLoan {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let walletId = "walletId"
    static let optionalMedia = "optionalMedia"
    static let status = "status"
    static let nationalIdBackImg = "nationalIdBackImg"
    static let nationalIdFrontImg = "nationalIdFrontImg"
    static let jobInfo = "jobInfo"
    static let term = "term"
    static let amount = "amount"
    static let loanId = "loanId"
    static let optionalText = "optionalText"
    static let userInfo = "userInfo"
    static let loanCategoryId = "loanCategoryId"
    static let createdTime = "createdTime"
  }

  // MARK: Properties
  public var walletId: Int?
  public var optionalMedia: [String]?
  public var status: Int?
  public var nationalIdBackImg: String?
  public var nationalIdFrontImg: String?
  public var jobInfo: BrowwerJobInfo?
  public var term: Int?
  public var amount: Int32?
  public var loanId: Int32?
  public var optionalText: String?
  public var userInfo: BrowwerUserInfo?
  public var loanCategoryId: Int16?
    public var createdTime: String?

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
    walletId = json[SerializationKeys.walletId].int ?? 0
    if let items = json[SerializationKeys.optionalMedia].array { optionalMedia = items.map { $0.stringValue } }
    status = json[SerializationKeys.status].int ?? 0
    nationalIdBackImg = json[SerializationKeys.nationalIdBackImg].string ?? ""
    nationalIdFrontImg = json[SerializationKeys.nationalIdFrontImg].string ?? ""
    jobInfo = BrowwerJobInfo(json: json[SerializationKeys.jobInfo])
    term = json[SerializationKeys.term].int ?? 0
    amount = json[SerializationKeys.amount].int32 ?? 0
    loanId = json[SerializationKeys.loanId].int32 ?? 0
    optionalText = json[SerializationKeys.optionalText].string ?? ""
    userInfo = BrowwerUserInfo(json: json[SerializationKeys.userInfo])
    loanCategoryId = json[SerializationKeys.loanCategoryId].int16 ?? 0
    createdTime = json[SerializationKeys.createdTime].string ?? ""
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = walletId { dictionary[SerializationKeys.walletId] = value }
    if let value = optionalMedia { dictionary[SerializationKeys.optionalMedia] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = nationalIdBackImg { dictionary[SerializationKeys.nationalIdBackImg] = value }
    if let value = nationalIdFrontImg { dictionary[SerializationKeys.nationalIdFrontImg] = value }
    if let value = jobInfo { dictionary[SerializationKeys.jobInfo] = value.dictionaryRepresentation() }
    if let value = term { dictionary[SerializationKeys.term] = value }
    if let value = amount { dictionary[SerializationKeys.amount] = value }
    if let value = loanId { dictionary[SerializationKeys.loanId] = value }
    if let value = optionalText { dictionary[SerializationKeys.optionalText] = value }
    if let value = userInfo { dictionary[SerializationKeys.userInfo] = value.dictionaryRepresentation() }
    if let value = loanCategoryId { dictionary[SerializationKeys.loanCategoryId] = value }
    if let value = createdTime { dictionary[SerializationKeys.createdTime] = value }
    return dictionary
  }

}
