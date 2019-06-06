//
//  LoanTypePopupAddTextTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol PopupAddTextDelegate {
    func beginEditing()
    func endEditing()
    
}

class LoanTypePopupAddTextTBCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView?
    @IBOutlet weak var lblTitle: UILabel?
    
    @IBOutlet weak var tfValue: AnimatableTextField?
    
    var delegate: PopupAddTextDelegate?
    
    var data: LoanBuilderData? {
        didSet {
            guard let data_ = self.data else { return }
            self.tfValue?.placeholder = data_.placeholder
            self.lblTitle?.text = data_.title
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tfValue?.delegate = self
        
        let toolbar = UIToolbar()
        let nextButtonItem = UIBarButtonItem(title: NSLocalizedString("Xong",
                                                                      comment: ""),
                                             style: .done,
                                             target: self,
                                             action: #selector(tfValueNextAction))
        toolbar.items = [nextButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        self.tfValue?.inputAccessoryView = toolbar
        
    }
    
    @objc private func tfValueNextAction() {
        self.tfValue?.endEditing(true)
        self.delegate?.endEditing()
    }
    
    //MARK: Actions
    
    @IBAction func tfValueEditingDidBegin(_ sender: Any) {
        self.delegate?.beginEditing()
    }
    
    @IBAction func tfValueEditingDidEnd(_ sender: Any) {
        self.delegate?.endEditing()
    }
    
    
    
}

//MARK: UITextFieldDelegate
extension LoanTypePopupAddTextTBCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
        
    }
    
}
