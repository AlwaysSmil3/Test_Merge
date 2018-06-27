//
//  ProfileHeaderView.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    func changeAvatar(_ header: ProfileHeaderView)
}

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var delegate: ProfileHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarBtn.layer.cornerRadius = self.avatarBtn.frame.size.width/2
        self.avatarBtn.layer.masksToBounds = true
        
        usernameLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SEMIBIG)
        phoneLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @IBAction func changeAvatar(_ sender: UIButton) {
        delegate?.changeAvatar(self)
    }
}
