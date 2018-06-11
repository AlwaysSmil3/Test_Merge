//
//  LoanDetailViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class LoanDetailViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var detailLoan: NSDictionary!
    let cellIdentifier = "cell"
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = NSLocalizedString("DETAIL_LOAN", comment: "")
        
        let cellNib = UINib(nibName: "DoubleTextTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.tableView.tableFooterView = UIView()
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        self.borderView.layer.cornerRadius = 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoanDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailLoan.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension LoanDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = detailLoan.allKeys[indexPath.row] as! String
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DoubleTextTableViewCell
        }
        
        cell?.nameLabel.text = NSLocalizedString(key, comment: "")
        cell?.desLabel.text = detailLoan[key] as? String
        
        return cell!
    }
    
}
