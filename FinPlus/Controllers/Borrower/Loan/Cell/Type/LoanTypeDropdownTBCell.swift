//
//  LoanTypeDropdownTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanTypeDropdownTBCell: UITableViewCell, DataSelectedFromPopupProtocol {
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblValue: UILabel?
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                if field_.isRequired! {
                    self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
                } else {
                    self.lblTitle?.text = title
                }
            }
            
            if let value = field_.selectorTitle {
                self.lblValue?.text = value
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected else { return }
        guard let field_ = self.field, let data = field_.data else { return }
        
        if field_.title == "Nghề nghiệp" || field_.title == "Cấp bậc" {
            let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
            popup.setDataSource(data: data)
            popup.delegate = self
            
            popup.show()
        }
        
    }
    
    
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.lblValue?.text = data.title
    }
    
    
}

