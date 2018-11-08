//
//  MonyBankListViewController.swift
//  Investor
//
//  Created by Vu Thanh Do on 7/19/18.
//  Copyright © 2018 nghiendv. All rights reserved.
//

import UIKit

class MonyBankListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var bankList = [MonyBankAccount]()
    var bankSelected : MonyBankAccount?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var titleLb: UILabel!
    
    var amount: Double = 0
    var isTotalPayed: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.title = "Chuyển khoản/tiền mặt"
        let leftBtnBar = UIButton(type: .custom)
        leftBtnBar.frame = CGRect(x: 0, y: 0, width: 44, height: 36)
        leftBtnBar.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        leftBtnBar.imageEdgeInsets = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
        //        leftBtnBar.set(image: #imageLiteral(resourceName: "ic_back"), state: .normal)
        leftBtnBar.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        leftBtnBar.transform = CGAffineTransform(translationX: -10, y: 0)
        
        // add the button to a container, otherwise the transform will be ignored
        let suggestButtonContainer = UIView(frame: leftBtnBar.frame)
        suggestButtonContainer.addSubview(leftBtnBar)
        let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
        
        // add button shift to the side
        navigationItem.leftBarButtonItem = suggestButtonItem
        if let navi = self.navigationController {
            navi.navigationBar.barTintColor = UIColor.white
            navi.navigationBar.isTranslucent = false
            navi.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navi.navigationBar.shadowImage = UIImage()
        }
        
        
        // add left button
        self.tableView.registerNibCell(type: MonyBankTableViewCell.self)
        self.createBankList()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backAction() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createBankList() {
        self.bankList.removeAll()
//        let vietcombank = MonyBankAccount(bankType: 1, bankName:"Vietcombank" , bankNameDetail: "CN Hà Nội", bankNumber: "0021000444319", bankUsername: "Công ty Cổ phần Finplus", amount: self.amount, content: "\(DataManager.shared.currentAccount) chuyển tiền")
        
        //var content = "\(DataManager.shared.currentAccount) chuyển tiền"
        var content = "THANHTOAN \(DataManager.shared.currentAccount)"
        if let isTotal = self.isTotalPayed, isTotal {
            content = "TATTOAN \(DataManager.shared.currentAccount)"
        }
        
        let vietinbank = MonyBankAccount(bankType: 2, bankName:"Vietinbank" , bankNameDetail: "Hoàng Mai", bankNumber: "115002671451", bankUsername: "Công ty Cổ phần Finplus", amount: self.amount, content: content)
//        let agribank = MonyBankAccount(bankType: 4, bankName:"Agribank" , bankNameDetail: "Nam Hà Nội", bankNumber: "1460201035289", bankUsername: "Công ty Cổ phần Finplus", amount: self.amount, content: "\(DataManager.shared.currentAccount) chuyển tiền")
        
        //self.bankList.append(agribank)
        self.bankList.append(vietinbank)
        //self.bankList.append(vietcombank)
        
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 203
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.bankList[indexPath.row]
        let cell = tableView.dequeueReusableNibCell(type: MonyBankTableViewCell.self)
        if let cell = cell {
            cell.bankData = cellData
            if let bankSelected = self.bankSelected {
                if cellData.bankNumber == bankSelected.bankNumber {
                    cell.isSelected = true
                } else {
                    cell.isSelected = false
                }
            }
            cell.updateCellView()
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bankSelected = self.bankList[indexPath.row]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        //        let successVC = BudgetRewardSuccessViewController(nibName: "BudgetRewardSuccessViewController", bundle: nil)
        ////        self.present(successVC, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(successVC, animated: true)
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
