//
//  ButtonTableViewCell.swift
//  FinPlus
//
//  Created by nghiendv on 20/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum ButtonCellType {
    case FillType
    case NullType
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    private var buttonCellType: ButtonCellType! = .FillType
    
    func setButtonCellType(type: ButtonCellType) {
        self.buttonCellType = type
        
        if buttonCellType == .FillType {
            self.button?.backgroundColor = MAIN_COLOR
            self.button?.layer.cornerRadius = 8
            self.button?.tintColor = .white
        } else {
            self.button?.backgroundColor = .white
            self.button?.layer.cornerRadius = 8
            self.button?.tintColor = MAIN_COLOR
            self.button?.layer.borderWidth = 1
            self.button?.layer.borderColor = MAIN_COLOR.cgColor
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
