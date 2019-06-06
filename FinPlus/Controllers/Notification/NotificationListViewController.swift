//
//  NotificationListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import DateToolsSwift

class NotificationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentAfter: Int = 0
    
    var notificationList: [NotificationModel] = []
    
    let countItemsOnAPage = 20
    
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var noNotificationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông báo"
        configTableView()
        updateData()
        
        self.initRefresher()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
        
        self.getListNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HiddenNotificationIdentifier), object: nil)
        userDefault.set(false, forKey: Notification_Have_New)
    }
    
    private func initRefresher() {
        self.refresher = UIRefreshControl()
        self.tableView.addSubview(self.refresher)
        
        //self.refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        //self.refresher.tintColor = MAIN_COLOR
        self.refresher.addTarget(self, action: #selector(completeRefresh), for: .valueChanged)
    }
    
    @objc func completeRefresh() {
        self.reloadData()
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
    
    private func reloadData() {
        self.currentAfter = 0
        self.getListNotification()
    }
    
    private func getListNotification() {
        APIClient.shared.getListNotifications(after: self.currentAfter, limit: self.countItemsOnAPage)
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.refresher.endRefreshing()
                
                if model.count > 0{
                    if self?.currentAfter == 0 && (self?.notificationList.count ?? 0) > 0 {
                        self?.notificationList.removeAll()
                    }
                    
                    self?.noNotificationView.isHidden = true
                    self?.notificationList.append(contentsOf: model)
                    self?.tableView.reloadData()
                    self?.currentAfter = self?.notificationList.last?.id ?? 0
                } else {
                    self?.noNotificationView.isHidden = false
                }
                
            }
            .catch { error in
                self.refresher.endRefreshing()
                self.noNotificationView.isHidden = false
        }
        
        
    }
    
    private func updateNoti(index: IndexPath) {
        
        var data = self.notificationList[index.row]
        
        APIClient.shared.updateNotification(notiID: data.id!)
            .done(on: DispatchQueue.global()) { [weak self]model in
                data.status = false
                self?.notificationList[index.row] = data
            }
            .catch { error in}
    }
    
    
    /// Format Date
    ///
    /// - Parameter date: <#date description#>
    /// - Returns: <#return value description#>
    private func formatDateDisplay(date: Date) -> String {
        let currentDate = Date()
        
        if currentDate.hours(from: date) < 24 {
            let hours = currentDate.hours(from: date)
            
            if hours == 0 {
                let minute = currentDate.minutes(from: date)
                return "\(minute) phút trước"
            }
            
            return "\(hours) giờ trước"
        }
        
        
        if currentDate.days(from: date) < 7 {
            return "\(currentDate.days(from: date)) ngày trước"
        }
        
        
        return date.toString(.custom("HH:mm dd/MM/yyyy"))
    }
    
    //MARK:
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
            
            if (cellData.status)!
            {
                cell.timeLb.textColor = MAIN_COLOR
                cell.containView.layer.borderColor = MAIN_COLOR.cgColor
                cell.titleLb.textColor = UIColor(hexString: "#08121E")
                cell.contentLb.textColor = UIColor(hexString: "#08121E")
            }
            else
            {
                cell.containView.layer.borderColor = UIColor.lightGray.cgColor
                cell.titleLb.textColor = UIColor(hexString: "#4D6678")
                cell.contentLb.textColor = UIColor(hexString: "#4D6678")
                cell.timeLb.textColor = UIColor(hexString: "#8EA3AF")
            }
            
            cell.containView.layer.borderWidth = 1
            cell.titleLb.text = cellData.title!
            cell.contentLb.text = cellData.messages!
            
            let dateString = cellData.createdDate!
            
            let date = Date.init(fromString: dateString, format: DateFormat.custom(DATE_FORMATTER_WITH_SERVER))
            cell.timeLb.text = self.formatDateDisplay(date: date)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
            cell.titleLb.textColor = UIColor(hexString: "#4D6678")
            cell.contentLb.textColor = UIColor(hexString: "#4D6678")
            cell.timeLb.textColor = UIColor(hexString: "#8EA3AF")
        }
        
        let data = self.notificationList[indexPath.row]
        if let status = data.status, status == true {
            self.updateNoti(index: indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
            cell.timeLb.textColor = UIColor(hexString: "#8EA3AF")
            cell.titleLb.textColor = UIColor(hexString: "#4D6678")
            cell.contentLb.textColor = UIColor(hexString: "#4D6678")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.notificationList.count - 1 {
            
            if self.notificationList.count % countItemsOnAPage == 0 {
                self.getListNotification()
            }
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
