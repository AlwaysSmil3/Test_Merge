//
//  InvestorSignupViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorSignupViewController: UIViewController {

    enum CellKeyboardType {
        case phone
        case email
        case normal
        case number
    }

    enum Cell {
        case inputType
        case dateType
        case selectType
        case btnType

        var cellType : UITableViewCell.Type {
            switch self {
            case .inputType:
//                return InputTableViewCel.Self
                break
            case .dateType:
//                return DateTimeTableViewCel.Self
                break
            case .selectType:
//                return SelectTableViewCel.Self
                break
            default:
//                return BtnTableViewCel.Self
                break
            }
            return UITableViewCell.self
        }
    }

    public class CellData {
        var cellHeight: CGFloat = 0
        var cellType: Cell!
        var title: String = ""
        var placeholder: String = ""
        var isRequired : Bool!
        var sourceData : Array<Any>?
        var data: Any = ""
        var avartar: String = ""
        var cellKeyboardType : CellKeyboardType = CellKeyboardType.normal
        init(cellType: Cell, avartar: String, title: String, placeholder: String, isRequired: Bool, data: Any, cellKeyboardType: CellKeyboardType, cellHeight: CGFloat, sourceData : Array<Any>?) {
            self.cellType = cellType
            self.avartar = avartar
            self.title = title
            self.placeholder = placeholder
            self.isRequired = isRequired
            self.data = data
            self.cellKeyboardType = cellKeyboardType
            self.cellHeight = cellHeight
            self.sourceData = sourceData
        }

    }
    public class SectionData {
        var cells : [CellData] = []
        var footerHeight : CGFloat = 0
        init(cells: [CellData], footerHeight: CGFloat) {
            self.cells = cells
            self.footerHeight = footerHeight
        }
        init() {

        }

    }

    var sections : [SectionData] = []

    var investor: Bool = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        updateData()

        // Do any additional setup after loading the view.
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(type: InvestorTextFieldTableViewCell.self)
        tableView.registerNibCell(type: InvestorSelectTableViewCell.self)
        tableView.registerNibCell(type: InvestorBtnTableViewCell.self)
    }

    func updateData() {
        // check update or create
        let sectionData = SectionData()
        let fullNameCell = CellData(cellType: .inputType, avartar: "", title: "Họ và tên *", placeholder: "Họ và tên của bạn", isRequired: true, data: "", cellKeyboardType: .normal, cellHeight: 60, sourceData : nil)
        sectionData.cells.append(fullNameCell)

        let birthdayCell = CellData(cellType: .dateType, avartar: "", title: "Ngày sinh *", placeholder: "Ngày sinh của bạn", isRequired: true, data: "", cellKeyboardType: .normal, cellHeight: 60, sourceData: nil)
        sectionData.cells.append(birthdayCell)

        let idenNumberCell = CellData(cellType: .inputType, avartar: "", title: "Số chứng minh thư *", placeholder: "Số CMTND của bạn", isRequired: true, data: "", cellKeyboardType: .number, cellHeight: 60, sourceData : nil)
        sectionData.cells.append(idenNumberCell)

        let emailCell = CellData(cellType: .inputType, avartar: "", title: "Địa chỉ email *", placeholder: "Địa chỉ email của bạn", isRequired: true, data: "", cellKeyboardType: .email, cellHeight: 60, sourceData : nil)
        sectionData.cells.append(emailCell)

        let addressCell = CellData(cellType: .selectType, avartar: "", title: "Địa chỉ nhà *", placeholder: "Nhấn để chọn địa chỉ", isRequired: true, data: Address(), cellKeyboardType: .normal, cellHeight: 60, sourceData: nil)
        sectionData.cells.append(addressCell)

        let bankAccountCell = CellData(cellType: .btnType, avartar: "", title: "Chọn tài khoản ngân hàng", placeholder: "Thêm tài khoản ngân hàng", isRequired: true, data: Address(), cellKeyboardType: .normal, cellHeight: 60, sourceData: nil)
        sectionData.cells.append(bankAccountCell)

        let facebookConnectCell = CellData(cellType: .btnType, avartar: "", title: "Kết nối tài khoản Facebook", placeholder: "Kết nối với Facebook", isRequired: true, data: Address(), cellKeyboardType: .normal, cellHeight: 60, sourceData: nil)
        sectionData.cells.append(facebookConnectCell)

        sections.append(sectionData)
        self.tableView.reloadData()

        if investor == false {
            // create

        } else {
            // update
        }
    }
}

extension InvestorSignupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        let cellData = currentSection.cells[indexPath.row]
        let cell = tableView.dequeueReusableNibCell(type: cellData.cellType.cellType)
        
        if let cell = cell as? InvestorTextFieldTableViewCell {
            switch cellData.cellKeyboardType {
            case .phone :
                cell.fieldTf.keyboardType = .phonePad
            case .email :
                cell.fieldTf.keyboardType = .emailAddress
            case .number :
                cell.fieldTf.keyboardType = .numberPad
            default:
                cell.fieldTf.keyboardType = .default
            }
            cell.editTf(currentText: cellData.data as! String) { (text) in
                cellData.data = text!
            }
            cell.fieldTf.placeholder = cellData.placeholder
            cell.titleLb.text = cellData.title
        } else if let cell = cell as? InvestorSelectTableViewCell {
            cell.titleLb.text = cellData.title
            if let data = cellData.data as? Date {

            }
            cell.fieldLb.text = cellData.placeholder
        } else if let cell = cell as? InvestorBtnTableViewCell {

        }
        return cell ?? UITableViewCell()
    }

    /// Show date time Picker
    func showDateDialog(cellData : CellData) {
        var defaultDate = Date()
        if let date = cellData.data as? Date {
            defaultDate = date
        }
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: defaultDate , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in

            if let date = date {
                cellData.data = date
                // self.birthDay = date
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section]
        let cellData = currentSection.cells[indexPath.row]
        return cellData.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionData = sections[section]
        return sectionData.footerHeight
    }

}
