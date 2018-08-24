//
//  LoanTypePhoneRelationPopupVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


/// Data trả về sau khi chọn
protocol DataSelectedFromPopupProtocol {
    func dataSelected(data: LoanBuilderData)
}

enum TypePopup: Int {
    case Categories = 0 // list Category
    case RelationShipPhone // Số điện thoại nguoi than
    case Job // Công việc
    case JobPosition // chức vụ
    case Strength // Học lực
    case AcademicLevel // Trinh độ học vấn
}

class LoanTypePopupVC: BasePopup {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var mainTBView: UITableView?
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    var delegate: DataSelectedFromPopupProtocol?
    
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView?.tableFooterView = UIView()
        self.mainTBView?.separatorColor = UIColor.clear
        self.mainTBView?.rowHeight = UITableViewAutomaticDimension
        self.mainTBView?.register(UINib(nibName: "LoanTypePopupAddTextTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Popup_Add_Text_TB_Cell")
        
        self.updateSelected()
        
        self.lblTitle?.text = titleString
        
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
    
    
    /// Update index hiện tại đang chọn
    func updateSelected() {
        guard let type_ = self.type else { return }
        switch type_ {
        case .Categories:
//            if let current = DataManager.shared.currentIndexCategoriesSelectedPopup {
//                self.currentIndex = current
//            }
            break
        case .RelationShipPhone:
            if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup {
                self.currentIndex = current
            }
            break
            
        case .Job:
            self.titleString = "Nghề nhiệp"
            if let current = DataManager.shared.currentIndexJobSelectedPopup {
                self.currentIndex = current
            }
            break
        case .JobPosition:
            self.titleString = "Cấp bậc"
            if let current = DataManager.shared.currentIndexJobPositionSelectedPopup {
                self.currentIndex = current
            }
            break
        case .Strength:
            self.titleString = "Học lực"
            break
            
        case .AcademicLevel:
            self.titleString = "Trình độ học vấn"
            break
            
        }
        
    }
    
    
    @IBAction func btnOkTapped(_ sender: Any) {
        guard let index = self.currentIndex else { return }
        
        if index == self.dataSource.count - 1 {
            if let cell = self.mainTBView?.cellForRow(at: IndexPath(row: index, section: 0)) as? LoanTypePopupAddTextTBCell {
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
                //DataManager.shared.currentIndexRelationPhoneSelectedPopup = self.currentIndex
                break
            case .Job:
                DataManager.shared.currentIndexJobSelectedPopup = self.currentIndex
                break
            case .JobPosition:
                DataManager.shared.currentIndexJobPositionSelectedPopup = self.currentIndex
                break
            case .Strength:
                
                break
                
            case .AcademicLevel:
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





