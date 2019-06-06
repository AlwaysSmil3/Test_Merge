//
//  Notification.swift
//
//  Created by Cao Van Hai on 8/16/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NotificationModel {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let status = "status"
        static let title = "title"
        static let messages = "messages"
        static let id = "id"
        static let type = "type"
        static let createdDate = "createdDate"
    }
    
    // MARK: Properties
    public var status: Bool? = false
    public var title: String?
    public var messages: String?
    public var id: Int?
    public var type: String?
    public var createdDate: String?
    
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
        status = json[SerializationKeys.status].boolValue
        title = json[SerializationKeys.title].string ?? ""
        messages = json[SerializationKeys.messages].string ?? ""
        id = json[SerializationKeys.id].int ?? 0
        type = json[SerializationKeys.type].string ?? ""
        createdDate = json[SerializationKeys.createdDate].string ?? ""
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.status] = status
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = messages { dictionary[SerializationKeys.messages] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
        return dictionary
    }
    
}
