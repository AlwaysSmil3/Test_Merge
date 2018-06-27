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
    var amount: Float
    init(time: Int, payDate: Date, status: PayHistoryItemStatus, amount: Float) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            cell.displayCell(cellData: cellData)
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
