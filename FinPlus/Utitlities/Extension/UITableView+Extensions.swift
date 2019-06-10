//
//  UITableView+Extensions.swift
//  CyberConnect
//
//  Created by Lionel Vũ Thành Đô on 6/4/18.
//  Copyright © 2018 nghiendv. All rights reserved.
//

import Foundation
import UIKit

extension UINib {

    static func nib<T: NSObject>(fromClass type: T.Type) -> UINib? {
        let name = String(describing: type)
        if Bundle.main.path(forResource: name, ofType: "nib") != nil ||
            Bundle.main.path(forResource: name, ofType: "xib") != nil {
            return UINib(nibName: String(describing: T.self), bundle: nil)
        }
        return nil
    }

}

extension UITableView {

    func registerNibCell<T: UITableViewCell>(type: T.Type) {
        register(UINib.nib(fromClass: type), forCellReuseIdentifier: String(describing: type))
    }

    func registerNibHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type) {
        register(UINib.nib(fromClass: type), forHeaderFooterViewReuseIdentifier: String(describing: type))
    }

    func dequeueReusableNibCell<T: UITableViewCell>(type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: type)) as? T
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T
    }

    func registerCell(_ cellID : String) {
        self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}
