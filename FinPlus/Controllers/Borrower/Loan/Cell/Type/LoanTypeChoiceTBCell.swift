//
//  LoanTypeChoiceTBCell.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/9/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypeChoiceTBCell: LoanTypeBaseTBCell, LoanTypeTBCellProtocol {
    
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    //Giới tính
    var gender: Gender? {
        didSet {
            guard let g = self.gender else { return }
            guard let field_ = self.field, let id = field_.id else { return }
            
            if let valueTemp_ = self.valueTemp {
                if valueTemp_ == "\(g.rawValue)" {
                    self.updateInfoFalse(pre: field_.title ?? "")
                } else {
                    self.isNeedUpdate = false
                }
            }
            
            if id.contains("gender") {
                DataManager.shared.loanInfo.userInfo.gender = "\(g.rawValue)"
            } else if id.contains("optionalText") {
                if let index = field_.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                    DataManager.shared.loanInfo.optionalText[index] = "\(g.rawValue)"
                }
            }
        }
    }
    
    var currentSelectedCollection: IndexPath? {
        didSet {
            guard let current = self.currentSelectedCollection else { return }
            if let cell = self.mainCollectionView.cellForItem(at: current) as? LoanTypeChoiceCollectionCell {
                cell.isSelectedCell = true
            }
            
            if current.row == 0 {
                self.gender = .Male
            } else {
                self.gender = .Female
            }
            
        }
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
            self.getData()
            self.dataSourceCollection = field_.data ?? []
            
        }
    }
    
    //DataSource CollectionView
    var dataSourceCollection: [LoanBuilderData] = [] {
        didSet {
            guard dataSourceCollection.count > 0 else { return }
            self.mainCollectionView?.reloadData()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle?.font = FONT_CAPTION
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView?.register(UINib(nibName: "LoanTypeChoiceCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Loan_Type_Choice_Collection_Cell")
        
    }
    
    //Update Data khi co khoan vay
    func getData() {
        guard let field_ = self.field, let id = field_.id, let title = field_.title else { return }
        
        if id.contains("gender") {
            
            var value = ""
            if let data = DataManager.shared.browwerInfo?.activeLoan?.userInfo?.gender, data.length() > 0 {
                value = data
            }
            
            if DataManager.shared.loanInfo.userInfo.gender.length() > 0 {
                value = DataManager.shared.loanInfo.userInfo.gender
            }
            
            if value.length() > 0 {
                if value == "1" {
                    self.currentSelectedCollection = IndexPath(row: 1, section: 0)
                } else {
                    self.currentSelectedCollection = IndexPath(row: 0, section: 0)
                    
                }
                
                DataManager.shared.loanInfo.userInfo.gender = value
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "gender") {
                //Cap nhat thong tin khong hop le
                if self.valueTemp == nil {
                    self.valueTemp = value
                    self.updateInfoFalse(pre: title)
                }
                
                
            }
            
            
        } else if id.contains("optionalText") {
            //thông tin khác
            
            var index = 0
            if let i = field_.arrayIndex {
                index = i
            }
            
            guard let data = DataManager.shared.browwerInfo?.activeLoan?.optionalText, data.count > index, DataManager.shared.loanInfo.optionalText.count > index else { return }
            
            var value = ""
            if data.count > 0 {
                value = data[index]
            }
            
            if DataManager.shared.loanInfo.optionalText[index].length() > 0 {
                value = DataManager.shared.loanInfo.optionalText[index]
            }
            
            if value.length() > 0 {
                if value == "Nam" || value == "0" {
                    self.currentSelectedCollection = IndexPath(row: 0, section: 0)
                } else {
                    self.currentSelectedCollection = IndexPath(row: 1, section: 0)
                    
                }
                DataManager.shared.loanInfo.optionalText[index] = value
            }
            
            if DataManager.shared.checkFieldIsMissing(key: "optionalText") {
                //Cap nhat thong tin khong hop le
                if let arrayIndex = field_.arrayIndex, let data = DataManager.shared.missingOptionalText {
                    
                    if let text = data["\(arrayIndex)"] as? String {
                        //Cap nhat thong tin khong hop le
                        print("OptionalText \(text)")
                        if self.valueTemp == nil {
                            
                            if value == "Nam" || value == "0" {
                                self.valueTemp = "0"
                            } else {
                                self.valueTemp = "1"
                            }
                            
                            self.updateInfoFalse(pre: title)
                        }
                        
                    }
                }
            }
        }
    }
    
    
}

extension LoanTypeChoiceTBCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loan_Type_Choice_Collection_Cell", for: indexPath) as! LoanTypeChoiceCollectionCell
        cell.data = self.dataSourceCollection[indexPath.row]
        
        if let indexPath_ = self.currentSelectedCollection, indexPath_ == indexPath {
            cell.isSelectedCell = true
        } else {
            cell.isSelectedCell = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let indexPrev = self.currentSelectedCollection {
            let cellPev = collectionView.cellForItem(at: indexPrev) as! LoanTypeChoiceCollectionCell
            cellPev.isSelectedCell = false
        }
        
        self.currentSelectedCollection = indexPath
        
    }
    
    /**
     * Initial size
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.dataSourceCollection.count {
        case 2:
            return CGSize(width: (BOUND_SCREEN.size.width - 16 * 2 - 10) / 2, height: 30)
        case 3:
            return CGSize(width: (BOUND_SCREEN.size.width - 16 * 2 - 10 * 2) / 3, height: 30)
        default:
            return CGSize(width: 116, height: 30)
        }
        
        
    }
    
}


