//
//  LoanTypeChoiceCollectionCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/9/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeChoiceCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: AnimatableView?
    @IBOutlet weak var lblValue: UILabel?
    
    var data: LoanBuilderData? {
        didSet {
            guard let data_ = self.data else { return }
            self.lblValue?.text = data_.title
            
        }
    }
    
    var isSelectedCell: Bool = false {
        didSet {
            guard isSelectedCell else {
                self.parentView?.borderColor = UIColor(hexString: "#8EA3AF")
                self.lblValue?.textColor = UIColor(hexString: "#8EA3AF")
                
                return
            }
            
            self.parentView?.borderColor = UIColor(hexString: "#3EAA5F")
            self.lblValue?.textColor = UIColor(hexString: "#08121E")
            
        }
    }
    
    
}
