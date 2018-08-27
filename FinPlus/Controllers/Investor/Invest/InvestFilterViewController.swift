//
//  InvestFilterViewController.swift
//  FinPlus
//
//  Created by nghiendv on 06/07/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum FilterType {
    case FilterSlide
    case FilterSelect
}

class InvestFilterViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var leftBarBtn: UIBarButtonItem!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    let selectCellIdentifier = "selectCell"
    let slideCellIdentifier = "slideCell"
    
    private var listFilter: NSMutableArray = [
        [
            "title": "Lọc các đơn vay theo",
            "sub_array": [
                [
                    "type": FilterType.FilterSelect,
                    "title" : "Mục đích vay",
                    "defaultValue": "Tất cả",
                    "value" : [
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ],
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ],
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ]
                    ]
                ],
                [
                    "type": FilterType.FilterSlide,
                    "title" : "Kỳ vay",
                    "minValue": "1",
                    "maxValue": "15",
                ]
            ],
        ],
        [
            "title": "Sắp xếp kết quả theo",
            "sub_array": [
                [
                    "type": FilterType.FilterSelect,
                    "title" : "Mục đích vay",
                    "defaultValue": "Tất cả",
                    "value" : [
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ],
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ],
                        [
                            "id": 1,
                            "title": "Vay cho sinh viên",
                            "value": "1-5triệu"
                        ]
                    ]
                ],
            ]
            ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = NSLocalizedString("LOAN_MANAGER", comment: "")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let selectCellNib = UINib(nibName: "SelectTableViewCell", bundle: nil)
        self.tableview.register(selectCellNib, forCellReuseIdentifier: selectCellIdentifier)
        
        let slideCellNib = UINib(nibName: "SlideTableViewCell", bundle: nil)
        self.tableview.register(slideCellNib, forCellReuseIdentifier: slideCellIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    @IBAction func navi_left(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navi_right(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InvestFilterViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listFilter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionItem = listFilter[section] as! NSDictionary
        return (sectionItem["sub_array"] as! NSArray).count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionItem = listFilter[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! NSDictionary
        
        if (item["type"] as! FilterType == .FilterSelect)
        {
            
            var listPopupData: [LoanBuilderData] = []
            let listValue = item["value"] as! NSArray
            
            for i in listValue {
                let cate = i as! NSDictionary
                var loan = LoanBuilderData(object: NSObject())
                loan.id = cate["id"] as? Int16
                loan.title = cate["title"] as? String
                listPopupData.append(loan)
            }
                
            let popup = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "LoanTypePopupVC") as! LoanTypePopupVC
            popup.setDataSource(data: listPopupData, type: .Categories)
            popup.titleString = "Mục đích vay"
            popup.delegate = self
            
            popup.show()
        }
    }
    
}

extension InvestFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionItem = listFilter[section] as! NSDictionary
        return NSLocalizedString((sectionItem["title"] as? String)!, comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = listFilter[indexPath.section] as! NSDictionary
        let item = (sectionItem["sub_array"] as! NSArray)[indexPath.row] as! NSDictionary
        
        if (item["type"] as! FilterType == .FilterSlide)
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: slideCellIdentifier) as? SlideTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "SlideTableViewCell", bundle: nil), forCellReuseIdentifier: slideCellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: slideCellIdentifier) as? SlideTableViewCell
            }
            
            cell?.topTitleLabel.text = item["title"] as? String
            cell?.topValueLabel.text = "\(item["minValue"] as! String) - \(item["maxValue"] as! String) triệu"
            cell?.bottomTitleLabel.text = "\(item["minValue"] as! String) triệu"
            cell?.bottomValueLabel.text = "\(item["maxValue"] as! String) triệu"
            
            return cell!
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: selectCellIdentifier) as? SelectTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "SelectTableViewCell", bundle: nil), forCellReuseIdentifier: selectCellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: selectCellIdentifier) as? SelectTableViewCell
            }
            
            cell?.leftLabel.text = item["title"] as? String
            let defaultValue = item["defaultValue"] as? String
            
            cell?.rightLabel.text = item["defaultValue"] as? String
            cell?.rightLabel.isHidden = (defaultValue?.count)! < 1
            
            return cell!
        }
        
    }
    
}

extension InvestFilterViewController: DataSelectedFromPopupProtocol {
    func dataSelected(data: LoanBuilderData) {
        
    }
}

