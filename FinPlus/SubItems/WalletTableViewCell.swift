//
//  WalletTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

protocol  EditWalletDelegate {
    func editWallet(index: IndexPath)
}

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var hiddenCharLabel: UILabel?
    
    var currentIndex: IndexPath?
    var delegate: EditWalletDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        self.borderView.layer.cornerRadius = 8
        
        self.nameLabel.textColor = UIColor(hexString: "#08121E")
        self.nameLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        
        self.desLabel.textColor = UIColor(hexString: "#4D6678")
        self.desLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editWalletTapped(_ sender: Any) {
        guard let index = self.currentIndex else { return }
        self.delegate?.editWallet(index: index)
    }
    
    
}
