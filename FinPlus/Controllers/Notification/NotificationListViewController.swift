//
//  NotificationListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var notificationList = [
        ["title" : "Bạn đã nhận được tiền từ nhà đầu tư", "content" : "Xin chào Minh, bạn đã nhận được 2.000.000đ từ nhà đầu tư.", "time" : "12/02/2018 10:00:00"],
        ["title" : "Yêu cầu xác nhận lãi suất", "content" : "Đơn vay của bạn đã được gửi đi thành công. Hệ thống sẽ tiến hành phê duyệt và đưa ra mức lãi suất, khoản thanh toán phù hợp nhất với bạn.", "time" : "12/02/2018 10:00:00"]]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông báo"
        configTableView()
        updateData()
        // Do any additional setup after loading the view.
    }

    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }

    func updateData() {
        // update get notification list
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = notificationList[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationTableViewCell {
            cell.containView.layer.cornerRadius = 8
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
            cell.timeLb.textColor = UIColor.darkGray
            cell.containView.layer.borderWidth = 1
            cell.titleLb.text = cellData["title"]
            cell.contentLb.text = cellData["content"]
            cell.timeLb.text = cellData["time"]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            cell.containView.layer.borderColor = MAIN_COLOR.cgColor
            cell.timeLb.textColor = MAIN_COLOR
        }

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
            cell.timeLb.textColor = UIColor.darkGray
        }
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
