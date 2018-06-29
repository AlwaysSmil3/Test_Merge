//
//  InvestContractViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/26/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestContractViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hợp đồng vay"
        self.tableView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
