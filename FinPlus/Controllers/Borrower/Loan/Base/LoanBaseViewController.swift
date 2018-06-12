//
//  LoanBaseViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/29/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

/// Identifier TB Cell For Loan
enum Loan_Identifier_TB_Cell {
    static let TextField = "Loan_Type_TextField_TB_Cell"
    static let DropDown = "Loan_Type_Dropdown_TB_Cell"
    static let Address = "Loan_Type_Address_TB_Cell"
    static let PhoneRelation = "Loan_Type_Phone_Relation_TB_Cell"
    static let Footer = "Loan_Type_Footer_TB_View"
    static let File = "Loan_Type_File_TB_Cell"
}

// Giới tính
enum Gender: Int {
    case Male = 0
    case Female
}

// Số điện thọai người thân
enum RelationPhoneNumber: Int {
    case Wife = 0
    case Husband
    case Father
    case Mother
    
}

// Các kiểu chụp CMND
enum NATIONALID_TYPE_IMG: Int {
    case ALL = 0 // Cầm CMND trước mặt chụp cả mặt
    case FRONT
    case BACK
}


class LoanBaseViewController: BaseViewController {
    
    //Table View For data from LoanBuilder
    @IBOutlet var mainTBView: TPKeyboardAvoidingTableView?
    @IBOutlet var bottomScrollView: UIScrollView?
    
    //DataSource cho main tablview, dữ liệu tuỳ theo index màn hình
    var dataSource: LoanBuilderBase?
    
    //Màn hình hay bước trong Loan
    var index: Int = 0
    
    //BirthDay
    var birthDay: Date? {
        didSet {
            if let date = self.birthDay {
                let date = date.toString(.custom(kDisplayFormat))
                
                guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
                self.mainTBView?.deselectRow(at: indexPath, animated: true)
                if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeDropdownTBCell {
                    cell.field?.selectorTitle = date
                }
            }
        }
    }
    
    //Giới tính
    var gender: Gender?
    
    // Kiểu chụp CMND
    var typeImgNationID: NATIONALID_TYPE_IMG?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMainTBView()
    }
    
    
    
    /// Setup cho tableView
    func setupMainTBView() {
        guard let tableView = self.mainTBView else { return }
        guard self.index < DataManager.shared.loanBuilder.count else { return }
        
        self.dataSource = DataManager.shared.loanBuilder[self.index]
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.DropDown)
        tableView.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.TextField)
        tableView.register(UINib(nibName: "LoanTypeAddressTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Address)
        tableView.register(UINib(nibName: "LoanTypePhoneRelationTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.PhoneRelation)
        tableView.register(UINib(nibName: "LoanTypeFooterTBView", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Footer)
        tableView.register(UINib(nibName: "LoanTypeFileTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.File)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
    }
    
    
    /// Show date time Picker
    func showDateDialog() {
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in
            
            if let date = date {
                self.birthDay = date
            }
        }
    }

    /// Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func updateDataToServer() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    
    /// Sang màn chọn địa chỉ
    func gotoAddressVC() {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
    }
    
    //Chọn giới tính
    func selectedGender() {
        let filterVC = UIAlertController(title: "Chọn giới tính của bạn", message: nil, preferredStyle: .actionSheet)
        filterVC.view.tintColor = MAIN_COLOR
        
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel) { (action) in
            
        }
        
        cancel.setValue(UIColor(hexString: "#08121E"), forKey: "titleTextColor")
        
        let title1 = "Nam"
        let action1 = UIAlertAction(title: title1, style: .default) { (action) in
            guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
            self.mainTBView?.deselectRow(at: indexPath, animated: true)
            if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeDropdownTBCell {
                cell.field?.selectorTitle = title1
                self.gender = .Male
            }
        }
        
        let title2 = "Nữ"
        let action2 = UIAlertAction(title: title2, style: .default) { (action) in
            guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
            self.mainTBView?.deselectRow(at: indexPath, animated: true)
            if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeDropdownTBCell {
                cell.field?.selectorTitle = title2
                self.gender = .Female
            }
        }
        
        filterVC.addAction(cancel)
        filterVC.addAction(action1)
        filterVC.addAction(action2)
        
        self.present(filterVC, animated: true, completion: nil)
    }
    
    //Chọn nghề nghiệp
    func selectedJob() {
        
        
    }
    
    //Chọn cấp bậc
    func selectedPosition() {
        
        
    }
    
    //Chọn ảnh
    func selectedFile() {
        CameraHandler.shared.showCamera(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            
            guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
            self.mainTBView?.deselectRow(at: indexPath, animated: true)
            if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeFileTBCell {
                cell.imgValue?.image = img
                cell.imgAdd?.isHidden = true
            }
        }
    }
    
    
    
    
    
}

//MARK: TableView DataSource, TableView Delegate
extension LoanBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = self.dataSource, let fields = data.fields else { return 0 }
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = self.dataSource, let fields = data.fields else { return UITableViewCell() }
        let model = fields[indexPath.row]
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.TextBox:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.DropDown:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.DateTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            cell.field = model
            return cell
            
            
        case DATA_TYPE_TB_CELL.DropdownTexBox:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.PhoneRelation, for: indexPath) as! LoanTypePhoneRelationTBCell
             cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.Address:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.Address, for: indexPath) as! LoanTypeAddressTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.File:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.File, for: indexPath) as! LoanTypeFileTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.Footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.Footer, for: indexPath) as! LoanTypeFooterTBView
            
            cell.lblDesciption?.text = model.title ?? ""
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        guard let data = self.dataSource, let fields = data.fields else { return }
        let model = fields[indexPath.row]
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.TextBox:
            
            break
        case DATA_TYPE_TB_CELL.DropDown:
            //Giới tính
            //Chức vụ
            //Nghề nghiệp
            if model.title == "Nghề nghiệp" {
                
            } else if model.title == "Cấp bậc" {
                
            } else if model.title == "Giới tính" {
                self.selectedGender()
            }
            
            break
        case DATA_TYPE_TB_CELL.DateTime:
            self.showDateDialog()
            break
        case DATA_TYPE_TB_CELL.DropdownTexBox:
            
            break
        case DATA_TYPE_TB_CELL.Address:
            self.gotoAddressVC()
            break
        case DATA_TYPE_TB_CELL.File:
            self.selectedFile()
            
            break
        case DATA_TYPE_TB_CELL.Footer:
            
            break
        default:
            break
        }
        
        
        
    }
    
}

//MARK: Address Delegate
extension LoanBaseViewController: AddressDelegate {
    func getAddress(address: Address, type: Int) {
        let add = address.commune + ", " + address.district + ", " + address.city
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeAddressTBCell {
            cell.field?.placeholder = add
        }
        
    }
}



