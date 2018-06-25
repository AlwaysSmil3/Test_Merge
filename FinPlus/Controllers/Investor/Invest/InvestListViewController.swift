//
//  InvestListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
public enum LoanReliability : Int {
    case positive1 = 1
    case positive2 = 2
    case positive3 = 3
    case positive4 = 4
    case nagative1 = 5
    case nagative2 = 6
    case nagative3 = 7
    case nagative4 = 8
    var title : String {
        switch self {
        case .positive1:
            return "A"
        case .positive2:
            return "B"
        case .positive3:
            return "C"
        case .positive4:
            return "D"
        case .nagative1:
            return "E"
        case .nagative2:
            return "F"
        case .nagative3:
                return "G"
        case .nagative4:
            return "H"
        }
    }
    var color : UIColor {
        switch self {
        case .positive1:
            return POSITIVE1_COLOR
        case .positive2:
            return POSITIVE2_COLOR
        case .positive3:
            return POSITIVE3_COLOR
        case .positive4:
            return POSITIVE4_COLOR
        case .nagative1:
            return NAGATIVE1_COLOR
        case .nagative2:
            return NAGATIVE2_COLOR
        case .nagative3:
            return NAGATIVE3_COLOR
        case .nagative4:
            return NAGATIVE4_COLOR
        }
    }
}

class InvestListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var allLoansArray : [DemoLoanModel] = [DemoLoanModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Đầu tư"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.tableView.register(UINib(nibName: "InvestTableViewCell", bundle: nil), forCellReuseIdentifier: "InvestTableViewCell")
        //self.getAllLoans()
        updateData()
        // Do any additional setup after loading the view.
    }

    func updateData() {
        // fixed data to test UI
        let loan1 = DemoLoanModel(reliability: .positive1, name: "Vay cho sinh viên", interestRate: 20, amount: 5000000, alreadyAmount: 0, dueMonth: 6)
        let loan2 = DemoLoanModel(reliability: .positive2, name: "Vay mua điện thoại", interestRate: 22, amount: 12000000, alreadyAmount: 75, dueMonth: 12)
        let loan3 = DemoLoanModel(reliability: .positive3, name: "Vay mua xe máy", interestRate: 22, amount: 12000000, alreadyAmount: 50, dueMonth: 12)
        let loan4 = DemoLoanModel(reliability: .positive4, name: "Vay mua điện thoại", interestRate: 25, amount: 12000000, alreadyAmount: 45, dueMonth: 6)
        let loan5 = DemoLoanModel(reliability: .nagative1, name: "Vay mua điện thoại", interestRate: 28, amount: 12000000, alreadyAmount: 30, dueMonth: 12)
        let loan6 = DemoLoanModel(reliability: .nagative2, name: "Vay mua điện thoại", interestRate: 30, amount: 12000000, alreadyAmount: 15, dueMonth: 6)
        let loan7 = DemoLoanModel(reliability: .nagative3, name: "Vay mua điện thoại", interestRate: 35, amount: 12000000, alreadyAmount: 90, dueMonth: 6)
        let loan8 = DemoLoanModel(reliability: .nagative4, name: "Vay mua điện thoại", interestRate: 40, amount: 12000000, alreadyAmount: 80, dueMonth: 12)
        self.allLoansArray.append(loan1)
        self.allLoansArray.append(loan2)
        self.allLoansArray.append(loan3)
        self.allLoansArray.append(loan4)
        self.allLoansArray.append(loan5)
        self.allLoansArray.append(loan6)
        self.allLoansArray.append(loan7)
        self.allLoansArray.append(loan8)
    }

    // Lấy danh sách tất cả các khoản vay
    private func getAllLoans() {
        APIClient.shared.getAllLoans()
            .done(on: DispatchQueue.main) { model in
                // print(model)
//                self.allLoansArray = model
                self.tableView.reloadData()
                // let _ : BrowwerActiveLoan = model
            }
            .catch { error in }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLoansArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = allLoansArray[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "InvestTableViewCell", for: indexPath) as? InvestTableViewCell {
            cell.cellData = cellData
            cell.updateCellView()
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellData = allLoansArray[indexPath.row]
        let investStoryBoard = UIStoryboard(name: "Invest", bundle: nil)
        let investDetailVC = investStoryBoard.instantiateViewController(withIdentifier: "InvestDetailViewController") as! InvestDetailViewController
        investDetailVC.investData = cellData
        self.navigationController?.pushViewController(investDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
