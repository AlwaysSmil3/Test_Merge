//
//  InvestDetailViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var investData : BrowwerActiveLoan!
    enum Cell {
        case investDetailCell
        case debtScheduleCell

        var cellType: UITableViewCell.Type {
            switch self {
            case .investDetailCell:
                return InvestDetailTableViewCell.self
            default:
                return DebtScheduleTableViewCell.self
            }
        }
    }

    class CellData {
        var cellType : Cell!
        var cellData : [String: String]!
        var cellHeight : CGFloat = 44
        init(cellType: Cell, cellData: [String: String], cellHeight: CGFloat) {
            self.cellType = cellType
            self.cellData = cellData
            self.cellHeight = cellHeight
        }
    }

    class SectionData {
        var cells : [CellData] = []
        var footerHeight : CGFloat = 0
        var headerTitle : String!
        init(cells: [CellData], footerHeight: CGFloat, headerTitle: String) {
            self.cells = cells
            self.footerHeight = footerHeight
            self.headerTitle = headerTitle
        }
        init() {

        }
    }

    var sections : [SectionData] = []

    var testData = ["invest_detail" :
        [["contract_code" : "MHD010"], ["brower" : "Nguyễn Văn Vay"], ["range_time" : "15/2/2018 - 15/8/2018"], ["amount" : "2.000.000 VND"], ["return_amount" : "0 VND"], ["return_interest" : "0 VND"]],
         "debt_schedule" : [
            ["date" : "16/5/2018", "amount" : "100.000", "content" : "1 Tiền lãi kỳ 1", "note" : "Không thu hồi được nợ, Quá hạn xx ngày"],
            ["date" : "16/5/2018", "amount" : "100.000", "content" : "2 Tiền lãi kỳ 2", "note" : "Không thu hồi được nợ, Quá hạn xx ngày"],
            ["date" : "16/5/2018", "amount" : "100.000", "content" : "3 Tiền lãi kỳ 3", "note" : "Không thu hồi được nợ, Quá hạn xx ngày"],
            ["date" : "16/5/2018", "amount" : "100.000", "content" : "4 Tiền lãi kỳ 4", "note" : "Không thu hồi được nợ, Quá hạn xx ngày"]]
        ]

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
        tableView.registerNibCell(type: InvestDetailTableViewCell.self)
        tableView.registerNibCell(type: DebtScheduleTableViewCell.self)

    }

    func updateData() {
        self.sections.removeAll()
        let investDetailSection = SectionData()
        investDetailSection.footerHeight = 30
        investDetailSection.headerTitle = "Chi tiết khoản đầu tư"
        let investDetail = testData["invest_detail"] as! [[String: String]]
        for investInfo in investDetail {
            print(investInfo)
            let detailCell = CellData(cellType: .investDetailCell, cellData: investInfo, cellHeight: 50)
            investDetailSection.cells.append(detailCell)

        }
        let debtSection = SectionData()
        debtSection.headerTitle = "Lịch thu nợ"
        let debtSchedult = testData["debt_schedule"] as! [[String : String]]
        for debtInfo in debtSchedult {
            print(debtInfo)
            let debtCell = CellData(cellType: .debtScheduleCell, cellData: debtInfo, cellHeight: 50)
            debtSection.cells.append(debtCell)
        }
        self.sections.append(investDetailSection)
        self.sections.append(debtSection)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let cell = cell as? InvestDetailTableViewCell {
            for (key, value) in cellData.cellData {
                cell.valueLb.text = value
                cell.titleLb.text = key
            }
        } else if let cell = cell as? DebtScheduleTableViewCell {
            cell.dateLb.text = cellData.cellData["date"]!
            cell.amountLb.text = cellData.cellData["amount"]!
            cell.contentLb.text = cellData.cellData["content"]!
            cell.noteLb.text = cellData.cellData["note"]!
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = sections[indexPath.section].cells[indexPath.row]
        return cellData.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
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
