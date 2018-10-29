//
//  CalPayViewController.swift
//  FinPlus
//
//  Created by nghiendv on 11/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import Foundation
import SpreadsheetView

let SHORT_TYPE:Float = 1000

class CalPayViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyTextField: HoshiTextField!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthTextField: HoshiTextField!
    @IBOutlet weak var rateLabel: UILabel!
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
    var data = [CalculatorPay]()
    
    var currentDate: Date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ishidden = self.navigationController?.isNavigationBarHidden, ishidden {
            self.navigationController?.isNavigationBarHidden = false
        }

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("CALCULATE_PAY", comment: "")
        
        self.calBtn.layer.cornerRadius = 4
        
        // Setting DateFormatter
        dateFormatter.dateFormat = "dd/MM/YYYY"
//        dateTextField.text = dateFormatter.string(from: currentDate)
        
        // Setup Font
        moneyLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        moneyTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        moneyTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        monthLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        monthTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        monthTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        rateLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        rateTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        rateTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        dateTextField.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        dateTextField.placeholderLabel.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_SMALL)
        
        calBtn.layer.cornerRadius = 4
        calBtn.layer.masksToBounds = true
        calBtn.isEnabled = false
        calBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        calBtn.setBackgroundColor(color: UIColor(hexString: "#B8C9D3"), forState: .disabled)
        calBtn.setBackgroundColor(color: UIColor(hexString: "#00A651"), forState: .normal)
        
        // TableView Custom
        spreadsheetView.isHidden = true
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        spreadsheetView.backgroundColor = LIGHT_MODE_BORDER_COLOR
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
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showDateDialog() {
        DatePickerDialog().show("Ngày giải ngân", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: Date(), maximumDate: nil, datePickerMode: UIDatePickerMode.date) { (date) in
            if let date = date {
                self.currentDate = date
                self.dateFormatter.dateFormat = "dd/MM/YYYY"
                self.dateTextField.text = self.dateFormatter.string(from: self.currentDate)
                
                self.validateData()
            }
        }
    }
    
    func convertNumberFormat(text: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        
        let noneText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if(noneText.count > 0) {
            let number = Int(noneText) ?? 0
            let formattedString = formatter.string(from: NSNumber(value: number > 0 ? number : 0))
            return formattedString ?? ""
        }
        else
        {
            return ""
        }
    }
    
    @IBAction func calculate(sender: UIButton) {

        self.view.endEditing(true)
        spreadsheetView.isHidden = false
        
        self.months.removeAllObjects()
        self.data = []
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if (self.moneyTextField.text?.count ?? 0) < 4 {
            showAlertView(title: "Lỗi", message: "Số tiền không được nhỏ hơn 1000000", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }
        else if ((self.monthTextField.text?.count ?? 0) < 1 || Int(self.monthTextField.text ?? "") ?? 0 < 1) {
            showAlertView(title: "Lỗi", message: "Thời hạn vay phải lớn hơn 1 tháng", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }
        else if ((self.rateTextField.text?.count ?? 0) < 1 ||  Float(self.rateTextField.text ?? "") ?? 0 <= 0) {
            showAlertView(title: "Lỗi", message: "Lãi suất phải lớn hơn 0", okTitle: "Đồng ý", cancelTitle: nil)
            return
        }

        let money = Int(self.moneyTextField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")) ?? 0
        let monthCount = Int(self.monthTextField.text ?? "0") ?? 0
        let rate = Int(self.rateTextField.text ?? "0") ?? 0
        let date = self.dateFormatter.date(from: self.dateTextField.text ?? "")
        let beginData = date?.toString(.custom(kDisplayFormatCalculatorPay)) ?? ""
        
        APIClient.shared.calculatorPay(amount: money, term: monthCount*30, intRate: rate, disbursalDate: beginData)
        .done(on: DispatchQueue.main) { [weak self]model in
            self?.data = model
            self?.spreadsheetView.reloadData()
        }
        .catch { error in
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    func validateData() {
        if ((self.moneyTextField.text?.count ?? 0) > 0 && (self.monthTextField.text?.count ?? 0) > 0 && (self.rateTextField.text?.count ?? 0) > 0 && ((self.dateTextField.text?.count ?? 0) > 0)) {
            self.calBtn.isEnabled = true
        }
        else
        {
            self.calBtn.isEnabled = false
        }
    }
    
    // MARK: UITextFieldDelegate
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        if (textField == self.moneyTextField)
        {
            textField.text = convertNumberFormat(text: textField.text!)
        }
        
        self.validateData()
        
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
        return data.count > 0 ? (data.count + 1) : 0
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
    
//    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
//        return 1
//    }
//
//    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
//        return 1
//    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (0...(titles.count - 1), 0) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell
            cell.label.text = titles[indexPath.column]
            cell.color = UIColor(hexString: "#F1F5F8")
            return cell
            
        } else {
            
            let item = self.data[indexPath.row - 1]
            
            if (indexPath.column == 0) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthCell.self), for: indexPath) as! MonthCell
                self.dateFormatter.dateFormat = kDisplayFormatCalculatorPay
                let date = self.dateFormatter.date(from: item.dueDatetime ?? "")
                cell.label.text = "\(date?.toString(.custom("dd/MM/YY")) ?? "")"
                return cell
            } else if (indexPath.column == 1) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MoneyCell.self), for: indexPath) as! MoneyCell
                cell.label.text = convertNumberFormat(text: "\(item.principal!/1000)") + "K"
                return cell
            } else if (indexPath.column == 2) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MoneyCell.self), for: indexPath) as! MoneyCell
                cell.label.text = convertNumberFormat(text: "\(item.interest!/1000)") + "K"
                return cell
            } else if (indexPath.column == 3) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: PayCell.self), for: indexPath) as! PayCell
                cell.label.text = convertNumberFormat(text: "\((item.interest! + item.principal!)/1000)") + "K"
                return cell
            }
        }
        return nil
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }

}
