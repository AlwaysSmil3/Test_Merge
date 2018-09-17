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
        
        if DataManager.shared.checkFieldIsMissing(key: "relationships") && (DataManager.shared.isRelationPhone1Invalid || DataManager.shared.isRelationPhone2Invalid) {
            //Cap nhat thong tin khong hop le
            self.updateInfoFalse(pre: self.field?.title ?? "")
        } else {
            self.isNeedUpdate = false
        }
        
        var value: [LoanBuilderMultipleData] = []
        if let phones = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships, phones.count == 2 {
            for pho in phones {
                if let phoneNumber = pho.phoneNumber, phoneNumber.length() > 0 {
                    var d = LoanBuilderMultipleData(object: NSObject())
                    
                    d.phoneNumber = pho.phoneNumber
                    d.type = pho.type
                    value.append(d)
                }
            }
        }

        if DataManager.shared.loanInfo.userInfo.relationships.count == 2 {
            var tempValue: [LoanBuilderMultipleData] = []
            for pho in DataManager.shared.loanInfo.userInfo.relationships {
                if pho.phoneNumber.length() > 0 {
                    var d = LoanBuilderMultipleData(object: NSObject())
                    
                    d.phoneNumber = pho.phoneNumber
                    d.type = Int(pho.type)
                    tempValue.append(d)
                }
            }
            if tempValue.count > 0 {
                value = tempValue
            }
        }

        if value.count == 2 {
            
            guard let field_ = self.field, let data_ = field_.multipleData, data_.count == 2 else { return }
            
            value[0].options = data_[0].options
            value[1].options = data_[1].options
            value[0].placeholder = data_[0].placeholder
            value[1].placeholder = data_[1].placeholder
            
            DataManager.shared.loanInfo.userInfo.relationships.removeAll()
            for pho in value {
                var d = RelationShipPhone()
                
                d.phoneNumber = pho.phoneNumber ?? ""
                d.type = Int16(pho.type ?? 0)
                DataManager.shared.loanInfo.userInfo.relationships.append(d)
            }
            
            self.dataSource = value

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
        cell.delegateUpdateStatusInvalid = self
        cell.currentIndex = indexPath.row
        cell.data = self.dataSource[indexPath.row]
        
        return cell
    }
    
    
}

//MARK: UpdateStatusInvalidRelationPhoneDelegate
extension LoanTypePhoneRelationTBCell: UpdateStatusInvalidRelationPhoneDelegate {
    func update(isNeed: Bool) {
        if isNeed {
            self.updateInfoFalse(pre: self.field?.title ?? "")
            return
        }
        self.isNeedUpdate = isNeed
    }
}





