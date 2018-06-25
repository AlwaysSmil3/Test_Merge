//
//  InvestorTextFieldTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorTextFieldTableViewCell: UITableViewCell {

    fileprivate var editting: ((String?) -> Void)?

    @IBOutlet weak var fieldTf: UITextField!
    @IBOutlet weak var titleLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldTf.clearButtonMode = .whileEditing

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func editTf(currentText: String, _ editting: ((String?) -> Void)?) {
        self.editting = editting
        fieldTf.text = currentText
        fieldTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        editting?(textField.text)
    }
    
}
