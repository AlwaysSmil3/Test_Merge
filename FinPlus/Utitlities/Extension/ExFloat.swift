//
//  ExFloat.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
extension Float {
    func toString() -> String {
        if floor(self) == self {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}
