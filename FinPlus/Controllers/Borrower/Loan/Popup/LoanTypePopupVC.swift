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
}

class LoanTypePopupVC: BasePopup {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var mainTBView: UITableView?
    
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
        
        self.lblTitle?.text = titleString
        
        self.updateSelected()
        
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
            if let current = DataManager.shared.currentIndexCategoriesSelectedPopup {
                self.currentIndex = current
            }
            break
        case .RelationShipPhone:
            if let current = DataManager.shared.currentIndexRelationPhoneSelectedPopup {
                self.currentIndex = current
            }
            break
            
        case .Job:
            if let current = DataManager.shared.currentIndexJobSelectedPopup {
                self.currentIndex = current
            }
            break
        case .JobPosition:
            if let current = DataManager.shared.currentIndexJobPositionSelectedPopup {
                self.currentIndex = current
            }
            break
            
        }
        
    }
    
    
    @IBAction func btnOkTapped(_ sender: Any) {
        guard let index = self.currentIndex else { return }
        
        self.hide {
            self.delegate?.dataSelected(data: self.dataSource[index])
            
            guard let type_ = self.type else { return }
            switch type_ {
            case .Categories:
                DataManager.shared.currentIndexCategoriesSelectedPopup = self.currentIndex
                break
            case .RelationShipPhone:
                DataManager.shared.currentIndexRelationPhoneSelectedPopup = self.currentIndex
                break
            case .Job:
                DataManager.shared.currentIndexJobSelectedPopup = self.currentIndex
                break
            case .JobPosition:
                DataManager.shared.currentIndexJobPositionSelectedPopup = self.currentIndex
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
        
        cell.lblValue?.text = self.dataSource[indexPath.row].title!
        
        if let subTitle = self.dataSource[indexPath.row].subTitle {
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
        
    }
    
    
}
