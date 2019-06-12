//
//  InvestViewController.swift
//  FinPlus
//
//  Created by nghiendv on 06/07/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    let cellIdentifier = "cell"
    private var listInvest: NSMutableArray = [
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
        [
            "color": "#218043",
            "type" : "A",
            "des" : "Vay cho Sinh Vien",
            "rate" : "Lãi suất 20%/năm - 6 tháng",
            "sate" : "0%",
            "money" : "5000000",
            ],
    ]
    
    var mode = false
    var isInvestor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = NSLocalizedString("INVEST", comment: "")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let cellNib = UINib(nibName: "InvestFilterTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mode = UserDefaults.standard.bool(forKey: APP_MODE)
        self.isInvestor = UserDefaults.standard.bool(forKey: IS_INVESTOR)
        
        if (self.mode && self.isInvestor)
        {
            self.view.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            self.tableview.backgroundColor = DARK_MODE_BACKGROUND_COLOR
        }
        else
        {
            self.view.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            self.tableview.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_left(sender: UIButton) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "INVEST_FILTER"))!, animated: true)
    }
    
    @IBAction func navi_right(sender: UIButton) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "INVEST_FILTER"))!, animated: true)
    }
    
}

extension InvestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listInvest.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension InvestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listInvest[indexPath.section] as! NSDictionary
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? InvestFilterTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "InvestFilterTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? InvestFilterTableViewCell
        }
        
        cell?.typeView.layer.borderColor = UIColor(hexString: item["color"] as! String).cgColor
        cell?.typeLabel.textColor = UIColor(hexString: item["color"] as! String)
        
        cell?.typeLabel.text = item["type"] as? String
        cell?.desLabel.text = item["des"] as? String
        cell?.rateLabel.text = item["rate"] as? String
        cell?.statusLabel.text = item["sate"] as? String
        cell?.moneyLabel.text = item["money"] as? String
        
        if (self.mode && self.isInvestor)
        {
            cell?.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            cell?.typeLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            cell?.desLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            cell?.rateLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            cell?.statusLabel.textColor = DARK_MODE_SUB_TEXT_COLOR
            cell?.moneyLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            cell?.separateView.backgroundColor = DARK_MODE_SUB_TEXT_COLOR
        }
        else
        {
            cell?.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            cell?.typeLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            cell?.desLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            cell?.rateLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            cell?.statusLabel.textColor = LIGHT_MODE_SUB_TEXT_COLOR
            cell?.moneyLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            cell?.separateView.backgroundColor = LIGHT_MODE_SUB_TEXT_COLOR
        }
        
        cell?.separateView.isHidden = (indexPath.row + 1 == self.listInvest.count)
        
        return cell!
    }
    
}
