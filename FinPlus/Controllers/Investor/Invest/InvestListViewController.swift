//
//  InvestListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByBtn: UIButton!
    @IBOutlet weak var filterByBtn: UIButton!
    @IBOutlet weak var topSegmentControl: UISegmentedControl!
    var allLoansArray : [BrowwerActiveLoan] = [BrowwerActiveLoan]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.tableView.register(UINib(nibName: "InvestTableViewCell", bundle: nil), forCellReuseIdentifier: "InvestTableViewCell")
        self.getAllLoans()
        // Do any additional setup after loading the view.
    }

    // Lấy danh sách tất cả các khoản vay
    private func getAllLoans() {
        APIClient.shared.getAllLoans()
            .done(on: DispatchQueue.main) { model in
                print(model)
                self.allLoansArray = model
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
        let cellData : BrowwerActiveLoan = allLoansArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InvestTableViewCell", for: indexPath) as? InvestTableViewCell {
            cell.investImg.image = #imageLiteral(resourceName: "ic_tb_brow4")
            cell.nameLb.text = "Gói vay bà bầu"
            cell.amountLb.text = "10.000.000 VND"
            cell.exporeTimeLb.text = "3 tháng"
            cell.alreadyAmountLb.text = "Đã huy động: 80%"
            
//            cell.nameLb.text = "\(cellData.loanId!)"
//            cell.amountLb.text = "\(cellData.amount!)"
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData : BrowwerActiveLoan = allLoansArray[indexPath.row]
        let investStoryBoard = UIStoryboard(name: "Invest", bundle: nil)
        let investDetailVC = investStoryBoard.instantiateViewController(withIdentifier: "InvestDetailViewController") as! InvestDetailViewController
        investDetailVC.investData = cellData
        self.navigationController?.pushViewController(investDetailVC, animated: true)
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
