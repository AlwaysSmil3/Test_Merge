//
//  Transaction.swift
//
//  Created by Cao Van Hai on 8/1/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Transaction {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let note = "note"
        static let id = "id"
        static let createdDate = "createdDate"
        static let from = "from"
        static let amount = "amount"
        static let type = "type"
        static let to = "to"
    }
    
    // MARK: Properties
    public var note: String?
    public var id: Int16?
    public var createdDate: String?
    public var from: Int?
    public var amount: Double?
    public var type: Int?
    public var to: Int?
    
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
        note = json[SerializationKeys.note].string ?? ""
        id = json[SerializationKeys.id].int16 ?? 0
        createdDate = json[SerializationKeys.createdDate].string ?? ""
        from = json[SerializationKeys.from].int ?? 0
        amount = json[SerializationKeys.amount].double ?? 0
        type = json[SerializationKeys.type].int ?? 0
        to = json[SerializationKeys.to].int ?? 0
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = note { dictionary[SerializationKeys.note] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
        if let value = from { dictionary[SerializationKeys.from] = value }
        if let value = amount { dictionary[SerializationKeys.amount] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = to { dictionary[SerializationKeys.to] = value }
        return dictionary
    }
    
}
