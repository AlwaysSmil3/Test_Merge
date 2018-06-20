//
//  LoanOtherInfoCollectionCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol OptionMediaDelegate {
    func deleteOptionMedia(index: Int)
}

class LoanOtherInfoCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgValue: UIImageView!
    @IBOutlet var imgAdd: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    
    var currentSelectedCollection: IndexPath?
    
    var delegate: OptionMediaDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgValue.layer.cornerRadius = 3
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        guard let index = self.currentSelectedCollection else { return }
        
        delegate?.deleteOptionMedia(index: index.row)
    }
    
}
