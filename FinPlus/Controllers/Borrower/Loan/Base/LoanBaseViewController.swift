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
    static let OptionalMedia = "Loan_Type_Optional_Media_TB_Cell"
}


class LoanBaseViewController: BaseViewController {
    
    //Table View For data from LoanBuilder
    @IBOutlet var mainTBView: TPKeyboardAvoidingTableView?
    @IBOutlet var bottomScrollView: UIScrollView?
    
    //DataSource cho main tablview, dữ liệu tuỳ theo index màn hình
    var dataSource: LoanBuilderBase?
    
    //Màn hình hay bước trong Loan
    var index: Int = 0
    
    //Cho body api
    var currentStep: Int = 0 {
        didSet {
            DataManager.shared.loanInfo.currentStep = self.currentStep
        }
    }
    
    //BirthDay
    var birthDay: Date? {
        didSet {
            if let date1 = self.birthDay {
                let date = date1.toString(.custom(kDisplayFormat))
                
                guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
                self.mainTBView?.deselectRow(at: indexPath, animated: true)
                if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeDropdownTBCell {
                    cell.field?.selectorTitle = date
                    //DateTime ISO 8601
                    let timeISO8601 = date1.toString(.iso8601(ISO8601Format.DateTimeSec))
                    DataManager.shared.loanInfo.userInfo.birthDay = timeISO8601
                }
            }
        }
    }
    
    //Giới tính
    var gender: Gender? {
        didSet {
            guard let g = self.gender else { return }
            DataManager.shared.loanInfo.userInfo.gender = "\(g.rawValue)"
        }
    }
    
    // Kiểu File Img
    var typeImgFile: FILE_TYPE_IMG?
    
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
        tableView.register(UINib(nibName: "LoanTypeOptionalMediaTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.OptionalMedia)
        
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
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    
    /// Sang màn chọn địa chỉ
    func gotoAddressVC() {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        
        if let indexPath = self.mainTBView?.indexPathForSelectedRow {
            firstAddressVC.titleTypeAddress = self.dataSource?.fields?[indexPath.row].title ?? ""
        }
        
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
    
    //Chọn ảnh
    func selectedFile() {
        CameraHandler.shared.showCamera(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            
            self.uploadData(img: img)
            
            guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
            self.mainTBView?.deselectRow(at: indexPath, animated: true)
            if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeFileTBCell {
                cell.imgValue?.image = img
                cell.imgAdd?.isHidden = true
                cell.lblDescription?.isHidden = true
            }
        }
    }
    
    //Upload Data Image
    func uploadData(img: UIImage) {
        
        guard let type = self.typeImgFile else { return }
        
        let dataImg = UIImagePNGRepresentation(img)
        
        let loanID = DataManager.shared.loanID ?? 0
        guard let data = dataImg else { return }
        let endPoint = "loans/" + "\(loanID)/" + "file"
        
        self.handleLoadingView(isShow: true)
        APIClient.shared.upload(type: type, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { (response) in
            self.handleLoadingView(isShow: false)
            print("Upload \(String(describing: response))")
            self.showToastWithMessage(message: "Upload thành công")
            
            guard let res = response, let data = res["data"] as? [JSONDictionary], data.count > 0 else { return }
            
            switch type {
            case .ALL:
                
                if let url = data[0]["url"] as? String {
                    DataManager.shared.loanInfo.nationalIdAllImg = url
                }
                
                break
            case .BACK:
                if let url = data[0]["url"] as? String {
                    DataManager.shared.loanInfo.nationalIdBackImg = url
                }
                
                break
            case .FRONT:
                if let url = data[0]["url"] as? String {
                    DataManager.shared.loanInfo.nationalIdFrontImg = url
                }
                
                break
            case .Optional:
                DataManager.shared.loanInfo.optionalMedia.removeAll()
                for d in data {
                    if let url = d["url"] as? String {
                        DataManager.shared.loanInfo.optionalMedia.append(url)
                    }
                }
                
                break
            }
            
        }) { (error) in
            self.handleLoadingView(isShow: false)
            
            if let error = error {
                self.showToastWithMessage(message: error.localizedDescription)
                print("error \(error.localizedDescription)")
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
            
            cell.parent = data.id
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
            
        case DATA_TYPE_TB_CELL.MultipleFile:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.OptionalMedia, for: indexPath) as! LoanTypeOptionalMediaTBCell
            cell.field = model
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
                //Xử lý trong cell
            } else if model.title == "Cấp bậc" {
                //Xử lý trong cell
            } else if model.title == "Giới tính" {
                self.selectedGender()
            }
            
            break
        case DATA_TYPE_TB_CELL.DateTime:
            self.showDateDialog()
            break
        case DATA_TYPE_TB_CELL.DropdownTexBox:
            //Xử lý trong cell
            break
        case DATA_TYPE_TB_CELL.Address:
            self.gotoAddressVC()
            break
        case DATA_TYPE_TB_CELL.File:
            
            if model.title!.contains("Ảnh bạn đang cầm CMND") {
                self.typeImgFile = .ALL
            } else if model.title!.contains("Ảnh mặt trước CMND") {
                self.typeImgFile = .FRONT
            } else if model.title!.contains("Ảnh mặt sau CMND") {
                self.typeImgFile = .BACK
            } else {
                self.typeImgFile = .Optional
            }
            
            self.selectedFile()
            
            break
            
        case DATA_TYPE_TB_CELL.MultipleFile:
            
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
    func getAddress(address: Address, type: Int, title: String) {
        let add = address.street + ", " + address.commune + ", " + address.district + ", " + address.city
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeAddressTBCell {
            cell.field?.placeholder = add
        }
        
        if title.contains("thường trú") {
            DataManager.shared.loanInfo.userInfo.residentAddress = address
        } else if title.contains("tạm trú") {
            DataManager.shared.loanInfo.userInfo.temporaryAddress = address
        } else if title.contains("cơ quan") {
            DataManager.shared.loanInfo.jobInfo.address = address
        }
        
    }
}



