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
    static let Choice = "Loan_Type_Choice_TB_Cell"
    static let TextView = "LoanTypeTextViewTBCell"
}


class LoanBaseViewController: BaseViewController {
    
    //Table View For data from LoanBuilder
    @IBOutlet var mainTBView: TPKeyboardAvoidingTableView?
    @IBOutlet var bottomScrollView: UIScrollView?
    
    @IBOutlet var contentInputView: UIView?
    @IBOutlet var sbInputView: SBMessageInputView?
    @IBOutlet var bottomConstraintContentInputView: NSLayoutConstraint?
    
    
    
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
                    //DateTime ISO 8601
                    //let timeISO8601 = date1.toString(.iso8601(ISO8601Format.DateTimeSec))
                    let timeISO8601 = date1.toString(.custom(DATE_FORMATTER_BIRTHDAY_WITH_SERVER))
                    
                    
                    guard let id = cell.field?.id else { return }
                    
                    if id.contains("birthday") {
                        DataManager.shared.loanInfo.userInfo.birthDay = timeISO8601
                    } else if id.contains("optionalText") {
                        if let index = cell.field?.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                            DataManager.shared.loanInfo.optionalText[index] = timeISO8601
                        }
                    }
                    cell.field?.placeholder = date
                    
                }
            }
        }
    }
    
    //Giới tính
    var gender: Gender? {
        didSet {
            guard let g = self.gender else { return }
            guard let i = self.currentIndexSelected, let field_ = self.dataSource?.fieldsDisplay![i.row], let id = field_.id else { return }
            
            if id.contains("gender") {
                DataManager.shared.loanInfo.userInfo.gender = "\(g.rawValue)"
            } else if id.contains("optionalText") {
                if let index = field_.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                    if g.rawValue == 0 {
                        DataManager.shared.loanInfo.optionalText[index] = "Nam"
                    } else {
                        DataManager.shared.loanInfo.optionalText[index] = "Nữ"
                    }
                }
            }

        }
    }
    
    // Kiểu File Img
    var typeImgFile: FILE_TYPE_IMG?
    
    //Cell đang chọn hiện tại
    var currentIndexSelected: IndexPath?
    
    var loanCate: LoanCategories?
    
    var isMuiltiLineText: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMainTBView()
    }
    
    /// Setup cho tableView
    func setupMainTBView() {
        guard let tableView = self.mainTBView else { return }
        
        self.initFieldsData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.DropDown)
        tableView.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.TextField)
        tableView.register(UINib(nibName: "LoanTypeAddressTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Address)
        tableView.register(UINib(nibName: "LoanTypePhoneRelationTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.PhoneRelation)
        tableView.register(UINib(nibName: "LoanTypeFooterTBView", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Footer)
        tableView.register(UINib(nibName: "LoanTypeFileTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.File)
        tableView.register(UINib(nibName: "LoanTypeOptionalMediaTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.OptionalMedia)
        tableView.register(UINib(nibName: "LoanTypeChoiceTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.Choice)
        tableView.register(UINib(nibName: "LoanTypeTextViewTBCell", bundle: nil), forCellReuseIdentifier: Loan_Identifier_TB_Cell.TextView)
        
        tableView.register(UINib(nibName: "LoanTypeInputTextMuiltiLineTBCell", bundle: nil), forCellReuseIdentifier: "LoanTypeInputTextMuiltiLineTBCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        
    }
    
    func initLoanCate() {
        guard self.loanCate == nil else { return }
        var temp = DataManager.shared.loanCategories.filter { $0.id == DataManager.shared.loanInfo.loanCategoryID }
        
        if temp.count > 0 {
            self.loanCate = temp[0]
        }
    }
    
    private func initFieldsData() {
        guard let cate = DataManager.shared.getCurrentCategory(), let builders = cate.builders else { return }
        guard self.index < builders.count else { return }
        self.dataSource = builders[self.index]
    }
    
    func reloadFieldsData() {
        self.initFieldsData()
        self.mainTBView?.reloadData()
    }
    
    
    /// Show date time Picker
    func showDateDialog() {
        
        let defaultDate = Date(fromString: "01/01/2000", format: DateFormat.custom(kDisplayFormat))
        
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: defaultDate , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in
            
            if let date = date {
                self.birthDay = date
            }
        }
    }

    /// Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func updateDataToServer(step: Int? = nil, completion: @escaping() -> Void) {
        
        if let step_ = step {
            self.currentStep = step_
        }
        
        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!
                DataManager.shared.browwerInfo?.activeLoan = model
                completion()
            }
            .catch { error in
                self.showGreenBtnMessage(title: TITLE_ALERT_ERROR_CONNECTION, message: API_MESSAGE.OTHER_ERROR, okTitle: "Đóng", cancelTitle: nil)
        }
    }
    
    
    /// Sang màn chọn địa chỉ
    func gotoAddressVC(title: String, id: String) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        firstAddressVC.titleString = title
        firstAddressVC.id = id
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
    }
    
    func gotoDropdownSearchVC() {
        let universityVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "UniversityViewController") as! UniversityViewController
        universityVC.delegateUniversity = self

        self.navigationController?.pushViewController(universityVC, animated: true)
    }
    
    
    func showCameraView(descriptionStr: String? = nil) {
        
        if #available(iOS 10.0, *) {
            let cameraVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            cameraVC.delegateCamera = self
            cameraVC.typeImgFile = self.typeImgFile
            cameraVC.descriptionText = descriptionStr
            
            self.present(cameraVC, animated: true) {
                
            }
        } else {
            if self.typeImgFile == .ALL {
                if let value = userDefault.value(forKey: UserDefaultShowGuideCameraView) as? Bool, value {
                    self.selectedFile()
                } else {
                    self.showGuideCaptureView()
                }
                
            } else {
                self.selectedFile()
            }
        }
        
    }
    
    func selectedFile() {
        CameraHandler.shared.showCamera(vc: UIApplication.shared.topViewController()!)
        CameraHandler.shared.imagePickedBlock = { (image) in
            //let img = FinPlusHelper.resizeImage(image: image, newWidth: 300)
            
            self.uploadData(img: image, typeImg: self.typeImgFile)
        }
    }
    
    func showGuideCaptureView() {
        let guideVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "GuideCaptureViewController") as! GuideCaptureViewController
        guideVC.delegate = self
        self.present(guideVC, animated: true, completion: {
            
        })
    }
    
    //Upload Data Image
    func uploadData(img: UIImage, typeImg: FILE_TYPE_IMG?) {
        
        guard let type = typeImg else { return }
        
        guard let imgResize = img.resizeMonyImage(originSize: img.size), let data = imgResize.jpeg(.lowest) else { return }
        
        let loanID = DataManager.shared.loanID ?? 0
        let endPoint = "\(APIService.LoanService)loans/" + "\(loanID)/" + "file"
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        guard let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeFileTBCell else {
            return
        }
        cell.activityIndicator.startAnimating()

        APIClient.shared.upload(type: type, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { [weak self](response) in

            cell.activityIndicator.stopAnimating()
            
            guard let res = response, let data = res["data"] as? [JSONDictionary], data.count > 0 else {
                
                self?.showToastWithMessage(message: "Có lỗi xảy ra, vui lòng thử lại")
                
                return
            }
            
            cell.imgValue?.image = img
            cell.imgAdd?.isHidden = true
            cell.lblDescription?.isHidden = true
            
            if let isNeed = cell.isNeedUpdate, isNeed {
                cell.isNeedUpdate = false
            }
            
            
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
                        DataManager.shared.loanInfo.optionalMedia[0].append(url)
                    }
                }
                
                break
            }
            
        }) { (error) in
            self.handleLoadingView(isShow: false)
            cell.activityIndicator.stopAnimating()
            
            self.showToastWithMessage(message: "Có lỗi xảy ra, vui lòng thử lại")
            if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Text Input View
    func configTextMesseageView() {
        self.sbInputView?.mainView.backgroundColor = UIColor(red: 234/255, green: 239/255, blue: 247/255, alpha: 1.0)
        self.sbInputView?.delegate = self
        self.contentInputView?.isHidden = true
    }
    
    func hideInputMessageView() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.bottomConstraintContentInputView?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (status) in
            self.contentInputView?.isHidden = true
            self.refreshTextInput()
        })
    }
    
    func showInputMesseageView() {
        self.isMuiltiLineText = true
        
        guard let index = self.currentIndexSelected?.row, let field = self.dataSource?.fieldsDisplay?[index], let id = field.id else {
            self.sbInputView?.textView.becomeFirstResponder()
            return
        }
        
        if id.contains("optionalText") {
            self.checkValueOptionalTextMuiltiLine {
                self.sbInputView?.textView.becomeFirstResponder()
            }
        } else {
            self.checkOtherTextMuiltiline(id: id) {
                self.sbInputView?.textView.becomeFirstResponder()
            }
        }
        
    }
    
    //Check nếu có text nhập rồi thì input vào cho edit từ đã có
    private func checkValueOptionalTextMuiltiLine(completion: () -> Void) {
        guard let index = self.currentIndexSelected?.row else {
            completion()
            return
        }
        guard index < DataManager.shared.loanInfo.optionalText.count, DataManager.shared.loanInfo.optionalText[index].count > 0 else {
            completion()
            return
        }
        
        let text = DataManager.shared.loanInfo.optionalText[index]
        
        self.sbInputView?.lineHeight = 20
        self.sbInputView?.numberOfLines = CGFloat(self.getCountLine(text: text))
        self.sbInputView?.tempValue = text
        completion()
    }
    
    
    /// Check nếu có text nhập rồi thì input vào cho edit từ đã có
    ///
    /// - Parameter completion: <#completion description#>
    private func checkOtherTextMuiltiline(id: String, completion: () -> Void) {
        
        if id.contains("jobDescription") {
            guard let text = DataManager.shared.loanInfo.jobInfo.jobDescription else {
                completion()
                return }
            
            self.sbInputView?.lineHeight = 20
            self.sbInputView?.numberOfLines = CGFloat(self.getCountLine(text: text))
            self.sbInputView?.tempValue = text
        
        }
        completion()
    }
    
    func getCountLine(text: String) -> Int {
        let lines = text.components(separatedBy: "\n")
        if lines.count > 0 {
            return lines.count
        }
        
        return 1
    }
    
    /// Làm mới lại View Nhập text comment
    func refreshTextInput() {
        self.sbInputView?.textView.text = ""
        self.sbInputView?.numberOfLines = 1
    }
    
    
    @IBAction func btnInputMuiltiTextDoneTapped(_ sender: Any) {
        self.hideInputMessageView()
        self.view.endEditing(true)
        guard let index = self.currentIndexSelected, let text = self.sbInputView?.textView.text, text.count > 0 else { return }
        
        guard let field = self.dataSource?.fieldsDisplay?[index.row], let id = field.id else { return }
        
        if id.contains("optionalText") {
            if let index = field.arrayIndex, DataManager.shared.loanInfo.optionalText.count > index {
                DataManager.shared.loanInfo.optionalText[index] = text
            }
        } else if id.contains("jobDescription") {
            DataManager.shared.loanInfo.jobInfo.jobDescription = text
        }
        
        self.dataSource?.fieldsDisplay?[index.row].textInputMuiltiline = text
        
        self.mainTBView?.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
        
        
    }
    
    //MARK: For TextInputMuiltiline
    //MARK: For catch event show hidden keyboard
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard self.isMuiltiLineText else { return }
        self.isMuiltiLineText = false
        //Do something here
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.contentInputView?.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.bottomConstraintContentInputView?.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }) { (status) in
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        //Do something here
        self.hideInputMessageView()
    }
    
    
    @objc func showInputMesseage(notification: NSNotification) {
        self.isMuiltiLineText = true
        self.sbInputView?.textView.becomeFirstResponder()
    }
    
    
}

//MARK: TableView DataSource, TableView Delegate
extension LoanBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = self.dataSource, let fields = data.fieldsDisplay else { return 0 }
        return fields.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = self.dataSource, let fields = data.fieldsDisplay else { return UITableViewCell() }
        let model = fields[indexPath.row]
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.DropDownSearch:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.Address, for: indexPath) as! LoanTypeAddressTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.TextBox:
            
            if let multiline = model.multipleLine, multiline {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoanTypeInputTextMuiltiLineTBCell", for: indexPath) as! LoanTypeInputTextMuiltiLineTBCell
                
                //cell.parent = data.id
                cell.field = model
                cell.currentIndex = indexPath
                cell.showInputViewDelegate = self
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            
            cell.parent = data.id
            cell.field = model
            cell.delegateTextField = self
            
            
            return cell
            
        case DATA_TYPE_TB_CELL.DropDown:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            cell.field = model
            cell.parentVC = self
            return cell
            
        case DATA_TYPE_TB_CELL.DateTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            
            cell.field = model
            return cell
            
            
        case DATA_TYPE_TB_CELL.DropdownTexBox:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.PhoneRelation, for: indexPath) as! LoanTypePhoneRelationTBCell
             cell.field = model
            cell.parentVC = self
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
            
        case DATA_TYPE_TB_CELL.Choice:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.Choice, for: indexPath) as! LoanTypeChoiceTBCell
            cell.field = model
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        guard let data = self.dataSource, let fields = data.fieldsDisplay else { return }
        let model = fields[indexPath.row]
        self.currentIndexSelected = indexPath
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.DropDownSearch:
            self.gotoDropdownSearchVC()
            break
            
        case DATA_TYPE_TB_CELL.TextBox:
            //self.showInputMesseageView()
            
            break
        case DATA_TYPE_TB_CELL.DropDown:
            //Chức vụ
            //Nghề nghiệp
            tableView.deselectRow(at: indexPath, animated: true)
            
            break
        case DATA_TYPE_TB_CELL.DateTime:
            self.showDateDialog()
            break
        case DATA_TYPE_TB_CELL.DropdownTexBox:
            //Xử lý trong cell
            break
        case DATA_TYPE_TB_CELL.Address:
            self.gotoAddressVC(title: model.title!, id: model.id!)
            break
        case DATA_TYPE_TB_CELL.File:
            
            if model.id!.contains("nationalIdAllImg") {
                self.typeImgFile = .ALL
            } else if model.id!.contains("nationalIdFrontImg") {
                self.typeImgFile = .FRONT
            } else if model.id!.contains("nationalIdBackImg") {
                self.typeImgFile = .BACK
            } else {
                self.typeImgFile = .Optional
            }
            
            self.showCameraView(descriptionStr: model.descriptionValue)
            
        
            
            break
            
        case DATA_TYPE_TB_CELL.MultipleFile:
            
            break
            
        case DATA_TYPE_TB_CELL.Choice:
            
            break
            
        case DATA_TYPE_TB_CELL.Footer:
            
            break
        default:
            break
        }
        
    }
    
}

//MARK: UniversitySelectionDelegate
extension LoanBaseViewController: UniversitySelectionDelegate {
    func universitySelected(model: UniversityModel) {
        DataManager.shared.loanInfo.jobInfo.academicName = model.name!
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeAddressTBCell {
            cell.field?.placeholder = model.name!
        }
    }
}

//MARK: DataImageFromCameraCaptureDelegate
extension LoanBaseViewController: DataImageFromCameraCaptureDelegate {
    func getImage(image: UIImage, type: FILE_TYPE_IMG?) {
        self.uploadData(img: image, typeImg: type)
    }
}

////MARK: GuideCaptureDelegate
extension LoanBaseViewController: GuideCaptureDelegate {
    func showCamera() {
        self.selectedFile()
    }

}

//MARK: SBMessageInputViewDelegate
extension LoanBaseViewController: SBMessageInputViewDelegate {
    
    func inputViewDidChange(textView: UITextView) {
        
    }
    
    func inputViewShouldBeginEditing(textView: UITextView) -> Bool {
        //textView.text = ""
        
        
        return true
    }
    
    func inputView(textView: UITextView, shouldChangeTextInRange: NSRange, replacementText: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: shouldChangeTextInRange, with: replacementText)
        let trimmedText = newText.trimmingCharacters(in: CharacterSet.whitespaces)
        let textLast = trimmedText.replacingOccurrences(of: "\n", with: "")
        let numberOfChars = textLast.count // for Swift use count(newText)
        return numberOfChars < 500

    }
    
    func inputViewDidBeginEditing(textView: UITextView) {
        
    }
}

//MARK: ShowTextInputMesseageViewDelegate
extension LoanBaseViewController: ShowTextInputMesseageViewDelegate {
    func showTextInput(indexPath: IndexPath) {
        self.currentIndexSelected = indexPath
        if let _ = self.sbInputView {
            self.showInputMesseageView()
        }
    }
}

//MARK: TextFieldEditDidBeginDelegate
extension LoanBaseViewController: TextFieldEditDidBeginDelegate {
    func textFieldEditDidBegin() {
        if let _ = self.sbInputView {
            self.hideInputMessageView()
        }
    }
}

//MARK: Address Delegate
extension LoanBaseViewController: AddressDelegate {
    func getAddress(address: Address, type: Int, title: String, id: String) {
        let add = address.street + KeySeparateAddressFormatString + address.commune + KeySeparateAddressFormatString + address.district + KeySeparateAddressFormatString + address.city
        
        if id.contains("residentAddress") {
            DataManager.shared.loanInfo.userInfo.residentAddress = address
        } else if id.contains("currentAddress") {
            DataManager.shared.loanInfo.userInfo.temporaryAddress = address
        } else if id.contains("jobAddress") {
            DataManager.shared.loanInfo.jobInfo.jobAddress = address
        } else if id.contains("academicAddress") {
            DataManager.shared.loanInfo.jobInfo.academicAddress = address
        }
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? LoanTypeAddressTBCell {
            cell.field?.placeholder = add
        }
        
        
    }
}



