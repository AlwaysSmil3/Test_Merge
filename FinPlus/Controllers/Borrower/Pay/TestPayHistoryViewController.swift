//
//  TestPayHistoryViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

public enum PayHistoryItemStatus {
    case NotYet
    case NeedToPay
    case NeedToPayNow
    case Paid
}
public class PayHistoryItem {
    var time: Int
    var payDate : Date
    var status: PayHistoryItemStatus
    var amount: Double
    init(time: Int, payDate: Date, status: PayHistoryItemStatus, amount: Double) {
        self.time = time
        self.payDate = payDate
        self.status = status
        self.amount = amount
    }
}

class TestPayHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var payHistoryData = [PayHistoryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNibCell(type: PayHistoryTableViewCell.self)
        self.updateData()
        // Do any additional setup after loading the view.
    }

    func updateData() {
        self.payHistoryData.removeAll()
        let item1 = PayHistoryItem(time: 1, payDate: Date(), status: .Paid, amount: 100000)
        let item2 = PayHistoryItem(time: 2, payDate: Date(), status: .Paid, amount: 200000)
        let item3 = PayHistoryItem(time: 3, payDate: Date(), status: .Paid, amount: 300000)
        let item4 = PayHistoryItem(time: 4, payDate: Date(), status: .NeedToPay, amount: 400000)
        let item5 = PayHistoryItem(time: 5, payDate: Date(), status: .NeedToPayNow, amount: 500000)
        let item6 = PayHistoryItem(time: 6, payDate: Date(), status: .NotYet, amount: 600000)
        let item7 = PayHistoryItem(time: 7, payDate: Date(), status: .NotYet, amount: 700000)
        let item8 = PayHistoryItem(time: 8, payDate: Date(), status: .NotYet, amount: 800000)
        let item9 = PayHistoryItem(time: 9, payDate: Date(), status: .NotYet, amount: 900000)
        let item10 = PayHistoryItem(time: 10, payDate: Date(), status: .NotYet, amount: 1000000)
        payHistoryData.append(item10)
        payHistoryData.append(item9)
        payHistoryData.append(item8)
        payHistoryData.append(item7)
        payHistoryData.append(item6)
        payHistoryData.append(item5)
        payHistoryData.append(item4)
        payHistoryData.append(item3)
        payHistoryData.append(item2)
        payHistoryData.append(item1)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payHistoryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = payHistoryData[indexPath.row]

        let cell = tableView.dequeueReusableNibCell(type: PayHistoryTableViewCell.self)
        if let cell = cell {
            cell.timeLb.text = "Đợt \(cellData.time)"
            cell.payDateLb.text = "\(cellData.payDate)"
            cell.amountLb.text = "\(cellData.amount)"
            cell.mainBackgroundView.layer.cornerRadius = 5
            cell.mainBackgroundView.layer.borderWidth = 1
            cell.imgBackgroundView.layer.cornerRadius = 15
            cell.imgBackgroundView.layer.borderWidth = 1

            // set theme cell
            switch cellData.status {
            case .NotYet:
                cell.statusDesLb.text = "Chưa đến lượt"
                cell.statusDesLb.textColor = UIColor.black
                cell.timeLb.textColor = UIColor.black
                cell.payDateLb.textColor = UIColor.black
                cell.amountLb.textColor = UIColor(hexString: "#4D6678")
                cell.mainBackgroundView.backgroundColor = UIColor.init(hexString: "#F1F5F8")
                cell.imgBackgroundView.backgroundColor = UIColor.init(hexString: "#F1F5F8")
                cell.statusImg.image = #imageLiteral(resourceName: "notYet")
                cell.imgBackgroundView.layer.borderColor = UIColor.init(hexString: "#F1F5F8").cgColor
                cell.mainBackgroundView.layer.borderColor = UIColor.init(hexString: "#F1F5F8").cgColor

            case .NeedToPay:
                cell.statusDesLb.text = "Cần thanh toán"
                cell.statusDesLb.textColor = UIColor.black
                cell.timeLb.textColor = UIColor.black
                cell.payDateLb.textColor = UIColor.black
                cell.amountLb.textColor = UIColor(hexString: "#3EAA5F")
                cell.mainBackgroundView.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor
                cell.mainBackgroundView.backgroundColor = UIColor.clear
                cell.imgBackgroundView.backgroundColor = UIColor.clear
                cell.imgBackgroundView.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor
                cell.mainBackgroundView.layer.borderColor = UIColor.init(hexString: "#3EAA5F").cgColor
                cell.statusImg.image = #imageLiteral(resourceName: "needToPay")
            case .NeedToPayNow:
                cell.statusDesLb.text = "Cần thanh toán ngay"
                cell.statusDesLb.textColor = UIColor.black
                cell.timeLb.textColor = UIColor.black
                cell.payDateLb.textColor = UIColor.black
                cell.amountLb.textColor = UIColor(hexString: "#DA3535")
                cell.mainBackgroundView.layer.borderColor = UIColor(hexString: "#DA3535").cgColor
                cell.mainBackgroundView.backgroundColor = UIColor.clear
                cell.imgBackgroundView.backgroundColor = UIColor.clear
                cell.imgBackgroundView.layer.borderColor = UIColor(hexString: "#DA3535").cgColor
                cell.statusImg.image = #imageLiteral(resourceName: "needToPayNow")
            default:
                // paid
                cell.statusDesLb.text = "Đã thanh toán"
                cell.statusDesLb.textColor = UIColor.white
                cell.timeLb.textColor = UIColor.white
                cell.payDateLb.textColor = UIColor.white
                cell.amountLb.textColor = UIColor.white
                cell.mainBackgroundView.backgroundColor = UIColor(hexString: "#94D4AB")
                cell.imgBackgroundView.backgroundColor = UIColor(hexString: "#94D4AB")
                cell.mainBackgroundView.layer.borderColor = UIColor(hexString: "#94D4AB").cgColor
                cell.imgBackgroundView.layer.borderColor = UIColor(hexString: "#94D4AB").cgColor
                cell.statusImg.image = #imageLiteral(resourceName: "paid")

            }

        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
