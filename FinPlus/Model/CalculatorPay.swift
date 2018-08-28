//
//  CalculatorPay.swift
//  FinPlus
//
//  Created by nghiendv on 27/08/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CalculatorPay {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let dueDatetime = "dueDatetime"
        static let principal = "principal"
        static let interest = "interest"
    }
    
    // MARK: Properties
    public var dueDatetime: String?
    public var principal: Int?
    public var interest: Int?
    
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
        dueDatetime = json[SerializationKeys.dueDatetime].string ?? ""
        principal = json[SerializationKeys.principal].int ?? 0
        interest = json[SerializationKeys.interest].int ?? 0
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = dueDatetime { dictionary[SerializationKeys.dueDatetime] = value }
        if let value = principal { dictionary[SerializationKeys.principal] = value }
        if let value = interest { dictionary[SerializationKeys.interest] = value }
        return dictionary
    }
    
}

