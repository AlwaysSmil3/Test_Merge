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
    
    weak var parentVC: LoanBaseViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.register(UINib(nibName: "LoanTypePhoneRelationSubNewTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Phone_Relation_Sub_TB_Cell")
        self.mainTableView?.rowHeight = 216
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
        if let phones = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships, phones.count >= 2 {
            for pho in phones {
                if let phoneNumber = pho.phoneNumber, phoneNumber.length() > 0 {
                    var d = LoanBuilderMultipleData(object: NSObject())
                    
                    d.phoneNumber = pho.phoneNumber
                    d.type = pho.type
                    d.name = pho.name
                    d.address = pho.address
                    
                    value.append(d)
                }
            }
        }

        if DataManager.shared.loanInfo.userInfo.relationships.count >= 2 {
            var tempValue: [LoanBuilderMultipleData] = []
            for pho in DataManager.shared.loanInfo.userInfo.relationships {
                if pho.phoneNumber.length() > 0 {
                    var d = LoanBuilderMultipleData(object: NSObject())
                    
                    d.phoneNumber = pho.phoneNumber
                    d.type = Int(pho.type)
                    d.name = pho.name
                    d.address = pho.address
                    
                    tempValue.append(d)
                }
            }
            if tempValue.count > 0 {
                value = tempValue
            }
        }

        if value.count >= 2 {
            
            guard let field_ = self.field, let data_ = field_.multipleData, data_.count >= 2 else { return }
            
            value[0].options = data_[0].options
            value[1].options = data_[1].options
            value[0].placeholder = data_[0].placeholder
            value[1].placeholder = data_[1].placeholder
            
            DataManager.shared.loanInfo.userInfo.relationships.removeAll()
            for (i, pho) in value.enumerated() {
                var d = RelationShipPhone()
                
                d.phoneNumber = pho.phoneNumber ?? ""
                d.type = Int16(pho.type ?? 0)
                d.name = pho.name
                d.address = pho.address
                
                DataManager.shared.loanInfo.userInfo.relationships.append(d)
                
                if i == 0 {
                    if DataManager.shared.currentIndexRelationPhoneSelectedPopup1 == nil {
                        if let index = pho.type {
                            DataManager.shared.currentIndexRelationPhoneSelectedPopup1 = index
                        }
                    }
                } else if i == 1 {
                    if DataManager.shared.currentIndexRelationPhoneSelectedPopup2 == nil {
                        if let index = pho.type {
                            DataManager.shared.currentIndexRelationPhoneSelectedPopup2 = index
                        }
                    }
                }
                
                
            }
            
            self.dataSource = value

        }
    }
    
    /*
    /// Get index from Type(id)
    ///
    /// - Parameter type: <#type description#>
    /// - Returns: <#return value description#>
    private func getIndexFromType(type: Int16) -> Int? {
         guard let field_ = self.field, let data_ = field_.multipleData, data_.count > 1, let options = data_[0].options else { return nil}
        
        for (i, d) in options.enumerated() {
            if type == d.id {
                return i
            }
        }
        
        return nil
    }
    */
    
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
        cell.parentVC = self.parentVC
        
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





