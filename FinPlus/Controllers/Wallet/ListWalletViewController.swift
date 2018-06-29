//
//  ListWalletViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

enum WalletAction {
    case WalletDetail
    case LoanNation
    case RegisterInvestor
}

//CaoHai tra ve du lieu bank khi chon bank
protocol BankDataDelegate {
    func getBankAccountData(bank: AccountBank)
}

class ListWalletViewController: BaseViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    var walletAction: WalletAction = .WalletDetail
    let cellIdentifier = "cell"
    private var listWallet: NSMutableArray = [
        AccountBank(wID: 0, wType: 1, wAccountName: "Nguyen Van A", wBankName: "Vietcombank", wNumber: "9888GH87UYY7", wDistrict: "Hà Nội", wIcon: #imageLiteral(resourceName: "vcb_selected")),
        AccountBank(wID: 0, wType: 2, wAccountName: "Nguyen Van B", wBankName: "Viettinbank", wNumber: "9888GH87UYY7", wDistrict: "Hà Nội", wIcon: #imageLiteral(resourceName: "viettin_selected")),
        AccountBank(wID: 0, wType: 3, wAccountName: "Nguyen Van C", wBankName: "Techcombank", wNumber: "9888GH87UYY7", wDistrict: "Hà Nội", wIcon: #imageLiteral(resourceName: "tech_selected")),
    ]
    
    //CaoHai tra ve du lieu bank khi chon bank
    var delegate: BankDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.walletAction == .LoanNation {
            self.setupTitleView(title: "Tạo yêu cầu vay", subTitle: "Bước 4: Tài khoản ngân hàng")
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.bottomView.isHidden = false
            DataManager.shared.loanInfo.currentStep = 2
            self.updateDataToServer()
        }
        

        self.title = NSLocalizedString("ACCOUNT_MANAGER", comment: "")
        
        self.noWalletLabel.text = NSLocalizedString("NO_ACCOUNT_BANK", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        self.addBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        
        let cellNib = UINib(nibName: "WalletTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableview.isHidden = self.listWallet.count < 1
        self.noWalletLabel.isHidden = self.listWallet.count > 0
        self.addBtn.isHidden = self.listWallet.count > 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ishidden = self.navigationController?.isNavigationBarHidden, ishidden {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    /// Cho Loan - Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func updateDataToServer() {
        APIClient.shared.loan(isShowLoandingView: false, httpType: .PUT)
            .done(on: DispatchQueue.global()) { model in
                DataManager.shared.loanID = model.loanId!
            }
            .catch { error in }
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cell_action(sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sửa thông tin tài khoản", style: .default , handler:{ (UIAlertAction)in
            self.editWallet(index: sender.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Xóa tài khoản", style: .destructive , handler:{ (UIAlertAction)in
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
        vc.wallet = self.listWallet[index] as! AccountBank
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
            switch walletAction {
            case .WalletDetail:
                editWallet(index: indexPath.row)
                break
            case .LoanNation:
                let wallet = self.listWallet[indexPath.row] as! AccountBank
                let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController
                DataManager.shared.loanInfo.walletId = wallet.id!
                DataManager.shared.loanInfo.bankId = Int(wallet.id!)
                self.navigationController?.pushViewController(loanNationalIDVC, animated: true)
                break
            case .RegisterInvestor:
                //Cho đăng ký làm nhà đầu tư
                guard let bank = self.listWallet[indexPath.row] as? AccountBank else { return }
                self.delegate?.getBankAccountData(bank: bank)
                self.navigationController?.popViewController(animated: true)
                break
            }
            
        default:
            addNewWallet()
        }
        
        
        
        
        
    }
    
}

extension ListWalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if (self.walletAction == .LoanNation)
            {
                return NSLocalizedString("CHOOSE_ACCOUNT", comment: "")
            }
            else
            {
                return NSLocalizedString("ALL_ACCOUNT_CONNECTED", comment: "")
            }
        default:
            return NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let item = listWallet[indexPath.row] as! AccountBank
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            }
            
            cell?.tag = indexPath.row
            
            switch(BankName(rawValue: item.bankType!))
            {
                case .Vietcombank?: cell?.avatar.image = UIImage(named: "vcb_selected")
                case .Viettinbank?: cell?.avatar.image = UIImage(named: "viettin_selected")
                case .Techcombank?: cell?.avatar.image = UIImage(named: "tech_selected")
                case .Agribank?: cell?.avatar.image = UIImage(named: "agri_selected")
                case .none:
                    break
            }
            cell?.nameLabel.text = item.bankName
            cell?.desLabel.text = item.accountBankNumber
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
