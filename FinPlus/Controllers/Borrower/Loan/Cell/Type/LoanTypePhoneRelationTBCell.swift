//
//  LoanTypeRelationPhoneTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypePhoneRelationTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet weak var mainTableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.register(UINib(nibName: "LoanTypePhoneRelationSubTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Phone_Relation_Sub_TB_Cell")
        self.mainTableView?.tableFooterView = UIView()
        
    }
    
    var field: LoanBuilderFields? {
        didSet {
            guard let field_ = self.field else { return }
            
            if let title = field_.title {
                if field_.isRequired! {
                    self.lblTitle?.attributedText = FinPlusHelper.setAttributeTextForLoan(text: title)
                } else {
                    self.lblTitle?.text = title
                }
            }
            
            
            if let data = field_.multipleData {
                self.dataSource = data
            }
            
            self.getData()
        }
    
    }
    
    var dataSource: [LoanBuilderMultipleData] = [] {
        didSet {
            self.mainTableView?.reloadData()
        }
    }
    
    func getData() {
        
        var value = ""
        if let phone = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships?.phoneNumber, phone.length() > 0 {
            value = phone
        }
        
        if DataManager.shared.loanInfo.userInfo.relationships.phoneNumber.length() > 0 {
            value = DataManager.shared.loanInfo.userInfo.relationships.phoneNumber
        }
        
        if value.length() > 0 {
            DataManager.shared.loanInfo.userInfo.relationships.phoneNumber = value
            
        }
    }
    
    
}


//MARK: TableViewDelegate, DataSource
extension LoanTypePhoneRelationTBCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Phone_Relation_Sub_TB_Cell", for: indexPath) as! LoanTypePhoneRelationSubTBCell
        cell.data = self.dataSource[indexPath.row]
        
        return cell
    }
    
    
    
}





