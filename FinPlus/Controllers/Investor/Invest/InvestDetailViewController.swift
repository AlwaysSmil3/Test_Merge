//
//  InvestDetailViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var loanCategories : [LoanCategories] = [LoanCategories]()
    var investData : BrowwerActiveLoan! {
        didSet {
            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
    }
    var mode = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiết khoản vay"
        configTableView()
        updateData()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.mode = UserDefaults.standard.bool(forKey: APP_MODE)
        setupMode()
    }

    func setupMode() {
        if (self.mode)
        {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = DARK_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = DARK_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: DARK_BODY_TEXT_COLOR]
            self.view.backgroundColor = DARK_BACKGROUND_COLOR
            self.tableView.backgroundColor = DARK_FOREGROUND_COLOR
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = LIGHT_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = LIGHT_BODY_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: LIGHT_BODY_TEXT_COLOR]
//            self.view.backgroundColor = LIGHT_BACKGROUND_COLOR
//            self.tableView.backgroundColor = LIGHT_BACKGROUND_COLOR
            self.view.backgroundColor = UIColor.white
            self.tableView.backgroundColor = UIColor.white
        }
        tableView.reloadData()
    }

    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        // register nib cell
        tableView.registerNibCell(type: InvestDetailFirstTableViewCell.self)
        tableView.registerNibCell(type: InvestDetailSecondTableViewCell.self)

    }

    @IBAction func regisBtnAction(_ sender: Any) {
        let regisVC = RegisInvestViewController(nibName: "RegisInvestViewController", bundle: nil)
        regisVC.investDetail = investData
        self.navigationController?.pushViewController(regisVC, animated: true)
    }
    func updateData() {

        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableNibCell(type: InvestDetailFirstTableViewCell.self) {
                cell.cellData = self.investData
                print(self.loanCategories.count)
                cell.loanCategories = self.loanCategories
                cell.updateCellView()
                return cell
            }

        } else {
            if let cell = tableView.dequeueReusableNibCell(type: InvestDetailSecondTableViewCell.self) {
                cell.cellData = self.investData
                cell.loanCategories = self.loanCategories
                cell.updateCellView()
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
            return 250
         } else {
            return 416
        }
    }

}
