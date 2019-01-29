//
//  LoanTypeRelationPhoneTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

let ROW_HEIGHT_RELATIONSHIP_TB_CELL: CGFloat = 146 //old 216
let ROW_HEIGHT_REFERENCEFRIEND_TB_CELL: CGFloat = 291

class LoanTypePhoneRelationTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    

    @IBOutlet weak var mainTableView: UITableView?
    
    @IBOutlet weak var heightMainTableViewConstraint: NSLayoutConstraint!
    
    weak var parentVC: LoanBaseViewController?
    
    var isRelationShip: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.register(UINib(nibName: "LoanTypePhoneRelationSubNewTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Phone_Relation_Sub_TB_Cell")
        self.mainTableView?.register(UINib(nibName: "LoanTypeReferenceFriendTBCell", bundle: nil), forCellReuseIdentifier: "LoanTypeReferenceFriendTBCell")
        self.mainTableView?.rowHeight = ROW_HEIGHT_RELATIONSHIP_TB_CELL
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
        guard let field_ = self.field, let id = field_.id else { return }
        
        if id.contains("referenceFriend") {
            if self.mainTableView?.rowHeight == ROW_HEIGHT_RELATIONSHIP_TB_CELL {
                self.mainTableView?.rowHeight = ROW_HEIGHT_REFERENCEFRIEND_TB_CELL
                if self.dataSource.count > 0 {
                    self.heightMainTableViewConstraint.constant = CGFloat(Int(ROW_HEIGHT_REFERENCEFRIEND_TB_CELL) * self.dataSource.count)
                }
                
                self.parentVC?.mainTBView?.reloadData()
            }
            
            if self.isRelationShip {
                self.isRelationShip = false
            }
            
            self.getDataForReferenceFriend()
            
        } else {
            if self.mainTableView?.rowHeight == ROW_HEIGHT_REFERENCEFRIEND_TB_CELL || (self.heightMainTableViewConstraint.constant != CGFloat(Int(ROW_HEIGHT_RELATIONSHIP_TB_CELL) * self.dataSource.count)) {
                self.mainTableView?.rowHeight = ROW_HEIGHT_RELATIONSHIP_TB_CELL
                if self.dataSource.count > 0 {
                    self.heightMainTableViewConstraint.constant = CGFloat(Int(ROW_HEIGHT_RELATIONSHIP_TB_CELL) * self.dataSource.count)
                }
                self.parentVC?.mainTBView?.reloadData()
            }
            
            if !self.isRelationShip {
                self.isRelationShip = true
            }
            
            self.getDataForRelationship()
        }
        
    }
    
    
    /// Get Data for relationship
    private func getDataForRelationship() {
        if DataManager.shared.checkFieldIsMissing(key: "relationships") && (DataManager.shared.isRelationPhone1Invalid || DataManager.shared.isRelationPhone2Invalid) {
            //Cap nhat thong tin khong hop le
            self.updateInfoFalse(pre: self.field?.title ?? "")
        } else {
            
            if let need = self.isNeedUpdate, need {
                self.isNeedUpdate = false
            }
        }
        
        var value: [LoanBuilderMultipleData] = []
        if let phones = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.relationships, phones.count > 0 {
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
        
        if DataManager.shared.loanInfo.userInfo.relationships.count > 0 {
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
        
        if value.count > 0 {
            
            guard let field_ = self.field, let data_ = field_.multipleData, data_.count > 0 else { return }
            
            for (i, d_) in data_.enumerated() {
                if value.count > i {
                    value[i].options = d_.options
                    value[i].placeholder = d_.placeholder
                }
                
            }
            
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
    
    private func getDataForReferenceFriend() {
        
        if DataManager.shared.checkFieldIsMissing(key: "referenceFriend") && (DataManager.shared.isReferenceFriend1Invalid || DataManager.shared.isReferenceFriend2Invalid || DataManager.shared.isReferenceFriend3Invalid) {
            //Cap nhat thong tin khong hop le
            self.updateInfoFalse(pre: self.field?.title ?? "")
        } else {
            if let need = self.isNeedUpdate, need {
                self.isNeedUpdate = false
            }
        }
        
        var value: [LoanBuilderMultipleData] = []
        
        if let references = DataManager.shared.loanInfo.userInfo.referenceFriend, references.count > 0 {
            var tempValue: [LoanBuilderMultipleData] = []
            for pho in references {
                
                var d = LoanBuilderMultipleData(object: NSObject())
                
                d.phoneNumber = pho.phoneNumber
                d.type = Int(pho.type)
                d.name = pho.name
                d.address = pho.address
                d.loanPurpose = pho.loanPurpose
                
                tempValue.append(d)
                
            }
            if tempValue.count > 0 {
                value = tempValue
            }
        } else {
            DataManager.shared.checkAndInitReferenceFriend()
        }
        
        
        if value.count > 0 {
            
            guard let field_ = self.field, let data_ = field_.multipleData, data_.count > 0 else { return }
            
            for (i, d_) in data_.enumerated() {
                if value.count > i {
                    value[i].options = d_.options
                    value[i].placeholder = d_.placeholder
                }
                
            }
            
            /*
            for (i, pho) in value.enumerated() {
                var d = RelationShipPhone()
                
                d.phoneNumber = pho.phoneNumber ?? ""
                d.type = Int16(pho.type ?? 0)
                d.name = pho.name
                d.address = pho.address
                d.loanPurpose = pho.loanPurpose
                
                DataManager.shared.loanInfo.userInfo.referenceFriend?[i] = d
            }
            */
            
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
        
        guard self.isRelationShip else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoanTypeReferenceFriendTBCell", for: indexPath) as! LoanTypeReferenceFriendTBCell
            cell.delegateUpdateStatusInvalid = self
            cell.currentIndex = indexPath.row
            cell.data = self.dataSource[indexPath.row]
            cell.parentVC = self.parentVC
            
            return cell
            
        }
        
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





