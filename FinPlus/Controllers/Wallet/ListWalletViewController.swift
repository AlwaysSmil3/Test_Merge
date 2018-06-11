//
//  ListWalletViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ListWalletViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    let cellIdentifier = "cell"
    private var listWallet: NSMutableArray = [
        Wallet(wID: 0, wType: 0, wAccountName: "MoMo", wName: "Nguyen Van A", wNumber: "9888GH87UYY7"),
        Wallet(wID: 0, wType: 0, wAccountName: "MoMo", wName: "Nguyen Van A", wNumber: "9888GH87UYY7"),
        Wallet(wID: 0, wType: 0, wAccountName: "MoMo", wName: "Nguyen Van A", wNumber: "9888GH87UYY7"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.title = NSLocalizedString("WALLET_MANAGER", comment: "")
        
        self.noWalletLabel.text = NSLocalizedString("NO_WALLET", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        
        let cellNib = UINib(nibName: "WalletTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableview.isHidden = self.listWallet.count < 1
        self.noWalletLabel.isHidden = self.listWallet.count > 0
        self.addBtn.isHidden = self.listWallet.count > 0
    }
    
    @objc func cell_action(sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sửa thông tin tài khoản ví", style: .default , handler:{ (UIAlertAction)in
            self.editWallet(index: sender.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Xóa tài khoản ví", style: .destructive , handler:{ (UIAlertAction)in
            self.listWallet.removeObject(at: sender.tag)
            self.tableview.reloadData()
            self.tableview.isHidden = self.listWallet.count < 1
            self.noWalletLabel.isHidden = self.listWallet.count > 0
            self.addBtn.isHidden = self.listWallet.count > 0
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewWallet() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editWallet(index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
        vc.wallet = self.listWallet[index] as! Wallet
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListWalletViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listWallet.count > 0 ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listWallet.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            editWallet(index: indexPath.row)
            
        default:
            addNewWallet()
        }
    }
    
}

extension ListWalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("ALL_ACCOUNT_CONNECTED", comment: "")
        default:
            return NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let item = listWallet[indexPath.row] as! Wallet
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            }
            
            cell?.tag = indexPath.row
            cell?.avatar.image = UIImage(named: item.walletType == 0 ? "momo" : "paypal")
            cell?.nameLabel.text = item.walletName
            cell?.desLabel.text = item.walletNumber
            cell?.optionBtn.addTarget(self, action: #selector(self.cell_action(sender:)), for: .touchUpInside)
            
            return cell!
            
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            }
            
            cell?.avatar.image = UIImage(named: "add_wallet")
            cell?.nameLabel.text = NSLocalizedString("ADD_NEW_WALLET", comment: "")
            cell?.desLabel.isHidden = true
            cell?.optionBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
            
            return cell!
        }
    }
    
}
