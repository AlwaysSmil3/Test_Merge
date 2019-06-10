//
//  ExNSObject.swift
//  FinPlus
//
//  Created by AlwaysSmile on 6/7/19.
//  Copyright © 2019 Cao Van Hai. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
//    var className: String {
//        return String(describing: self)
//    }
}
