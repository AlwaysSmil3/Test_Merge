//
//  LoanTypePhoneRelationPopupVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


/// Data trả về sau khi chọn
protocol DataSelectedFromPopupProtocol: class {
    func dataSelected(data: LoanBuilderData)
    func multiDataSelected(value: String, listIndex: String)
}

enum TypePopup: Int {
    case Categories = 0 // list Category
    case RelationShipPhone // Số điện thoại nguoi than
    case Job // Công việc
    case JobPosition // chức vụ
    case Strength // Học lực
    case AcademicLevel // Trinh độ học vấn
    case TypeMobilePhone // Loai dien thoai su dung
    case CareerHusbandOrWife // Nghề nghiệp của vợ hoặc chồng
    case TypeLoanedFrom // Đã từng vay tiền ở đâu
    case ReferenceFriend // Bạn cùng vay
    case HouseType // Loai hinh so huu nha
    case MaritalStatus // Tinh trang hon nhan
}

class LoanTypePopupVC: BasePopup {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var mainTBView: UITableView?
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    weak var delegate: DataSelectedFromPopupProtocol?
    
    
    //Dữ liệu đầu vào
    private var dataSource: [LoanBuilderData] = [] {
        didSet {
            self.mainTBView?.reloadData()
        }
    }
    
    /// Cell đang chọn
    private var currentIndex: Int? {
        didSet {
            self.mainTBView?.reloadData()
        }
    }
    
    //Loại popup
    var type: TypePopup?
    
    var titleString: String = "Thông báo"
    var otherTextSelection: String?
    
    var indexRelationPhone: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView?.tableFooterView = UIView()
        self.mainTBView?.separatorColor = UIColor.clear
        self.mainTBView?.rowHeight = UITableViewAutomaticDimension
        self.mainTBView?.register(UINib(nibName: "LoanTypePopupAddTextTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Popup_Add_Text_TB_Cell")
        
        self.updateSelected()
        
        self.lblTitle?.text = titleString
        
        if self.currentIndex == nil {
            self.updateDataSelectedFromServer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToSelection()
        }
        
    }
    
    func scrollToSelection() {
        if let index = self.currentIndex {
            self.mainTBView?.scrollToRow(at: IndexPath(row: index, section: 0), at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    
    /// Check index Selection Relation Phone
    ///
    /// - Parameter index: <#index description#>
    /// - Returns: <#return value description#>
    private func checkSelectionRelationPhone(index: Int) -> Bool {
        guard let type_ = self.type, type_ == TypePopup.RelationShipPhone else { return true }
        
        if self.indexRelationPhone == 0 {
            if DataManager.shared.currentIndexRelationPhoneSelectedPopup2 == index {
                self.showToastWithMessage(message: "Không được chọn trùng lặp loại người thân")
                return false
            }
        } else {
            if DataManager.shared.currentIndexRelationPhoneSelectedPopup1 == index {
                self.showToastWithMessage(message: "Không được chọn trùng lặp loại người thân")
                return false
            }
        }
        
        
        return true
    }
    
    
    /// set DataSource for tableView
    ///
    /// - Parameter data: <#data description#>
    func setDataSource(data: [LoanBuilderData], type: TypePopup? = nil) {
        if let type_ = type {
            self.type = type_
        }
        self.dataSource = data
        
    }
    
    private func updateDataSelectedFromServer() {
        guard let type_ = self.type else { return }
        switch type_ {
        case .Categories:
            self.updateCurrentIndex(i: Int(DataManager.shared.loanInfo.loanCategoryID))
            
            break
        case .RelationShipPhone:
            
            guard let indexRelation = self.indexRelationPhone, indexRelation < DataManager.shared.loanInfo.userInfo.relationships.count else { return }
            var index = 0
            var update = false
            var id: Int?
            for (i, d) in dataSource.enumerated() {
                if let id_ = d.id, id_ == Int16(DataManager.shared.loanInfo.userInfo.relationships[indexRelation].type) {
                    update = true
                    index = i
                    id = Int(id_)
                    break
                }
            }
            if update {
                self.currentIndex = index
                
                if indexRelation == 0 {
                    DataManager.shared.currentIndexRelationPhoneSelectedPopup1 = id
                } else {
                    DataManager.shared.currentIndexRelationPhoneSelectedPopup2 = id
                }
            }
        
            break
            
        case .Job:
            self.updateCurrentWithOtherOption(i: DataManager.shared.loanInfo.jobInfo.jobType, otherText: DataManager.shared.loanInfo.jobInfo.jobTitle)
            
            break
        case .JobPosition:
            self.updateCurrentWithOtherOption(i: DataManager.shared.loanInfo.jobInfo.position, otherText: DataManager.shared.loanInfo.jobInfo.positionTitle)
            
            break
        case .Strength:
            self.updateCurrentIndex(i: DataManager.shared.loanInfo.jobInfo.strength)
            
            break
            
        case .AcademicLevel:
            self.updateCurrentIndex(i: DataManager.shared.loanInfo.jobInfo.academicLevel)
            
            break
            
        case .TypeMobilePhone:
            
            guard let value = DataManager.shared.loanInfo.userInfo.typeMobilePhone else { return }
            
            if !value.contains(keyComponentSeparateOptionalText) {
                if let index = Int(value) {
                    self.updateCurrentIndex(i: index)
                }
            } else {
                
                guard let index = FinPlusHelper.getIndexWithOtherSelection(value: value), let title = FinPlusHelper.getTitleWithOtherSelection(value: value) else { return }
                
                self.updateCurrentWithOtherOption(i: index, otherText: title)
                
            }
            
            
            break
        case .CareerHusbandOrWife:
            
            break
            
        case .TypeLoanedFrom:
            break
            
        case .ReferenceFriend:
            
            break
            
        case .HouseType:
            if let houseType = DataManager.shared.loanInfo.userInfo.houseType {
                self.updateCurrentIndex(i: Int(houseType) ?? -2)
            }
            
            break
        case .MaritalStatus:
            
            guard let value = DataManager.shared.loanInfo.userInfo.maritalStatus else { return }
            
            if !value.contains(keyComponentSeparateOptionalText) {
                if let index = Int(value) {
                    self.updateCurrentIndex(i: index)
                }
            } else {
                
                guard let index = FinPlusHelper.getIndexWithOtherSelection(value: value), let title = FinPlusHelper.getTitleWithOtherSelection(value: value) else { return }
                
                self.updateCurrentWithOtherOption(i: index, otherText: title)
                
            }
            
            break
            
        }
    }
    
    
    /// Update current Index selected
    ///
    /// - Parameter i: <#i description#>
    private func updateCurrentIndex(i: Int) {
        var index = 0
        var update = false
        for d in dataSource {
            if let id = d.id, id == Int16(i) {
                update = true
                break
            }
            index += 1
        }
        if update {
            self.currentIndex = index
        }
    }
    
    
    /// Update current Selecttion with other Selection
    ///
    /// - Parameters:
    ///   - i: <#i description#>
    ///   - otherText: <#otherText description#>
    private func updateCurrentWithOtherOption(i: Int, otherText: String) {
        
        var index = 0
        var update = false
        for d in dataSource {
            if let id = d.id, id == Int16(i) {
                update = true
                break
            }
            index += 1
        }
        if update {
            self.currentIndex = index
            
            if index < self.dataSource.count, self.dataSource[index].isTextInput == true {
                self.otherTextSelection = otherText
            }
        }
    }
    
    
    /// Get index from id
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    private func getIndexfromID(id: Int) -> Int? {
        var temp: Int?
        for (index, value) in self.dataSource.enumerated() {
            if value.id == Int16(id) {
                temp = index
                break
            }
        }
        
        return temp
    }
    
    /// Update index hiện tại đang chọn
    func updateSelected() {
        guard let type_ = self.type else { return }
        switch type_ {
        case .Categories:
            self.updateCurrentIndex(i: Int(DataManager.shared.loanInfo.loanCategoryID))
            
            break
        case .RelationShipPhone:
            self.titleString = "Người thân"
            
            if self.indexRelationPhone == 0 {
                if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup1 {
                    self.currentIndex = self.getIndexfromID(id: current)
                }
            } else {
                if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup2 {
                    self.currentIndex = self.getIndexfromID(id: current)
                }
            }
            
            break
            
        case .Job:
            self.titleString = "Nghề nhiệp"
            if let current = DataManager.shared.currentIndexJobSelectedPopup {
                self.currentIndex = current
                
                if let index = self.currentIndex {
                    if index < self.dataSource.count, self.dataSource[index].isTextInput == true {
                        self.otherTextSelection = DataManager.shared.loanInfo.jobInfo.jobTitle
                    }
                }
                
            }
            break
        case .JobPosition:
            self.titleString = "Cấp bậc"
            if let current = DataManager.shared.currentIndexJobPositionSelectedPopup {
                self.currentIndex = current
                
                if let index = self.currentIndex {
                    if index < self.dataSource.count, self.dataSource[index].isTextInput == true {
                        self.otherTextSelection = DataManager.shared.loanInfo.jobInfo.positionTitle
                    }
                }
            }
            break
        case .Strength:
            self.titleString = "Học lực"
            if let current = DataManager.shared.currentIndexStrengthSelectedPopup {
                self.currentIndex = current
            }
            
            break
            
        case .AcademicLevel:
            self.titleString = "Trình độ học vấn"
            if let current = DataManager.shared.currentIndexAcedemicLevelSelectedPopup {
                self.currentIndex = current
            }
            
            break
            
        case .TypeMobilePhone:
            self.titleString = "Loại điện thoại"
            if let current = DataManager.shared.currentIndexTypeMobilePhoneSelectedPopup {
                self.currentIndex = current
            }
            
            break
            
        case .CareerHusbandOrWife:
            self.titleString = "Nghề nhiệp"
            if let current = DataManager.shared.currentIndexCareerHusbandOrWifeSelectedPopup {
                self.currentIndex = current
            }
            
            break
            
        case .ReferenceFriend:
            self.titleString = "Bạn vay cùng"
            DataManager.shared.checkAndInitListCurrentIndexReferenceFriends()
            if let list = DataManager.shared.listCurrentSelectedTypeReferenceFriend, let indexRe = self.indexRelationPhone, list.count > indexRe, list[indexRe] > 0 {
                self.currentIndex = self.getIndexfromID(id: list[indexRe])
            }
            
            break
        case .HouseType:
            self.titleString = "Loại hình sở hữu nhà của bạn"
            if let current = DataManager.shared.currentIndexHouseTypeSelectedPopup {
                self.currentIndex = current
            }
            break
        case .MaritalStatus:
            self.titleString = "Tình trạng hôn nhân"
            if let current = DataManager.shared.currentIndexMaritalStatusSelectedPopup {
                self.currentIndex = current
            }
            break
            
        default:
            break
            
        }
        
    }
    
    
    @IBAction func btnOkTapped(_ sender: Any) {
        guard let index = self.currentIndex else { return }
        
        if index == self.dataSource.count - 1 {
            if let cell = self.mainTBView?.cellForRow(at: IndexPath(row: index, section: 0)) as? LoanTypePopupAddTextTBCell {
                
                guard let text = cell.tfValue?.text, text.count > 0 else {
                    self.showToastWithMessage(message: "Vui lòng nhập thông tin với lựa chọn \"Khác\"")
                    return
                }
                
                self.dataSource[index].textValue = cell.tfValue?.text
            }
        } else {
            self.dataSource[index].textValue = nil
        }
        
        self.hide {
            self.delegate?.dataSelected(data: self.dataSource[index])
            
            guard let type_ = self.type else { return }
            switch type_ {
            case .Categories:
                if DataManager.shared.loanCategories.count > index {
                    DataManager.shared.currentIndexCategoriesSelectedPopup = Int(DataManager.shared.loanCategories[index].id ?? 0)
                }
                
                break
            case .RelationShipPhone:
                if self.indexRelationPhone == 0 {
                    if let id = self.dataSource[index].id {
                        DataManager.shared.currentIndexRelationPhoneSelectedPopup1 = Int(id)
                    }
                    
                } else {
                    
                    if let id = self.dataSource[index].id {
                        DataManager.shared.currentIndexRelationPhoneSelectedPopup2 = Int(id)
                    }
                }
                
                break
            case .Job:
                DataManager.shared.currentIndexJobSelectedPopup = self.currentIndex
                break
            case .JobPosition:
                DataManager.shared.currentIndexJobPositionSelectedPopup = self.currentIndex
                break
            case .Strength:
                DataManager.shared.currentIndexStrengthSelectedPopup = self.currentIndex
                break
                
            case .AcademicLevel:
                DataManager.shared.currentIndexAcedemicLevelSelectedPopup = self.currentIndex
                break
                
            case .TypeMobilePhone:
                DataManager.shared.currentIndexTypeMobilePhoneSelectedPopup = self.currentIndex
                break
                
            case .CareerHusbandOrWife:
                DataManager.shared.currentIndexCareerHusbandOrWifeSelectedPopup = self.currentIndex
                break
            case .ReferenceFriend:
                DataManager.shared.checkAndInitListCurrentIndexReferenceFriends()
                if let indexRe = self.indexRelationPhone, let reference = DataManager.shared.listCurrentSelectedTypeReferenceFriend, reference.count > indexRe {
                    if let id = self.dataSource[index].id {
                        DataManager.shared.listCurrentSelectedTypeReferenceFriend?[indexRe] = Int(id)
                    }
                    
                }
                
                break
            case .HouseType:
                DataManager.shared.currentIndexCareerHusbandOrWifeSelectedPopup = self.currentIndex
                break
            case .MaritalStatus:
                DataManager.shared.currentIndexMaritalStatusSelectedPopup = self.currentIndex
                break
            default:
                break
            }
        }
    }
    
    //Đóng popup
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.hide()
    }
    
}

extension LoanTypePopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        let data = self.dataSource[indexPath.row]
        
        if let isText = data.isTextInput, isText, self.currentIndex == self.dataSource.count - 1 {
            let cell_ = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_Add_Text_TB_Cell", for: indexPath) as! LoanTypePopupAddTextTBCell
            cell_.data = data
            cell_.delegate = self
            if let otherText = self.otherTextSelection {
                cell_.tfValue?.text = otherText
            }
            return cell_
        }
        
        cell.lblValue?.text = data.title!
        
        if let subTitle = data.subTitle {
            cell.lblSubTitle?.text = subTitle
            cell.constantLblValueCenterY.constant = -7
        } else {
            cell.constantLblValueCenterY.constant = 0
        }
        
        guard let i = self.currentIndex, i == indexPath.row else {
            cell.imgIcon?.image = #imageLiteral(resourceName: "ic_radio_off")
            return cell
        }
        
        cell.imgIcon?.image = #imageLiteral(resourceName: "ic_radio_on")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.currentIndex = indexPath.row
        
        if self.currentIndex == self.dataSource.count - 1 {
            self.mainTBView?.reloadData()
            
            if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypePopupAddTextTBCell {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    cell.tfValue?.becomeFirstResponder()
                }
            }
        }
        
    }
    
    
}

//MARK: LoanTypePopupAddTextDelegate
extension LoanTypePopupVC: PopupAddTextDelegate {
    
    //Show keyboard
    func beginEditing() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () -> Void in
                        
                        self.centerYConstraint.constant = -150
                        self.view.layoutIfNeeded()
                        
        }, completion: { (finished) -> Void in
            // ....
        })

    }
    
    //Hide keyboard
    func endEditing() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        
                        self.centerYConstraint.constant = -40
                        self.view.layoutIfNeeded()
                        
        }, completion: { (finished) -> Void in
            // ....
        })
    }
    
}





