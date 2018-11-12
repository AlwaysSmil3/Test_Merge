//
//  LoanTypeBaseTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/20/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeBaseTBCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var underLine: UIView?
    @IBOutlet weak var lblDescriptionNeedUpdate: UILabel?
    
    var valueTemp: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    //Khi thông tin k hợp lệ cần sữa đổi
    var isNeedUpdate: Bool? {
        didSet {
            if let isNeed = self.isNeedUpdate, isNeed {
                self.underLine?.backgroundColor = UIColor(hexString: "#DA3535")
            } else {
                self.underLine?.backgroundColor = LIGHT_MODE_BORDER_COLOR
                self.lblDescriptionNeedUpdate?.text = ""
            }
        }
    }
    
    
    /// Khi server trả về thông tin cần cập nhật
    ///
    /// - Parameter pre: <#pre description#>
    func updateInfoFalse(pre: String) {
        guard let id = DataManager.shared.browwerInfo?.activeLoan?.loanId, id > 0 else {
            return
        }
        self.isNeedUpdate = true
        self.lblDescriptionNeedUpdate?.text = pre + " không hợp lệ"
    }
    
    
    
    
}
