//
//  ResidentAddress.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

struct Address: Encodable {
    
    var city: String
    var district: String
    var commune: String
    var street: String
    var zipCode: String
    var long: Double
    var lat: Double
    
    init() {
        self.city = ""
        self.district = ""
        self.commune = ""
        self.street = ""
        self.zipCode = "66666"
        self.long = 0.0
        self.lat = 0.0
    }
    
    init(city: String, district: String, commune: String, street: String, zipCode: String, long: Double, lat: Double) {
        
        self.city = city
        self.district = district
        self.commune = commune
        self.street = street
        self.zipCode = zipCode
        self.long = long
        self.lat = lat
        
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case district
        case commune
        case street
        case zipCode
        case longitude
        case latitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(district, forKey: .district)
        try container.encode(commune, forKey: .commune)
        try container.encode(street, forKey: .street)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(long, forKey: .longitude)
        try container.encode(lat, forKey: .latitude)
        
    }

}
