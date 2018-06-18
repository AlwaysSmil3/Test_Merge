//
//  TestBorrowingPayViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

public struct BorrowingInfoBasicData {
    public var contractCode: String!
    public var loanMoney : Double = 0
    public var expireAmountTime : Int = 0
    public var inerestPerMonth : Double = 0
    public var numberOfMonthPaid : Int = 0
    public var nextDayHaveToPaid : Date
}

public class PayType {
    public var id : Int = 0
    public var typeTitle : String!
    public var expireDate : Date
    public var originAmount : Double = 0
    public var interestAmount : Double = 0
    public var sumAmount : Double = 0
    init(id: Int, typeTitle: String, expireDate: Date, originAmount: Double, interestAmount: Double, sumAmount: Double) {
        self.id = id
        self.typeTitle = typeTitle
        self.expireDate = expireDate
        self.originAmount = originAmount
        self.interestAmount = interestAmount
        self.sumAmount = sumAmount
    }
}

public class PayAllBefore {
    public var id : Int = 0
    public var typeTitle : String = ""
    public var originAmount : Double = 0
    public var interestAmount : Double = 0
    public var feeToPayBefore : Double = 0
    public var sumAmount : Double = 0
    init(id: Int, typeTitle: String, originAmount: Double, interestAmount: Double, feeToPayBefore: Double, sumAmount: Double) {
        self.id = id
        self.typeTitle = typeTitle
        self.originAmount = originAmount
        self.interestAmount = interestAmount
        self.feeToPayBefore = feeToPayBefore
        self.sumAmount = sumAmount
    }
}

public struct BorrowingData {
    public var basicInfo : BorrowingInfoBasicData?
    public var payType : [PayType]?
    public var payAll : PayAllBefore?
    public var walletList : [Wallet]?
}

class TestBorrowingPayViewController: UIViewController {

    @IBAction func showPayHistoryVC(_ sender: Any) {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        self.present(payHistoryVC, animated: true, completion: nil)
    }
    enum Cell {
        case InfoCell
        case PayTypeCell
        case PayAllCell
        case BankAccountCell
        case AddNewWalletCell
        case PayBtnCell

        var cellType: UITableViewCell.Type {
            switch self {
            case .InfoCell:
                return BorrowingPayInfoTableViewCell.self
            case .PayTypeCell:
                return PayTypeTableViewCell.self
            case .PayAllCell:
                return PayAllTableViewCell.self
            case .BankAccountCell:
                return BankAccountTableViewCell.self
            case .AddNewWalletCell:
                return AddNewWalletTableViewCell.self
            case .PayBtnCell:
                return UITableViewCell.self
            default:
                return UITableViewCell.self
            }
        }
    }

    class CellData {
        var cellType: Cell!
        var data: Any
        var cellHeight : CGFloat = 44
        init(cellType: Cell, data: Any, cellHeight: CGFloat ) {
            self.cellType = cellType
            self.data = data
            self.cellHeight = cellHeight
        }
    }

    class SectionData {
        var title : String!
        var cells : [CellData] = []
        var footerHeight : CGFloat = 50
        init(cells: [CellData], footerHeight: CGFloat, title: String) {
            self.cells = cells
            self.footerHeight = footerHeight
            self.title = title
        }
        init() {

        }
    }

    @IBOutlet weak var tableView: UITableView!
    var sections : [SectionData] = []
    var borrowingPay : BorrowingData!
    var payTypeSelected : PayType!
    var payAllSelected : PayAllBefore!
    var walletSelected : Wallet!
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoData = BorrowingInfoBasicData(contractCode: "AABBCC", loanMoney: 100000000, expireAmountTime: 12, inerestPerMonth: 2000000, numberOfMonthPaid: 2, nextDayHaveToPaid: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let payType1 = PayType(id: 1, typeTitle: "Phai tra thang nay", expireDate: Date(), originAmount: 1000000, interestAmount: 500000, sumAmount: 20000000)
        let payType2 = PayType(id: 2, typeTitle: "Tra thang sau", expireDate: Date(), originAmount: 4000000, interestAmount: 600000, sumAmount: 90000000)
        let payAll = PayAllBefore(id: 1, typeTitle: "Tra tat ca luon", originAmount: 3000000, interestAmount: 100000, feeToPayBefore: 2000000, sumAmount: 7000000)
        let wallet1 = Wallet(wID: 1, wType: 1, wAccountName: "0987654231234", wName: "MoMo", wNumber: "10231231")
        let wallet2 = Wallet(wID: 1, wType: 2, wAccountName: "0987654231234", wName: "PayPal", wNumber: "10231232")
//        let wallet3 = Wallet(wID: 1, wType: 2, wAccountName: "0987654231234", wName: "Wallet3", wNumber: "10231233")

        let payTypeArray = [payType1, payType2]
        let walletArray = [wallet1, wallet2]
        borrowingPay = BorrowingData(basicInfo: infoData, payType: payTypeArray, payAll: payAll, walletList: walletArray)

        configureTableView()
        updateData()
        // Do any additional setup after loading the view.
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(type: BorrowingPayInfoTableViewCell.self)
        tableView.registerNibCell(type: PayTypeTableViewCell.self)
        tableView.registerNibCell(type: PayAllTableViewCell.self)
        tableView.registerNibCell(type: BankAccountTableViewCell.self)
        tableView.registerNibCell(type: AddNewWalletTableViewCell.self)
    }

    func updateData() {
        self.sections.removeAll()
        let sectionBasicData = SectionData()
        sectionBasicData.title = "Thông tin khoản vay"
        if let basicInfo = borrowingPay.basicInfo {
            // caculate cell height
            let cellNewPhone = CellData(cellType: .InfoCell, data: basicInfo, cellHeight: 366)
            sectionBasicData.cells.append(cellNewPhone)
        }
        let sectionPayTypeData = SectionData()
        sectionPayTypeData.title = "Chọn loại thanh toán"
        if let payTypeArray = borrowingPay.payType {
            if payTypeArray.count != 0 {
                for payType in payTypeArray {
                    let cellNewPhone = CellData(cellType: .PayTypeCell, data: payType, cellHeight: 126)
                    sectionPayTypeData.cells.append(cellNewPhone)
                }
            }
        }
        if let payAll = borrowingPay.payAll {
            let cellNewPhone = CellData(cellType: .PayAllCell, data: payAll, cellHeight: 126)
            sectionPayTypeData.cells.append(cellNewPhone)

        }


        let sectionWalletData = SectionData()
        sectionWalletData.title = "Chọn tài khoản để thanh toán"
        if let walletArray = borrowingPay.walletList {
            if walletArray.count != 0 {
                for wallet in walletArray {
                    let cellNewPhone = CellData(cellType: .BankAccountCell, data: wallet, cellHeight: 60)
                    sectionWalletData.cells.append(cellNewPhone)
                }
            }
        }

        let cellAddWallet = CellData(cellType: .AddNewWalletCell, data: "", cellHeight: 60)

        sectionWalletData.cells.append(cellAddWallet)

        self.sections.append(sectionBasicData)
        self.sections.append(sectionPayTypeData)
        self.sections.append(sectionWalletData)
        tableView.reloadData()
    }

}

extension TestBorrowingPayViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = sections[indexPath.section].cells[indexPath.row]

        let cell = tableView.dequeueReusableNibCell(type: cellData.cellType.cellType)
        if let cell = cell as? BorrowingPayInfoTableViewCell {
            cell.tableData = cellData.data as! BorrowingInfoBasicData
            cell.tableView.layer.cornerRadius = 5
            cell.tableView.layer.borderWidth = 1
            cell.tableView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        } else if let cell = cell as? PayTypeTableViewCell {
            cell.containView.layer.borderWidth = 1
            cell.containView.layer.cornerRadius = 5
            cell.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            let data = cellData.data as! PayType
            cell.titleLb.text = "Thanh toán tháng này"
            cell.dateLb.text = "Hạn: \(data.expireDate)"
            cell.originMoneyLb.text = "Tiền gốc: \(data.originAmount)"
            cell.interestMoneyLb.text = "Tiền lãi: \(data.interestAmount)"
            cell.borrowingLb.text = "\(data.sumAmount)"
            cell.selectionStyle = .none
            if let selected = self.payTypeSelected {
                if selected.id == data.id {
                    cell.containView.layer.borderColor = MAIN_COLOR.cgColor
                    cell.selectImg.image = #imageLiteral(resourceName: "cellSelectedImg")
                }
            }
        } else if let cell = cell as? PayAllTableViewCell {
            cell.selectionStyle = .none
            cell.containView.layer.borderWidth = 1
            cell.containView.layer.cornerRadius = 5
            cell.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            let data = cellData.data as! PayAllBefore
            cell.titleLb.text = "Thanh toán trước toàn bộ"
            cell.originMoneyLb.text = "Tiền gốc: \(data.originAmount)"
            cell.interestMoneyLb.text = "Tiền lãi: \(data.interestAmount)"
            cell.feeReturnBeforeDueDateLb.text = "Phí trả nợ trước hạn: \(data.feeToPayBefore)"
            cell.borrowingLb.text = "\(data.sumAmount)"
            if let selected = self.payAllSelected {
                if selected.id == data.id {
                    cell.containView.layer.borderColor = MAIN_COLOR.cgColor
                    cell.selectImg.image = #imageLiteral(resourceName: "cellSelectedImg")
                }
            }
        } else if let cell = cell as? BankAccountTableViewCell {
            cell.selectionStyle = .none
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            cell.containView.layer.borderWidth = 1
            cell.containView.layer.cornerRadius = 5
            cell.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
            let data = cellData.data as! Wallet
            if data.walletType == 1 {
                cell.walletImg.image = #imageLiteral(resourceName: "momo")
            } else {
                cell.walletImg.image = #imageLiteral(resourceName: "paypal")
            }
            cell.walletNameLb.text = data.walletName
            cell.accountNumberLb.text = data.walletNumber
            if let selected = self.walletSelected {
                if selected.walletNumber == data.walletNumber {
                    cell.containView.layer.borderColor = MAIN_COLOR.cgColor
                    cell.selectImg.image = #imageLiteral(resourceName: "cellSelectedImg")
                }
            }
        } else if let cell = cell as? AddNewWalletTableViewCell {
            cell.containView.layer.borderWidth = 1
            cell.containView.layer.cornerRadius = 5
            cell.containView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
            cell.selectionStyle = .none

        }

        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        return cellData.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sections[indexPath.section].cells[indexPath.row]

        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell as? PayTypeTableViewCell {
            self.payTypeSelected = cellData.data as! PayType
            payAllSelected = nil

        } else if let cell = cell as? PayAllTableViewCell {
            self.payAllSelected = cellData.data as! PayAllBefore
            self.payTypeSelected = nil

        } else if let cell = cell as? BankAccountTableViewCell {
            self.walletSelected = cellData.data as! Wallet
        } else if let cell = cell as? AddNewWalletTableViewCell {
            // push to add new wallet
        }
        tableView.reloadData()
    }

    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell as? PayTypeTableViewCell {
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor

        } else if let cell = cell as? PayAllTableViewCell {
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor

        } else if let cell = cell as? BankAccountTableViewCell {
            cell.selectImg.image = #imageLiteral(resourceName: "cellSelectImg")
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
 */


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathsForSelectedRows = tableView.indexPathsForSelectedRows {
            if indexPathsForSelectedRows.count != 0 {
                for selectedIndexPath : IndexPath in indexPathsForSelectedRows {
                    if selectedIndexPath.section == indexPath.section {
                        tableView.deselectRow(at: selectedIndexPath, animated: false)
                    }
                }
            }
        }

        return indexPath
    }
}
