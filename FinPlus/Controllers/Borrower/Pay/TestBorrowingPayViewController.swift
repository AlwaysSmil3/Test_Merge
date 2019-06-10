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
    public var id = 0
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
    public var id = 0
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
        case PayTypeOverdueCell
        case PayAllOverdueCell

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
            case .PayTypeOverdueCell:
                return PayTypeOverdueTBCell.self
            case .PayAllOverdueCell:
                return PayAllOverdueTBCell.self
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
    //var bankList = [AccountBank]()
    var paymentList = [PaymentMethod]()
    
    //Tra ky nay
    var payAmountPresent: Double = 0
    //Tra truoc toan bo
    var payTotalAmount: Double = 0
    
    var isOntime = true
    var isDebt = false
    
    var expireDateString = ""
    
    var paymentInfo: PaymentInfoMoney? {
        didSet {
            guard let _  = self.paymentInfo else { return }
            self.updatePriceData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.updateData()
        self.getPaymentInfo()
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updatePriceData() {
        guard let pay  = self.paymentInfo else { return }
        
        if let period = pay.paymentPeriod {
            self.payAmountPresent = period.feeOverdue! + period.interest! + period.overdue! + period.principal! + period.borrowerManagingFee! + period.borrowerManagingFeeOverdue! + period.principalOverdue! + period.interestOverdue!
            
            if period.overdue! > 0 {
                self.isOntime = false
            }
        }
        
        if let total = pay.liquidation {
            self.payTotalAmount = total.fee! + total.interest! + total.outstanding! + total.borrowerManagingFeeOverDue! + total.borrowerManagingFee! + total.principalOverdue! + total.interestOverdue! + total.overdue! + total.feeOverdue!
            
            if total.debt! > 0 {
                self.isDebt = true
            }
        }
        self.tableView?.reloadData()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
//        tableView.registerNibCell(type: BorrowingPayInfoTableViewCell.self)
        tableView.registerNibCell(type: PayTypeTableViewCell.self)
        tableView.registerNibCell(type: PayAllTableViewCell.self)
        tableView.registerNibCell(type: PaymentMethodTableViewCell.self)
//        tableView.registerNibCell(type: BankAccountTableViewCell.self)
//        tableView.registerNibCell(type: AddNewWalletTableViewCell.self)
        tableView.registerNibCell(type: PayBtnTableViewCell.self)
        tableView.registerNibCell(type: PayTypeOverdueTBCell.self)
        tableView.registerNibCell(type: PayAllOverdueTBCell.self)
    }

    func updateData() {
        // let infoData = BorrowingInfoBasicData(contractCode: "AABBCC", loanMoney: 100000000, expireAmountTime: 12, inerestPerMonth: 2000000, numberOfMonthPaid: 2, nextDayHaveToPaid: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        
        guard let loan = DataManager.shared.browwerInfo?.activeLoan, let cate = loan.loanCategoryId else { return }

        var rate = 0
        //Lãi suất
        if let inRate = loan.inRate, inRate > 0 {
            rate = Int(inRate)
        }
        
        let term: Float = cate == Loan_Student_Category_ID ? 1 : Float((loan.term ?? 0)/30)
        
        let amount = loan.funded ?? 0
        let originAmount = Float(amount / term)
        
        //Số tiền thanh toán hàng tháng
        let payMounth = FinPlusHelper.CalculateMoneyPayMonth(month: Double(amount), term: Double((loan.term ?? 0)/30), rate: Double(rate))
        
        let interestAmount = Float(payMounth) - originAmount
        
        //Thanh toán cả năm
        let amountCurrentTotal: Float = amount - amount * Float(loan.paidMonth ?? 0) / term
        //Phi thanh toán cả năm
        let interestTotalAmount: Float = Float((amountCurrentTotal * Float(rate)/100))
        //Phí thanh toán trước nợ
        let feePayBefore = Float((amount - originAmount * Float(loan.paidMonth ?? 0)) * 2/100)
        
//        self.payAmountPresent = Double(originAmount + interestAmount)
//        self.payTotalAmount = Double(interestTotalAmount + feePayBefore + amount)
        
        var expireDate = Date.init(fromString: loan.nextPaymentDate ?? "", format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
        
        self.expireDateString = expireDate.toString(.custom(kDisplayFormat))
        
        if self.payAmountPresent == 0, let dateString = self.checkCollectionRightPayForStatusTimelyDebt() {
            self.expireDateString = dateString
            expireDate = Date(fromString: dateString, format: DateFormat.custom(kDisplayFormat))
        }
        
        self.updatePriceData()
        
        let payType1 = PayType(id: 1, typeTitle: "Phai tra thang nay", expireDate: expireDate, originAmount: originAmount, interestAmount: interestAmount, sumAmount: originAmount + interestAmount)
        let payAll = PayAllBefore(id: 1, typeTitle: "Tra tat ca luon", originAmount: Float(amount), interestAmount: interestTotalAmount, feeToPayBefore: feePayBefore, sumAmount: Float(self.payTotalAmount))
        let payTypeArray = [payType1]
        // create list payment method
        self.payTypeSelected = payType1
        
        let cashInPayment = PaymentMethod(wID: 1, wMethodTitle: "Chuyển khoản/tiền mặt", wMethodDescription: "Chuyển khoản qua internet hoặc đến ngân hàng để chuyển tiền mặt đến một trong những tài khoản ngân hàng của chúng tôi.", wMethodType: 1)
//        let ATMPayment = PaymentMethod(wID: 2, wMethodTitle: "Sử dụng ATM nội địa", wMethodDescription: "Bạn sẽ được chuyển qua website napas.com.vn để hoàn tất quá trình thanh toán.", wMethodType: 2)
//        let viettelPayPayment = PaymentMethod(wID: 3, wMethodTitle: "Thanh toán qua ví ViettelPay", wMethodDescription: "Chuyển qua ứng dụng ViettelPay để thanh toán. Bạn sẽ được chuyển về Mony sau khi hoàn thành.", wMethodType: 3)
//        let momoPayment = PaymentMethod(wID: 4, wMethodTitle: "Thanh toán qua ví MoMo", wMethodDescription: "Chuyển qua ứng dụng MoMo để thanh toán. Bạn sẽ được chuyển về Mony sau khi hoàn thành.", wMethodType: 4)
        paymentList.append(cashInPayment)
        //paymentList.append(ATMPayment)
        //paymentList.append(viettelPayPayment)
//        paymentList.append(momoPayment)
        
        if paymentList.count > 0 {
            self.methodSelected = paymentList[0]
        }
        
        // borrowingPay = BorrowingData(basicInfo: infoData, payType: payTypeArray, payAll: payAll, walletList: self.bankList)
        
        if let liqui = self.paymentInfo?.liquidation, liqui.outstanding == 0 {
            newBorrowingPay = NewBorrowingData(payType: payTypeArray, payAll: nil, paymentMethod: paymentList)
        } else {
            if let term = DataManager.shared.browwerInfo?.activeLoan?.term, term <= 30 {
                newBorrowingPay = NewBorrowingData(payType: payTypeArray, payAll: nil, paymentMethod: paymentList)
            } else {
                if self.checkTimeIsInLastCollection() {
                    newBorrowingPay = NewBorrowingData(payType: payTypeArray, payAll: nil, paymentMethod: paymentList)
                } else {
                    newBorrowingPay = NewBorrowingData(payType: payTypeArray, payAll: payAll, paymentMethod: paymentList)
                }
            }
        }
        
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
                    if self.isOntime {
                        let cellNewPhone = CellData(cellType: .PayTypeCell, data: payType, cellHeight: 146)
                        sectionPayTypeData.cells.append(cellNewPhone)
                    } else {
                        let cellNewPhone = CellData(cellType: .PayTypeOverdueCell, data: payType, cellHeight: 258)
                        sectionPayTypeData.cells.append(cellNewPhone)
                    }
                }
            }
        }
        
        if let payAll = newBorrowingPay.payAll {
            if !self.isDebt {
                let cellNewPhone = CellData(cellType: .PayAllCell, data: payAll, cellHeight: 146)
                sectionPayTypeData.cells.append(cellNewPhone)
            } else {
                let cellNewPhone = CellData(cellType: .PayAllOverdueCell, data: payAll, cellHeight: 258)
                sectionPayTypeData.cells.append(cellNewPhone)
            }
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
        //tableView.reloadData()
    }
    
    func getPaymentInfo() {
        APIClient.shared.getPaymentMoneyInfo()
            .done(on: DispatchQueue.global()) { [weak self] model in
                DispatchQueue.main.async {
                    self?.paymentInfo = model
                }
            }
            .catch { error in }
    }
    
    /// Check  xem có đang ở thời gian của kỳ trả cuối không
    func checkTimeIsInLastCollection() -> Bool {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections, collections.count > 1 else { return false }
        
        let count = collections.count
        if let monthPayedString = collections[count - 2].dueDatetime, monthPayedString.count > 0 {
            let monthPayed = Date(fromString: monthPayedString, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
            
            let dateFormatString = monthPayed.toString(DateFormat.custom(kDisplayFormat))
            let dateFormatStringCurrent = Date().toString(DateFormat.custom(kDisplayFormat))
            
            let datePayedResult = Date(fromString: dateFormatString, format: .custom(kDisplayFormat)).dateByAddingDays(1)
            let dateCurrentResult = Date(fromString: dateFormatStringCurrent, format: .custom(kDisplayFormat))
            
            if dateCurrentResult >= datePayedResult {
                return true
            }
        }
        return false
    }
    
    //Check đã thanh toán kỳ nào chưa
    func checkCollectionRightPayForStatusTimelyDebt() -> String? {
        guard let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let collections = activeLoan.collections else { return nil }
        
        let monthCurrent = Date().month()
        
        for col in collections {
            if let status = col.status, status == 2 {
                if let monthPayed = col.dueDatetime {
                    let date = Date(fromString: monthPayed, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
                    let month = date.month()
                    if monthCurrent + 1 == month || monthCurrent == month {
                        let days = date.days(from: Date())
                        if days > 0 && days <= 31 {
                            return date.toString(.custom(kDisplayFormat))
                        }
                    }
                }
            }
        }
        return nil
    }

    @objc func payBtnAction() {
        // check and show mony bank list
        guard let _ = self.paymentInfo else { return }
        if self.methodSelected != nil {
            
            let monyBankListVC = MonyBankListViewController(nibName: "MonyBankListViewController", bundle: nil)
            
            if self.payAllSelected != nil {
                monyBankListVC.amount = self.payTotalAmount
                monyBankListVC.isTotalPayed = true
            } else {
                if self.payAmountPresent == 0 {
                    self.showGreenBtnMessage(title: "Thông báo", message: "Bạn đã thanh toán cho kỳ thanh toán ngày \(self.expireDateString). Bạn có thể lựa chọn tất toán toàn bộ khoản vay trước hạn. Xin cảm ơn.", okTitle: "Đóng", cancelTitle: nil)
                    return
                }
                monyBankListVC.amount = self.payAmountPresent
                monyBankListVC.isTotalPayed = false
            }
            
            if let navi = self.navigationController {
                navi.pushViewController(monyBankListVC, animated: true)
            } else {
                self.present(monyBankListVC, animated: true, completion: nil)
            }
        } else {
            self.showGreenBtnMessage(title: "Không thể thanh toán", message: "Bạn cần chọn hình thức thanh toán trước khi tiến hành thanh toán", okTitle: "Ok", cancelTitle: nil)
        }
    }
    
}

extension TestBorrowingPayViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? 138 : 126
        }
        
        let cellData = sections[indexPath.section].cells[indexPath.row]
        return cellData.cellHeight + 12
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
            if let d = cellData.data as? BorrowingInfoBasicData {
                cell.tableData = d
            }
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
            
            cell.isOnTime = self.isOntime
            cell.dateExpire = self.expireDateString
            cell.updateCellView()
            cell.paymentData = self.paymentInfo?.paymentPeriod
        } else if let cell = cell as? PayTypeOverdueTBCell {
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
            
            //cell.isOnTime = self.isOntime
            cell.dateExpire = self.expireDateString
            cell.updateCellView()
            cell.data = self.paymentInfo?.paymentPeriod
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
            
            cell.isDebt = self.isDebt
            cell.updateCellView()
            cell.paymentData = self.paymentInfo?.liquidation
        } else if let cell = cell as? PayAllOverdueTBCell {
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
            
            //cell.isDebt = self.isDebt
            cell.updateCellView()
            cell.data = self.paymentInfo?.liquidation
        } else if let _ = cell as? BankAccountTableViewCell {
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
        } else if let _ = cell as? AddNewWalletTableViewCell {
            // add taget for cell
//            cell.updateCellView()
        } else if let cell = cell as? PayBtnTableViewCell {
            cell.payBtn.addTarget(self, action:#selector(payBtnAction), for: .touchUpInside)
        } else if let cell = cell as? PaymentMethodTableViewCell {
            let data = cellData.data as! PaymentMethod
//            if data.id == 1 {
//                let cellData = sections[indexPath.section].cells[indexPath.row]
//                if let d = cellData.data as? PaymentMethod {
//                    self.methodSelected = d
//                }
//                cell.isSelectedCell = true
//            }
            
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if isOntime {
                    return 146
                }
                //return 156
                return 258
            }
            
            if !isDebt {
                return 146
            }
            //return 136
            return 258
        }
        
        let cellData = sections[indexPath.section].cells[indexPath.row]
        return cellData.cellHeight + 12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sections[indexPath.section].cells[indexPath.row]

        let cell = tableView.cellForRow(at: indexPath)
        if let _ = cell as? PayTypeTableViewCell {
            if let d = cellData.data as? PayType {
                self.payTypeSelected = d
            }
            payAllSelected = nil
        } else if let _ = cell as? PayAllTableViewCell {
            if let d = cellData.data as? PayAllBefore {
                self.payAllSelected = d
            }
            self.payTypeSelected = nil
        } else if let _ = cell as? BankAccountTableViewCell {
//            self.walletSelected = cellData.data as! AccountBank
        } else if let _ = cell as? AddNewWalletTableViewCell {
            // push to add new wallet
            let vc = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let _ = cell as? PaymentMethodTableViewCell {
            if let d = cellData.data as? PaymentMethod {
                self.methodSelected = d
            }
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
