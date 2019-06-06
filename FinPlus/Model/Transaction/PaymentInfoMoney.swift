//
//  PaymentInfoMoney.swift
//
//  Created by Cao Van Hai on 8/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PaymentInfoMoney {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let paymentPeriod = "paymentPeriod"
        static let liquidation = "liquidation"
    }
    
    // MARK: Properties
    public var paymentPeriod: PaymentPaymentPeriod?
    public var liquidation: PaymentLiquidation?
    
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
        paymentPeriod = PaymentPaymentPeriod(json: json[SerializationKeys.paymentPeriod])
        liquidation = PaymentLiquidation(json: json[SerializationKeys.liquidation])
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = paymentPeriod { dictionary[SerializationKeys.paymentPeriod] = value.dictionaryRepresentation() }
        if let value = liquidation { dictionary[SerializationKeys.liquidation] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}
