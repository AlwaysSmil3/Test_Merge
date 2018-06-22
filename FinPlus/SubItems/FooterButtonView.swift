//
//  FooterButtonView.swift
//  FinPlus
//
//  Created by nghiendv on 21/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class FooterButtonView: UITableViewHeaderFooterView {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.button.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
        self.button.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
        self.button?.backgroundColor = MAIN_COLOR
        self.button?.tintColor = .white
    }
    
}
