//
//  LoanResponseModel.swift
//
//  Created by Cao Van Hai on 5/25/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoanResponseModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let loanId = "loanId"
  }

  // MARK: Properties
  public var loanId: Int32?

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
    loanId = json[SerializationKeys.loanId].int32 ?? 0
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = loanId { dictionary[SerializationKeys.loanId] = value }
    return dictionary
  }

}
