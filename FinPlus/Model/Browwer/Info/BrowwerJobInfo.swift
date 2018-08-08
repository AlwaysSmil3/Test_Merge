//
//  BrowwerJobInfo.swift
//
//  Created by Cao Van Hai on 5/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerJobInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let position = "position"
    static let companyPhoneNumber = "companyPhoneNumber"
    static let salary = "salary"
    static let company = "company"
    static let jobType = "jobType"
    static let address = "address"
    static let jobTitle = "jobTitle"
    static let strength = "strength"
    static let academicLevel = "academicLevel"
    static let experienceYear = "experienceYear"
    static let studentId = "studentId"
  }

  // MARK: Properties
  public var position: Int?
  public var companyPhoneNumber: String?
  public var salary: Int?
  public var company: String?
  public var jobType: Int?
  public var address: BrowwerAddress?
    public var jobTitle: String?
    public var strength: Int?
    public var academicLevel: Int?
    public var experienceYear: Float?
    public var studentId: String?

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
    position = json[SerializationKeys.position].int
    companyPhoneNumber = json[SerializationKeys.companyPhoneNumber].string
    salary = json[SerializationKeys.salary].int
    company = json[SerializationKeys.company].string
    jobType = json[SerializationKeys.jobType].int
    address = BrowwerAddress(json: json[SerializationKeys.address])
    jobTitle = json[SerializationKeys.jobTitle].string
    strength = json[SerializationKeys.strength].int
    academicLevel = json[SerializationKeys.academicLevel].int
    experienceYear = json[SerializationKeys.experienceYear].float
    studentId = json[SerializationKeys.studentId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = position { dictionary[SerializationKeys.position] = value }
    if let value = companyPhoneNumber { dictionary[SerializationKeys.companyPhoneNumber] = value }
    if let value = salary { dictionary[SerializationKeys.salary] = value }
    if let value = company { dictionary[SerializationKeys.company] = value }
    if let value = jobType { dictionary[SerializationKeys.jobType] = value }
    if let value = jobTitle { dictionary[SerializationKeys.jobTitle] = value }
    if let value = address { dictionary[SerializationKeys.address] = value.dictionaryRepresentation() }
    if let value = strength { dictionary[SerializationKeys.strength] = value }
    if let value = academicLevel { dictionary[SerializationKeys.academicLevel] = value }
    if let value = experienceYear { dictionary[SerializationKeys.experienceYear] = value }
    if let value = studentId { dictionary[SerializationKeys.studentId] = value }
    return dictionary
  }

}
