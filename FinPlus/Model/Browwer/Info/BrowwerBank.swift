//
//  BrowwerBank.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/24/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BrowwerBank {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let type = "type"
        static let accountHolder = "accountHolder"
        static let accountNumber = "accountNumber"
        static let branch = "branch"
    }
    
    // MARK: Properties
    public var id: Int32?
    public var type: String?
    public var accountHolder: String?
    public var accountNumber: String?
    public var branch: String?
    
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
        id = json[SerializationKeys.id].int32
        type = json[SerializationKeys.type].string
        accountHolder = json[SerializationKeys.accountHolder].string
        accountNumber = json[SerializationKeys.accountNumber].string
        branch = json[SerializationKeys.branch].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = accountNumber { dictionary[SerializationKeys.accountNumber] = value }
        if let value = accountHolder { dictionary[SerializationKeys.accountHolder] = value }
        if let value = branch { dictionary[SerializationKeys.branch] = value }
        return dictionary
    }
    
}
