//
//  LoanTypePopupWithMuiltiSelectionVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 12/17/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanTypePopupWithMuiltiSelectionVC: BasePopup {
    
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
    
    private var listCurrentSelection: String? {
        didSet {
            self.updateListTitleValue()
            self.mainTBView?.reloadData()
        }
    }
    
    private var listValueTitle: String?
    
    //Loại popup
    var type: TypePopup?
    var titleString = "Thông báo"
    var otherTextSelection: String?
    var indexRelationPhone = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTBView?.tableFooterView = UIView()
        self.mainTBView?.separatorColor = UIColor.clear
        self.mainTBView?.rowHeight = UITableViewAutomaticDimension
        //self.mainTBView?.register(UINib(nibName: "LoanTypePopupAddTextTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Popup_Add_Text_TB_Cell")
        
        self.updateSelected()
        self.lblTitle?.text = titleString
        
        if self.listCurrentSelection == nil {
            self.updateDataSelectedFromServer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func handleSelection(index: Int) {
        
        guard let listCurrent = self.listCurrentSelection else {
            self.listCurrentSelection = "\(index)"
            return
        }
        
        let list = listCurrent.components(separatedBy: keyComponentSeparateOptionalText)
        var tempList = list
        var isCanAdd = true
        for (i, l) in list.enumerated() {
            if l == "\(index)" {
                isCanAdd = false
                tempList.remove(at: i)
                break
            }
        }
        
        if isCanAdd {
            tempList.append("\(index)")
        }
        
        guard tempList.count > 0 else {
            self.listCurrentSelection = nil
            return
        }
        
        self.listCurrentSelection = tempList.joined(separator: keyComponentSeparateOptionalText)
    }
    
    private func updateListTitleValue() {
        guard let selections = self.listCurrentSelection else { return }
        let value = FinPlusHelper.getListTitleValue(selections: selections, dataSource: dataSource)
        if value.count > 0 {
            self.listValueTitle = value
        }
    }
    
    private func checkCellIsSelecting(index: Int) -> Bool {
        guard let currentValue = self.listCurrentSelection else { return false }
        let list = currentValue.components(separatedBy: keyComponentSeparateOptionalText)
        
        for l in list {
            if l == "\(index)" {
                return true
            }
        }
        return false
    }
    
    /// set DataSource for tableView
    func setDataSource(data: [LoanBuilderData], type: TypePopup? = nil) {
        if let type_ = type {
            self.type = type_
        }
        self.dataSource = data
    }
    
    private func updateDataSelectedFromServer() {
        guard let type = self.type else { return }
        switch type {
        case .TypeLoanedFrom:
            if let value = DataManager.shared.loanInfo.borrowedPlace {
                self.listCurrentSelection = value
            }
        default:
            break
        }
    }
    
    
    /// Update index hiện tại đang chọn
    func updateSelected() {
        guard let type = self.type else { return }
        switch type {
        case .TypeLoanedFrom:
            self.titleString = "Bạn đã từng vay tiền ở đâu"
            if let current = DataManager.shared.currentListIndexLoanedFromSelectedPopup {
                self.listCurrentSelection = current
            }
        default:
            break
        }
    }
    
    @IBAction func btnOkTapped(_ sender: Any) {
        guard let listIndex = self.listCurrentSelection, let listTitle = self.listValueTitle else { return }
        
        self.hide {
            self.delegate?.multiDataSelected(value: listTitle, listIndex: listIndex)
            
            guard let type = self.type else { return }
            switch type {
            case .TypeLoanedFrom:
                DataManager.shared.currentListIndexLoanedFromSelectedPopup = listIndex
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

extension LoanTypePopupWithMuiltiSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Loan_Type_Popup_TB_Cell", for: indexPath) as! LoanTypePopupTBCell
        
        let data = self.dataSource[indexPath.row]
        
        cell.lblValue?.text = data.title!
        
        if let subTitle = data.subTitle {
            cell.lblSubTitle?.text = subTitle
            cell.constantLblValueCenterY.constant = -7
        } else {
            cell.constantLblValueCenterY.constant = 0
        }
        
        guard self.checkCellIsSelecting(index: indexPath.row) else {
            cell.imgIcon?.image = #imageLiteral(resourceName: "ic_radio_off")
            return cell
        }
        
        cell.imgIcon?.image = #imageLiteral(resourceName: "ic_radio_on")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.handleSelection(index: indexPath.row)
    }
    
}

//MARK: LoanTypePopupAddTextDelegate
extension LoanTypePopupWithMuiltiSelectionVC: PopupAddTextDelegate {
    
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
