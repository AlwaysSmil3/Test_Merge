//
//  CalPayViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import Foundation
import TextFieldEffects
import SpreadsheetView

class CalPayViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var moneyTextField: HoshiTextField!
    @IBOutlet weak var monthTextField: HoshiTextField!
    @IBOutlet weak var rateTextField: HoshiTextField!
    @IBOutlet weak var dateTextField: HoshiTextField!
    @IBOutlet weak var calBtn: UIButton!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
//    let data = [
//        ["123.000", "123.000", "123.000", "123.000"],
//        ["123", "123", "123", "123", "123"],
//        ["123123", "123123", "123123","123123"],
//    ]
    
    let titles = ["Kỳ trả nợ", "Tiền gốc", "Tiền lãi", "Tiền gốc + lãi"]
    var months: NSMutableArray = []
    var data: NSMutableArray = []
    
    var currentDate: Date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CALCULATE_PAY", comment: "")
        
        self.calBtn.layer.cornerRadius = 4
        
        // Setting DateFormatter
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateTextField.text = dateFormatter.string(from: currentDate)
        
        // TableView Custom
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
    
    @IBAction func showDateDialog() {
        DatePickerDialog().show("Ngày giải ngân", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: Date(), maximumDate: nil, datePickerMode: UIDatePickerMode.date) { (date) in
            if let date = date {
                self.currentDate = date
                self.dateTextField.text = self.dateFormatter.string(from: self.currentDate)
            }
        }
    }
    
    @IBAction func calculate(sender: UIButton) {

        self.view.endEditing(true)
        self.months.removeAllObjects()
        self.data.removeAllObjects()
        
        if (self.moneyTextField.text?.count)! < 4 {
            showAlertView(title: "Lỗi", message: "Số tiền không được nhỏ hơn 1000000", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }
        else if ((self.monthTextField.text?.count)! < 1 || Int(self.monthTextField.text!)! < 1) {
            showAlertView(title: "Lỗi", message: "Thời hạn vay phải lớn hơn 1 tháng", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }
        else if ((self.rateTextField.text?.count)! < 1 ||  Float(self.rateTextField.text!)! <= 0) {
            showAlertView(title: "Lỗi", message: "Lãi suất phải lớn hơn 0", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }

        let money = Float(self.moneyTextField.text!)!*1000
        let monthCount = Int(self.monthTextField.text!)
        let rate = Float(self.rateTextField.text!)!*money/Float(monthCount!*100)
        let monthPay = money/Float(monthCount!)
        
        var dateComponent = DateComponents()
        for i in 1...(monthCount!)
        {
            dateComponent.month = i
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            months.add(dateFormatter.string(from: futureDate!))
        }
        data.addObjects(from:[monthPay.description, rate.description, (monthPay + rate).description])
        
        self.spreadsheetView.reloadData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.dateTextField {
            return false
        }
        
        return true
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
            cell.label.text = months[indexPath.row - 1] as? String
            return cell
        } else if case (1...(titles.count - 2), 1...(months.count)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MoneyCell.self), for: indexPath) as! MoneyCell
            cell.label.text = data[indexPath.column - 1] as? String
            return cell
        } else if case ((titles.count - 1), 1...(months.count)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: PayCell.self), for: indexPath) as! PayCell
            cell.label.text = data[indexPath.column - 1] as? String
            return cell
        }
        return nil
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }

}
