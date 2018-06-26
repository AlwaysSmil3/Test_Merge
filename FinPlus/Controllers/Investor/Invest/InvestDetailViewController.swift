//
//  InvestDetailViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var investData : DemoLoanModel! {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiết khoản vay"
        configTableView()
        updateData()
        // Do any additional setup after loading the view.
    }

    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        // register nib cell
        tableView.registerNibCell(type: InvestDetailFirstTableViewCell.self)
        tableView.registerNibCell(type: InvestDetailSecondTableViewCell.self)

    }

    @IBAction func regisBtnAction(_ sender: Any) {
        let regisVC = RegisInvestViewController(nibName: "RegisInvestViewController", bundle: nil)
        regisVC.investDetail = investData
        self.navigationController?.pushViewController(regisVC, animated: true)
    }
    func updateData() {

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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableNibCell(type: InvestDetailFirstTableViewCell.self) {
                cell.cellData = self.investData
                cell.updateCellView()
                return cell
            }

        } else {
            if let cell = tableView.dequeueReusableNibCell(type: InvestDetailSecondTableViewCell.self) {
                cell.cellData = self.investData
                cell.updateCellView()
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
            return 250
         } else {
            return 416
        }
    }

}
