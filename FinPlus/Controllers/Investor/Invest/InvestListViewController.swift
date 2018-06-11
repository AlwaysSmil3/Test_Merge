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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "InvestTableViewCell", bundle: nil), forCellReuseIdentifier: "InvestTableViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InvestTableViewCell", for: indexPath) as? InvestTableViewCell {
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let investStoryBoard = UIStoryboard(name: "Invest", bundle: nil)
        let investDetailVC = investStoryBoard.instantiateViewController(withIdentifier: "InvestDetailViewController")
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
