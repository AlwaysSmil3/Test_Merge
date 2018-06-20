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
            self.button.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
            self.button.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
            self.button?.backgroundColor = MAIN_COLOR
            self.button?.tintColor = .white
        } else {
            self.button.setBackgroundColor(color: .white, forState: .normal)
            self.button.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
            self.button?.tintColor = MAIN_COLOR
            self.button?.layer.borderWidth = 1
            self.button?.layer.borderColor = MAIN_COLOR.cgColor
        }
        
        self.button?.layer.cornerRadius = 8
        self.button?.layer.masksToBounds = true
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

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
