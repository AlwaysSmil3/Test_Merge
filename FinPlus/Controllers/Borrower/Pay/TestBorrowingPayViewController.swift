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
    public var loanMoney : Float = 0
    public var expireAmountTime : Int = 0
    public var inerestPerMonth : Float = 0
    public var numberOfMonthPaid : Int = 0
    public var nextDayHaveToPaid : Date
}

public class PayType {
    public var id : Int = 0
    public var typeTitle : String!
    public var expireDate : Date
    public var originAmount : Float = 0
    public var interestAmount : Float = 0
    public var sumAmount : Float = 0
    init(id: Int, typeTitle: String, expireDate: Date, originAmount: Float, interestAmount: Float, sumAmount: Float) {
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
    public var originAmount : Float = 0
    public var interestAmount : Float = 0
    public var feeToPayBefore : Float = 0
    public var sumAmount : Float = 0
    init(id: Int, typeTitle: String, originAmount: Float, interestAmount: Float, feeToPayBefore: Float, sumAmount: Float) {
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
    public var walletList : [AccountBank]?
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
                return PayBtnTableViewCell.self
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
    var walletSelected : AccountBank!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // update data
        updateData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(type: BorrowingPayInfoTableViewCell.self)
        tableView.registerNibCell(type: PayTypeTableViewCell.self)
        tableView.registerNibCell(type: PayAllTableViewCell.self)
        tableView.registerNibCell(type: BankAccountTableViewCell.self)
        tableView.registerNibCell(type: AddNewWalletTableViewCell.self)
        tableView.registerNibCell(type: PayBtnTableViewCell.self)
    }

    func updateData() {
        let infoData = BorrowingInfoBasicData(contractCode: "AABBCC", loanMoney: 100000000, expireAmountTime: 12, inerestPerMonth: 2000000, numberOfMonthPaid: 2, nextDayHaveToPaid: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let payType1 = PayType(id: 1, typeTitle: "Phai tra thang nay", expireDate: Date(), originAmount: 1000000, interestAmount: 500000, sumAmount: 20000000)
        let payAll = PayAllBefore(id: 1, typeTitle: "Tra tat ca luon", originAmount: 3000000, interestAmount: 100000, feeToPayBefore: 2000000, sumAmount: 7000000)
        let wallet1 = AccountBank(wID: 1, wType: 1, wAccountName: "0987654231234", wBankName: "Vietcombank", wNumber: "212312309123", wDistrict: "Hà Nội")
        let wallet2 = AccountBank(wID: 1, wType: 2, wAccountName: "0987654231234", wBankName: "Techcombank", wNumber: "102312321876", wDistrict: "Hà Nội")

        let payTypeArray = [payType1]
        let walletArray = [wallet1, wallet2]
        borrowingPay = BorrowingData(basicInfo: infoData, payType: payTypeArray, payAll: payAll, walletList: walletArray)

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

        let cellPayBtn = CellData(cellType: .PayBtnCell, data: "", cellHeight: 60)
        sectionWalletData.cells.append(cellPayBtn)

        self.sections.append(sectionBasicData)
        self.sections.append(sectionPayTypeData)
        self.sections.append(sectionWalletData)
        tableView.reloadData()
    }

    @objc func payBtnAction() {
        print("pay btn action")
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
            
        } else if let cell = cell as? PayTypeTableViewCell {
            let data = cellData.data as! PayType
            if let selected = self.payTypeSelected {
                if selected.id == data.id {
                    cell.isSelectedCell = true
                } else {
                    cell.isSelectedCell = false
                }
            } else {
                cell.isSelectedCell = false
            }
            cell.cellData = data
            cell.updateCellView()

        } else if let cell = cell as? PayAllTableViewCell {
            let data = cellData.data as! PayAllBefore
            if let selected = self.payAllSelected {
                if selected.id == data.id {
                    cell.isSelectedCell = true
                } else {
                    cell.isSelectedCell = false
                }
            } else {
                cell.isSelectedCell = false
            }
            cell.cellData = data
            cell.updateCellView()

        } else if let cell = cell as? BankAccountTableViewCell {
            let data = cellData.data as! AccountBank
            if let selected = self.walletSelected {
                if selected.accountBankNumber == data.accountBankNumber {
                    cell.isSelectedCell = true
                } else {
                    cell.isSelectedCell = false
                }
            }
            cell.cellData = data
            cell.updateCellView()

        } else if let cell = cell as? AddNewWalletTableViewCell {
            // add taget for cell
            cell.updateCellView()
        } else if let cell = cell as? PayBtnTableViewCell {
            cell.payBtn.addTarget(self, action:#selector(payBtnAction), for: .touchUpInside)
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
        if let _ = cell as? PayTypeTableViewCell {
            self.payTypeSelected = cellData.data as! PayType
            payAllSelected = nil

        } else if let _ = cell as? PayAllTableViewCell {
            self.payAllSelected = cellData.data as! PayAllBefore
            self.payTypeSelected = nil

        } else if let _ = cell as? BankAccountTableViewCell {
            self.walletSelected = cellData.data as! AccountBank

        } else if let _ = cell as? AddNewWalletTableViewCell {
            // push to add new wallet
        }
        tableView.reloadData()
//        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.automatic)
    }

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
