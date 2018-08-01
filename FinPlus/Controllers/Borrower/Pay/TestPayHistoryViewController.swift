//
//  TestPayHistoryViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

public enum PayHistoryItemStatus: Int {
    case NotYet = 0
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
    var payHistoryData = [CollectionPay]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNibCell(type: PayHistoryTableViewCell.self)
        //self.updateData()
        // Do any additional setup after loading the view.
        
        self.getCollections()
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

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    private func getCollections() {
        APIClient.shared.getCollections()
            .done(on: DispatchQueue.main) { model in
                
                self.payHistoryData = model
                
            }
            .catch { error in }
    }
    
    
    
    

    
    //MARK: UITableViewDelegate, UITableViewDataSource
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
            cell.displayCell(cellData: cellData, index: indexPath.row + 1)
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
