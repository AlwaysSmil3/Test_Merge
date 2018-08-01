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

public struct NewBorrowingData {
    public var payType : [PayType]?
    public var payAll : PayAllBefore?
    public var paymentMethod : [PaymentMethod]?
}

class TestBorrowingPayViewController: UIViewController {

    @IBAction func showPayHistoryVC(_ sender: Any) {
        let payHistoryVC = TestPayHistoryViewController(nibName: "TestPayHistoryViewController", bundle: nil)
        self.present(payHistoryVC, animated: true, completion: nil)
    }
    enum Cell {
        // case InfoCell
        case PayTypeCell
        case PayAllCell
        case PaymentMethodCell
        // case BankAccountCell
        // case AddNewWalletCell
        case PayBtnCell

        var cellType: UITableViewCell.Type {
            switch self {
//            case .InfoCell:
//                return BorrowingPayInfoTableViewCell.self
            case .PayTypeCell:
                return PayTypeTableViewCell.self
            case .PayAllCell:
                return PayAllTableViewCell.self
            case .PaymentMethodCell:
                return PaymentMethodTableViewCell.self
//            case .BankAccountCell:
//                return BankAccountTableViewCell.self
//            case .AddNewWalletCell:
//                return AddNewWalletTableViewCell.self
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
    // var borrowingPay : BorrowingData!
    var newBorrowingPay : NewBorrowingData!
    var payTypeSelected : PayType!
    var payAllSelected : PayAllBefore!
    // var walletSelected : AccountBank!
    var methodSelected : PaymentMethod!
    var bankList = [AccountBank]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // update data
        self.updateData()
        // Do any additional setup after loading the view.
    }
    
    func getUserBankList() {
        APIClient.shared.getListBank(uId: DataManager.shared.userID).done { (bankList) in
            self.bankList = bankList
            self.updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = true
        }
        self.getUserBankList()
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
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.registerNibCell(type: BorrowingPayInfoTableViewCell.self)
        tableView.registerNibCell(type: PayTypeTableViewCell.self)
        tableView.registerNibCell(type: PayAllTableViewCell.self)
        tableView.registerNibCell(type: PaymentMethodTableViewCell.self)
//        tableView.registerNibCell(type: BankAccountTableViewCell.self)
//        tableView.registerNibCell(type: AddNewWalletTableViewCell.self)
        tableView.registerNibCell(type: PayBtnTableViewCell.self)
    }

    func updateData() {
        // let infoData = BorrowingInfoBasicData(contractCode: "AABBCC", loanMoney: 100000000, expireAmountTime: 12, inerestPerMonth: 2000000, numberOfMonthPaid: 2, nextDayHaveToPaid: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let payType1 = PayType(id: 1, typeTitle: "Phai tra thang nay", expireDate: Date(), originAmount: 1000000, interestAmount: 500000, sumAmount: 20000000)
        let payAll = PayAllBefore(id: 1, typeTitle: "Tra tat ca luon", originAmount: 3000000, interestAmount: 100000, feeToPayBefore: 2000000, sumAmount: 7000000)
        let payTypeArray = [payType1]
        // create list payment method
        var paymentList = [PaymentMethod]()
        let cashInPayment = PaymentMethod(wID: 1, wMethodTitle: "Chuyển khoản/tiền mặt", wMethodDescription: "Chuyển khoản qua internet hoặc đến ngân hàng để chuyển tiền mặt đến một trong những tài khoản ngân hàng của chúng tôi.", wMethodType: 1)
        let ATMPayment = PaymentMethod(wID: 2, wMethodTitle: "Sử dụng ATM nội địa", wMethodDescription: "Bạn sẽ được chuyển qua website napas.com.vn để hoàn tất quá trình thanh toán.", wMethodType: 2)
        let viettelPayPayment = PaymentMethod(wID: 3, wMethodTitle: "Thanh toán qua ví ViettelPay", wMethodDescription: "Chuyển qua ứng dụng ViettelPay để thanh toán. Bạn sẽ được chuyển về Mony sau khi hoàn thành.", wMethodType: 3)
        paymentList.append(cashInPayment)
        paymentList.append(ATMPayment)
        paymentList.append(viettelPayPayment)
        
        // borrowingPay = BorrowingData(basicInfo: infoData, payType: payTypeArray, payAll: payAll, walletList: self.bankList)
        newBorrowingPay = NewBorrowingData(payType: payTypeArray, payAll: payAll, paymentMethod: paymentList)
        self.sections.removeAll()
//        let sectionBasicData = SectionData()
//        sectionBasicData.title = "Thông tin khoản vay"
        
//        if let basicInfo = borrowingPay.basicInfo {
//            // caculate cell height
//            let cellNewPhone = CellData(cellType: .InfoCell, data: basicInfo, cellHeight: 366)
//            sectionBasicData.cells.append(cellNewPhone)
//        }
        
        let sectionPayTypeData = SectionData()
        sectionPayTypeData.title = "Chọn loại thanh toán"
        if let payTypeArray = newBorrowingPay.payType {
            if payTypeArray.count != 0 {
                for payType in payTypeArray {
                    let cellNewPhone = CellData(cellType: .PayTypeCell, data: payType, cellHeight: 126)
                    sectionPayTypeData.cells.append(cellNewPhone)
                }
            }
        }
        
        if let payAll = newBorrowingPay.payAll {
            let cellNewPhone = CellData(cellType: .PayAllCell, data: payAll, cellHeight: 126)
            sectionPayTypeData.cells.append(cellNewPhone)

        }
        
        let sectionWalletData = SectionData()
        sectionWalletData.title = "Hình thức thanh toán"
        if let paymentArray = newBorrowingPay.paymentMethod {
            if paymentArray.count != 0 {
                for payment in paymentArray {
                    let cellNewPhone = CellData(cellType: .PaymentMethodCell, data: payment, cellHeight: 95)
                    sectionWalletData.cells.append(cellNewPhone)
                }
            }
        }

//        let cellAddWallet = CellData(cellType: .AddNewWalletCell, data: "", cellHeight: 60)
//        sectionWalletData.cells.append(cellAddWallet)

        let cellPayBtn = CellData(cellType: .PayBtnCell, data: "", cellHeight: 60)
        sectionWalletData.cells.append(cellPayBtn)

//        self.sections.append(sectionBasicData)
        self.sections.append(sectionPayTypeData)
        self.sections.append(sectionWalletData)
        tableView.reloadData()
    }

    @objc func payBtnAction() {
        // check and show mony bank list
        if self.methodSelected != nil {
            if (self.methodSelected.id == 1) {
                let monyBankListVC = MonyBankListViewController(nibName: "MonyBankListViewController", bundle: nil)
                if let navi = self.navigationController {
                    self.navigationController?.pushViewController(monyBankListVC, animated: true)
                } else {
                    self.present(monyBankListVC, animated: true, completion: nil)
                }
            }
        } else {
            self.showGreenBtnMessage(title: "Không thể thanh toán", message: "Bạn cần chọn hình thức thanh toán trước khi tiến hành thanh toán", okTitle: "Ok", cancelTitle: nil)
        }
        
    }

}

extension TestBorrowingPayViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        return cellData.cellHeight
    }

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
//            let data = cellData.data as! AccountBank
//            if let selected = self.walletSelected {
//                if selected.accountBankNumber == data.accountBankNumber {
//                    cell.isSelectedCell = true
//                } else {
//                    cell.isSelectedCell = false
//                }
//            }
//            cell.cellData = data
//            cell.updateCellView()

        } else if let cell = cell as? AddNewWalletTableViewCell {
            // add taget for cell
//            cell.updateCellView()
        } else if let cell = cell as? PayBtnTableViewCell {
            cell.payBtn.addTarget(self, action:#selector(payBtnAction), for: .touchUpInside)
        } else if let cell = cell as? PaymentMethodTableViewCell {
            let data = cellData.data as! PaymentMethod
            if let selected = self.methodSelected {
                if selected.id == data.id {
                    cell.isSelectedCell = true
                } else {
                    cell.isSelectedCell = false
                }
            }
            cell.cellData = data
            cell.updateCellView()
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
//            self.walletSelected = cellData.data as! AccountBank

        } else if let _ = cell as? AddNewWalletTableViewCell {
            // push to add new wallet
            let vc = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let _ = cell as? PaymentMethodTableViewCell {
            self.methodSelected = cellData.data as! PaymentMethod
        }
        tableView.reloadData()
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].title
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleStr = sections[section].title
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        let headerLb = UILabel(frame: CGRect(x: 8, y: 8, width: self.view.frame.size.width - 16, height: 20))
        headerLb.text = titleStr
        headerLb.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: 11)
        headerLb.textColor = UIColor(hexString: "#4D6678")
        headerView.addSubview(headerLb)
        return headerView
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

