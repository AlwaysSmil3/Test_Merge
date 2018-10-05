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
    func isReloadBankData(isReload: Bool, newAccountNumber: String)
}

class ListWalletViewController: BaseViewController {

    // MARK: - Outlet
    
    @IBOutlet var rightBarButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    var walletAction: WalletAction = .WalletDetail
    let cellIdentifier = "cell"
    private var listWallet: NSMutableArray = []
    var currentSelected: Int?
    var currentBankIdSelected: Int32?

    
    //CaoHai tra ve du lieu bank khi chon bank
    var delegate: BankDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if self.walletAction == .LoanNation {
            self.rightBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : MAIN_COLOR, NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_SEMIBOLD, size: 17) ?? UIFont.boldSystemFont(ofSize: 17)], for: .normal)
            self.setupTitleView(title: "Tạo yêu cầu vay", subTitle: "Bước 4: Tài khoản nhận tiền")
            //self.navigationController?.navigationBar.shadowImage = UIImage()
            self.bottomView.isHidden = false
            self.updateDataFromServer()
            DataManager.shared.loanInfo.currentStep = 2
            self.updateDataToServer()
        } else {
            self.navigationItem.rightBarButtonItem = nil
            self.setupTitleView(title: "Quản lý tài khoản")
        }
        
        self.noWalletLabel.text = NSLocalizedString("NO_ACCOUNT_BANK", comment: "")
        
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.cornerRadius = 8
        self.addBtn.layer.masksToBounds = false
        self.addBtn.layer.borderColor = MAIN_COLOR.cgColor
        //self.addBtn.titleLabel?.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_NORMAL)
        
        let cellNib = UINib(nibName: "WalletTableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.loadListBank(newAccountNumber: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ishidden = self.navigationController?.isNavigationBarHidden, ishidden {
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func updateDataFromServer() {
        if DataManager.shared.loanInfo.bankId > 0 {
            self.currentBankIdSelected = DataManager.shared.loanInfo.bankId
            self.tableview.reloadData()
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
    
    /// Cho Loan - Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func loadListBank(newAccountNumber: String) {
        
        APIClient.shared.getListBank(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in

                self.listWallet.removeAllObjects()
                
                if (model.count > 0 )
                {
                    if let id = model[0].id, id > 0 {
                        self.listWallet.addObjects(from: model)
                        if newAccountNumber != "" {
                            for bank in self.listWallet {
                                if let bank_ = bank as? AccountBank {
                                    if bank_.accountBankNumber == newAccountNumber {
                                        self.currentBankIdSelected = bank_.id
                                    }
                                }
                            }
                        }
                        
                        self.tableview.reloadData()
                    }
                }
                
                self.tableview.isHidden = self.listWallet.count < 1
                self.noWalletLabel.isHidden = self.listWallet.count > 0
                self.addBtn.isHidden = self.listWallet.count > 0
                
            }
            .catch { error in
        }
    }
    
    private func getCurrentLoanBank() -> AccountBank? {
        let loanBankId = DataManager.shared.loanInfo.bankId
            for bank in self.listWallet {
                if let bank_ = bank as? AccountBank {
                    if let bankId = bank_.id {
                        if bankId == loanBankId {
                            return bank_
                        }
                    }
                }
                
            }
        
        return nil
        
    }
    
    @IBAction func raightBarButtonTapped(_ sender: Any) {
        
        guard self.walletAction == .LoanNation, let bankId = self.currentBankIdSelected else {
            self.showToastWithMessage(message: "Vui lòng chọn tài khoản nhận tiền")
            return
        }
        
        if !DataManager.shared.checkDataInvalidChangedInStepBank(currentBank: self.getCurrentLoanBank()) {
            //For Missing Data
            self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
            return
        }
        
        DataManager.shared.loanInfo.walletId = bankId
        DataManager.shared.loanInfo.bankId = bankId
        
        
        if DataManager.shared.listKeyMissingLoanKey != nil && DataManager.shared.listKeyMissingLoanKey!.count > 0  {
            if !DataManager.shared.checkIndexLastStepHaveMissingData(index: 4) {
                DataManager.shared.loanInfo.currentStep = 3
                updateLoanStatusInvalidData()
                return
            }
        }
        
        let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(loanNationalIDVC, animated: true)

    }
    
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cell_action(sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sửa thông tin tài khoản", style: .default , handler:{ (UIAlertAction)in
            self.editWallet(index: sender.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Xóa tài khoản", style: .destructive , handler:{ (UIAlertAction)in
            guard let bank = self.listWallet[sender.tag] as? AccountBank, let bankID = bank.id else { return }
            self.deleteBank(bankID: bankID, index: sender.tag)
            
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
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editWallet(index: Int) {
        guard let bank = self.listWallet[index] as? AccountBank else { return }
        let vc = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "UpdateWalletViewController") as! UpdateWalletViewController
        vc.wallet = bank
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        vc.walletAction = self.walletAction
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// Delete Bank
    ///
    /// - Parameter bankID: <#bankID description#>
    func deleteBank(bankID: Int32, index: Int) {
        APIClient.shared.deleteBankAccount(bankAccountID: bankID)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard let strongSelf = self else { return }
                strongSelf.showToastWithMessage(message: model.returnMsg!)
                
                strongSelf.listWallet.removeObject(at: index)
                strongSelf.tableview.reloadData()
                strongSelf.tableview.isHidden = strongSelf.listWallet.count < 1
                strongSelf.noWalletLabel.isHidden = strongSelf.listWallet.count > 0
                strongSelf.addBtn.isHidden = strongSelf.listWallet.count > 0
            }
            .catch { error in }
 
    }
    
    
}

//MARK: UITableViewDelegate
extension ListWalletViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listWallet.count > 0 ? 2 : 0
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
        
        self.currentSelected = indexPath.row
        
        switch indexPath.section {
        case 0:
            switch walletAction {
            case .WalletDetail:
                editWallet(index: indexPath.row)
                break
            case .LoanNation:
                if let wallet = self.listWallet[indexPath.row] as? AccountBank, let bankID = wallet.id {
                    self.currentBankIdSelected = bankID
                    self.tableview.reloadData()
                }
                
                break
            case .RegisterInvestor:
                //Cho đăng ký làm nhà đầu tư
//                guard let bank = self.listWallet[indexPath.row] as? AccountBank else { return }
//                self.delegate?.getBankAccountData(bank: bank)
//                self.navigationController?.popViewController(animated: true)
                break
            }
        
        default:
            addNewWallet()
        }
    }
    
}

//MARK: UITableViewDataSource
extension ListWalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = FONT_CAPTION
        header.textLabel?.textColor = TEXT_NORMAL_COLOR
        switch section {
        case 0:
            if (self.walletAction == .LoanNation)
            {
                header.textLabel?.text = NSLocalizedString("CHOOSE_ACCOUNT", comment: "")
            }
            else
            {
                header.textLabel?.text = NSLocalizedString("ALL_ACCOUNT_CONNECTED", comment: "")
            }
        default:
            header.textLabel?.text = NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
        }
    }
    
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
            cell?.currentIndex = indexPath
            
            switch(BankName(rawValue: item.bankType!))
            {
                case .Vietcombank?: cell?.avatar.image = UIImage(named: "vcb_selected")
                case .Viettinbank?: cell?.avatar.image = UIImage(named: "viettin_selected")
                case .Techcombank?: cell?.avatar.image = UIImage(named: "tech_selected")
                case .Agribank?: cell?.avatar.image = UIImage(named: "agri_selected")
                case .ViettelPay?: cell?.avatar.image = #imageLiteral(resourceName: "viettelPay_selected")
                case .Momo?: cell?.avatar.image = #imageLiteral(resourceName: "momo_selected")
                case .Bidv?: cell?.avatar.image = #imageLiteral(resourceName: "bidv_selected")
                case .none:
                    break
            }
            cell?.nameLabel.text = item.bankName
            
            if let number = item.accountBankNumber, number.count > 4 {
                cell?.desLabel.text = String(number.suffix(4))
            } else {
                cell?.desLabel.text = item.accountBankNumber
            }
            
            cell?.desLabel.isHidden = false
            cell?.hiddenCharLabel?.isHidden = false
            cell?.optionBtn.setImage(UIImage(named: "option_icon"), for: .normal)
            cell?.delegate = self
            
            if let verified = item.verified, verified == 1 {
                cell?.optionBtn.isHidden = true
                cell?.lblVerified?.isHidden = false
                cell?.nameLabelCenterYConstraint.constant = -7
            } else {
                cell?.optionBtn.isHidden = false
                cell?.lblVerified?.isHidden = true
                cell?.nameLabelCenterYConstraint.constant = 0
            }
        
            if self.walletAction == .LoanNation {
                
                cell?.optionBtn.setImage(#imageLiteral(resourceName: "ic_radio_off"), for: .normal)
                cell?.optionBtn.isHidden = false
                
                if let id = item.id {
                    if let bankIdSelected = self.currentBankIdSelected,  bankIdSelected > 0 && id == bankIdSelected {
                        cell?.borderView.layer.borderColor = MAIN_COLOR.cgColor
                        cell?.optionBtn.setImage(#imageLiteral(resourceName: "ic_radio_on"), for: .normal)
                        
                        
                        if DataManager.shared.checkMissingBankData(key: "bank", currentBankHolder: item.accountBankName, currenAccount: item.accountBankNumber) {
                            //Cap nhat thong tin khong hop le
                            cell?.optionBtn.setImage(UIImage(named: "option_icon"), for: .normal)
                            cell?.borderView.layer.borderColor = UIColor.red.cgColor
                        } else {
                            userDefault.set("", forKey: UserDefaultInValidBank)
                            userDefault.synchronize()
                        }
                        
                        return cell!
                    }
                }
            }
            
            cell?.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
            
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
            cell?.hiddenCharLabel?.isHidden = true
            cell?.optionBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
            
            return cell!
        }
    }
    
}

//MARK: BankDataDelegate
extension ListWalletViewController: BankDataDelegate {
    func isReloadBankData(isReload: Bool, newAccountNumber: String) {
        guard isReload else { return }
        self.loadListBank(newAccountNumber: newAccountNumber)
    }
}

//MARK: EditWalletDelegate
extension ListWalletViewController: EditWalletDelegate {
    func editWallet(index: IndexPath) {
        let bank = self.listWallet[index.row] as! AccountBank
        if self.walletAction == .LoanNation && !DataManager.shared.checkMissingBankData(key: "bank", currentBankHolder: bank.accountBankName, currenAccount: bank.accountBankNumber) {
            return
        }
        
        if let verified = bank.verified, verified == 1 {
            return
        }
        
        let alert = UIAlertController(title: "", message: "Lựa chọn", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sửa thông tin tài khoản", style: .default , handler:{ (UIAlertAction)in
            self.editWallet(index: index.row)
        }))
        
        alert.addAction(UIAlertAction(title: "Xóa tài khoản", style: .destructive , handler:{ (UIAlertAction)in
            guard let bank = self.listWallet[index.row] as? AccountBank, let bankID = bank.id else { return }
            self.deleteBank(bankID: bankID, index: index.row)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}



