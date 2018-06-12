//
//  Version.swift
//
//  Created by Cao Van Hai on 5/23/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Config {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let version = "version"
        static let serviceFee = "serviceFee"
        static let loanStatus = "loanStatus"
        static let about = "about"
        static let policy = "policy"
        static let faq = "faq"

    }

    // MARK: Properties
    public var version: String?
    public var serviceFee: Int?
    public var loanStatus : [String: JSON]?
    public var about: String?
    public var policy: String?
    public var faq : [JSON]?

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
        version = json[SerializationKeys.version].string ?? ""
        serviceFee = json[SerializationKeys.serviceFee].int ?? 0
        loanStatus = json[SerializationKeys.loanStatus].dictionary ?? [String: JSON]()
        about = json[SerializationKeys.about].string ?? ""
        policy = json[SerializationKeys.policy].string ?? ""
        faq = json[SerializationKeys.faq].array ?? [JSON]()
        //    public var about: String?
        //    public var policy: String?
        //    public var faq : [[String: String]]?

    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = version { dictionary[SerializationKeys.version] = value }
        if let value = serviceFee { dictionary[SerializationKeys.serviceFee] = value }
        if let value = loanStatus { dictionary[SerializationKeys.loanStatus] = value }
        if let value = about { dictionary[SerializationKeys.about] = value }
        if let value = policy { dictionary[SerializationKeys.policy] = value }
        if let value = faq { dictionary[SerializationKeys.faq] = value }
        return dictionary
    }

}
