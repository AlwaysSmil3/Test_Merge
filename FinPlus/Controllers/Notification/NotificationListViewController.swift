//
//  NotificationListViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/12/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentIndex: Int = 1
    
    var notificationList: [NotificationModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet var noNotificationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông báo"
        configTableView()
        updateData()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
        
        self.getListNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

    private func getListNotification() {
        APIClient.shared.getListNotifications(pageIndex: self.currentIndex)
            .done(on: DispatchQueue.main) { model in
                if model.count > 0{
                    self.noNotificationView.isHidden = true
                    self.notificationList.append(contentsOf: model)
                } else {
                    self.noNotificationView.isHidden = false
                }
            }
            .catch { error in
                self.noNotificationView.isHidden = false
            }
        
        
    }
    
    private func updateNoti(index: Int32) {
        APIClient.shared.updateNotification(notiID: index)
            .done(on: DispatchQueue.global()) { model in }
            .catch { error in}
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
            cell.containView.layer.borderColor = UIColor.lightGray.cgColor
            cell.timeLb.textColor = UIColor.darkGray
            cell.containView.layer.borderWidth = 1
            cell.titleLb.text = cellData.title!
            cell.contentLb.text = cellData.messages!
            let date = Date.init(fromString: cellData.createdDate!, format: DateFormat.custom(kDOBFormatWithMilisecond))
            cell.timeLb.text = date.toString(.custom("HH:mm dd/MM/yyyy"))
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            cell.containView.layer.borderColor = MAIN_COLOR.cgColor
            cell.timeLb.textColor = MAIN_COLOR
            cell.titleLb.textColor = UIColor(hexString: "#08121E")
            cell.contentLb.textColor = UIColor(hexString: "#08121E")
        }
        
        let data = self.notificationList[indexPath.row]
        guard let status = data.status, status else {
            self.updateNoti(index: Int32(indexPath.row))
            
            return
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
