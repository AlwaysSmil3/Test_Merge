//
//  BorrowingPayInfoTableViewCell.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BorrowingPayInfoTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableData : BorrowingInfoBasicData! {
        didSet {
            tableView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNibCell(type: SubInfoTableViewCell.self)
        self.tableView.registerNibCell(type: SubInfoLastTableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        // update data
        // Initialization code
    }

    func updateData() {

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row + 1 == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubInfoLastTableViewCell", for: indexPath) as! SubInfoLastTableViewCell
            cell.titleLb.text = "Ngày thanh toán tiếp theo"
            let dateStr = Date().convertDateToDisplayFormat(tableData.nextDayHaveToPaid)
            cell.valueLb.text = dateStr
            let numberOfDay = 5
            cell.detailLb.text = "Chú ý: Đơn vay này còn \(numberOfDay) ngày nữa đến ngày thanh toán tiếp theo"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubInfoTableViewCell", for: indexPath) as! SubInfoTableViewCell
            switch indexPath.row{
            case 0:
                cell.titleLb.text = "Mã hợp đồng"
                cell.valueLb.text = tableData.contractCode
            case 1:
                cell.titleLb.text = "Số tiền vay"
                let formatter = NumberFormatter()
                formatter.locale = Locale.current
                formatter.numberStyle = .currency
                if let formattedTipAmount = formatter.string(from: tableData.loanMoney as NSNumber) {
                    cell.valueLb.text = formattedTipAmount
                } else {
                    cell.valueLb.text = tableData.loanMoney.toString()
                }

                // cell.valueLb.text = "\(tableData.loanMoney)"
            case 2:
                cell.titleLb.text = "Thời hạn vay được duyệt"
                cell.valueLb.text = "\(tableData.expireAmountTime) tháng"
            case 3:
                cell.titleLb.text = "Trả góp hàng tháng"
                let formatter = NumberFormatter()
                formatter.locale = Locale.current
                formatter.numberStyle = .currency
                if let formattedTipAmount = formatter.string(from: tableData.inerestPerMonth as NSNumber) {
                    cell.valueLb.text = formattedTipAmount
                } else {
                    cell.valueLb.text = tableData.inerestPerMonth.toString()
                }
                // cell.valueLb.text = "\(tableData.inerestPerMonth)"
            default :
                cell.titleLb.text = "Số tháng đã thanh toán"
                cell.valueLb.text = "\(tableData.numberOfMonthPaid) tháng"
            }
            
            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row + 1 == 6 {
            return 100
        } else {
            return 50
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
