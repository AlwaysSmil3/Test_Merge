//
//  LoanTypePhoneRelationSubTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/10/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypePhoneRelationSubTBCell: UITableViewCell {
    
    
    @IBOutlet weak var tfTypeRelation: UITextField?
    
    @IBOutlet weak var tfRelationPhone: UITextField?
    
    var data: LoanBuilderMultipleData? {
        didSet {
            guard let data_ = data else { return }
            
            self.tfRelationPhone?.placeholder = data_.placeholder

        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tfRelationPhone?.delegate = self
    }
    
    
    //MARK: Actions
    
    @IBAction func tfEditEnd(_ sender: Any) {
        if let value = self.tfRelationPhone?.text {
            DataManager.shared.loanInfo.userInfo.relationships.phoneNumber = value
        }
    }
    
    @IBAction func btnTypeRelationTapped(_ sender: Any) {
        guard let data_ = self.data, let options = data_.options else { return }
        
        var dataSource: [LoanBuilderData] = []
        for i in options {
            var da = LoanBuilderData(object: NSObject())
            da.id = i.id
            da.title = i.title
            dataSource.append(da)
        }
        
        let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
        popup.setDataSource(data: dataSource, type: .RelationShipPhone)
        popup.delegate = self
        
        popup.show()
    }
    

    
    
    
}

//MARK: TextField Delegate
extension LoanTypePhoneRelationSubTBCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Giới hạn ký tự nhập vào
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > maxLength { return false }
        
        return true
    }
    
    
}

//MARK: Data Selected from popup
extension LoanTypePhoneRelationSubTBCell: DataSelectedFromPopupProtocol {
    //MARK: Data Selected
    func dataSelected(data: LoanBuilderData) {
        self.tfTypeRelation?.text = data.title!
        self.tfRelationPhone?.placeholder = "Số điện thoại của " + data.title!
        DataManager.shared.loanInfo.userInfo.relationships.type = data.id!
    }
    

}





