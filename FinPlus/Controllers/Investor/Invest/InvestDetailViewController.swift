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
            let cell = tableView.dequeueReusableNibCell(type: InvestDetailFirstTableViewCell.self) as! InvestDetailFirstTableViewCell
            cell.cellData = self.investData
            cell.updateCellView()
            return cell
        } else {
            let cell = tableView.dequeueReusableNibCell(type: InvestDetailSecondTableViewCell.self) as! InvestDetailSecondTableViewCell
            cell.cellData = self.investData
            cell.updateCellView()
            return cell 
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
            return 250
         } else {
            return 416
        }
    }

}
