//
//  TitleTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 20/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum TextCellType {
    case TitleType
    case DesType
}

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var label: UILabel!
    private var textCellType: TextCellType = .TitleType
    
    func setTextCellType(type: TextCellType) {
        self.textCellType = type
        
        if textCellType == .TitleType {
            label.font = UIFont.boldSystemFont(ofSize: 26)
            label.textColor = .black
        }
        else
        {
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor(hexString: "#4D6678")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
