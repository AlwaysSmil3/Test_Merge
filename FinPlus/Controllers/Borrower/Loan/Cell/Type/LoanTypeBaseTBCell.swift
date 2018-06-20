//
//  LoanTypeBaseTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/20/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeBaseTBCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var underLine: UIView?
    @IBOutlet var lblDescriptionNeedUpdate: UILabel?
    
    //Khi thông tin k hợp lệ cần sữa đổi
    var isNeedUpdate: Bool? {
        didSet {
            if let isNeed = self.isNeedUpdate, isNeed {
                //self.lblTitle?.textColor = UIColor(hexString: "#DA3535")
                self.lblDescriptionNeedUpdate?.text = "Số chứng minh thư không hợp lệ"
                self.underLine?.backgroundColor = UIColor(hexString: "#DA3535")
            } else {
                self.lblTitle?.textColor = TEXT_NORMAL_COLOR
                self.underLine?.backgroundColor = UIColor(hexString: "#E3EBF0")
            }
        }
    }
    
    
    
    
    
}
