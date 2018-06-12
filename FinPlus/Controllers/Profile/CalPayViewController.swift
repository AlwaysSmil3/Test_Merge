//
//  CalPayViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import TextFieldEffects
import SpreadsheetView

class CalPayViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    @IBOutlet weak var moneyTextField: HoshiTextField!
    @IBOutlet weak var monthTextField: HoshiTextField!
    @IBOutlet weak var rateTextField: HoshiTextField!
    @IBOutlet weak var dateTextField: HoshiTextField!
    @IBOutlet weak var calBtn: UIButton!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
//    let months: NSMutableArray = []
//    let data = [
//        ["123.000", "123.000", "123.000", "123.000"],
//        ["123", "123", "123", "123", "123"],
//        ["123123", "123123", "123123","123123"],
//    ]
    
    let titles = ["Kỳ trả nợ", "Tiền gốc", "Tiền lãi", "Tiền gốc + lãi"]
    var months: NSMutableArray = []
    var data: NSMutableArray = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CALCULATE_PAY", comment: "")
        
        self.calBtn.layer.cornerRadius = 4
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        spreadsheetView.backgroundColor = UIColor(hexString: "#E3EBF0")
        spreadsheetView.intercellSpacing = CGSize(width: 0, height: 1)
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.register(TitleCell.self, forCellWithReuseIdentifier: String(describing: TitleCell.self))
        spreadsheetView.register(MonthCell.self, forCellWithReuseIdentifier: String(describing: MonthCell.self))
        spreadsheetView.register(MoneyCell.self, forCellWithReuseIdentifier: String(describing: MoneyCell.self))
        spreadsheetView.register(PayCell.self, forCellWithReuseIdentifier: String(describing: PayCell.self))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showDateDialog(sender: UIButton) {
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in
    
            if let date = date {
                
            }
        }
    }
    
    @IBAction func calculate(sender: UIButton) {
        let cal = NSCalendar.current
        let date = cal.date(byAdding: .month, value: 1, to: Date())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return titles.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + months.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return spreadsheetView.frame.size.width/4
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 30
        } else {
            return 44
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (0...(titles.count - 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell
            cell.label.text = titles[indexPath.column]
            cell.color = UIColor(hexString: "#F1F5F8")
            return cell
        } else if case (0, 1...(months.count)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthCell.self), for: indexPath) as! MonthCell
            cell.label.text = months[indexPath.column]
            return cell
        } else if case (1...(titles.count - 2), 1...(months.count)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MoneyCell.self), for: indexPath) as! MoneyCell
            cell.label.text = data[indexPath.column - 1][indexPath.row - 1]
            return cell
        } else if case ((titles.count - 1), 1...(months.count)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: PayCell.self), for: indexPath) as! PayCell
            cell.label.text = data[indexPath.column - 1][indexPath.row - 1]
            return cell
        }
        return nil
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }

}
