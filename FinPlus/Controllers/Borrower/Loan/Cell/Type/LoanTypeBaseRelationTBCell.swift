//
//  LoanTypeBaseRelationTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 1/2/19.
//  Copyright © 2019 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeBaseRelationTBCell: UITableViewCell {
    
    @IBOutlet weak var tfTypeRelation: UITextField?
    @IBOutlet weak var lblTitlePhone: UILabel?
    @IBOutlet weak var tfRelationPhone: UITextField?
    @IBOutlet weak var lblNameRelationTitle: UILabel?
    @IBOutlet weak var tfNameRelation: UITextField?
    @IBOutlet weak var lblAddressRelationTitle: UILabel?
    @IBOutlet weak var lblAddressRelation: UILabel?
    
    var currentIndex = 0
    weak var parentVC: LoanBaseViewController?
    weak var delegateUpdateStatusInvalid: UpdateStatusInvalidRelationPhoneDelegate?
    
    func getTitleTypeRelation(id: Int) -> String {
        let text = self.currentIndex == 0 ? "1" : "2"
        guard let cate = DataManager.shared.getCurrentCategory(), (cate.builders?.count ?? 0) > 0, let fields = cate.builders![0].fieldsDisplay else { return text }
        
        var field: LoanBuilderFields?
        for f in fields {
            if f.id == "relationships" {
                field = f
                break
            }
        }
        
        guard let muiltiData = field?.multipleData else { return text }
        
        for mu in muiltiData {
            if let options = mu.options {
                for op in options {
                    if id == Int(op.id ?? 0) {
                        return op.title ?? text
                    }
                }
            }
        }
        
        return text
    }
    
    func getDisplayPhone(relationPhone: String) -> String {
        var phone = relationPhone
        if relationPhone.contains("_") {
            let array = relationPhone.components(separatedBy: "_")
            if array.count > 0 {
                phone = array[0]
            }
        }
        return FinPlusHelper.updatePhoneNumber(phone:phone)
    }
    
}
