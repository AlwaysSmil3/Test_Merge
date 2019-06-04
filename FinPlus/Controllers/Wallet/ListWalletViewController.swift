//
//  ListWalletViewController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import SDWebImage

enum WalletAction {
    case WalletDetail
    case LoanNation
    case RegisterInvestor
}

//CaoHai tra ve du lieu bank khi chon bank
protocol BankDataDelegate: class {
    func isReloadBankData(isReload: Bool, newAccountNumber: String)
}

class ListWalletViewController: BaseViewController {
    
    // MARK: - Outlet
    
    @IBOutlet var rightBarButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var tableview: TPKeyboardAvoidingTableView!
    @IBOutlet weak var noWalletLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    var walletAction: WalletAction = .WalletDetail
    let cellIdentifier = "cell"
    private var listWallet: NSMutableArray = []
    var currentSelected: Int?
    var currentBankIdSelected: Int32?
    
    var listFieldsForLoan: NSMutableArray = []
    
    //CaoHai tra ve du lieu bank khi chon bank
    var delegate: BankDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if self.walletAction == .LoanNation {
            self.initForCreateLoan()
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
    
    func updateDataFromServer() {
        if DataManager.shared.loanInfo.bankId > 0 {
            self.currentBankIdSelected = DataManager.shared.loanInfo.bankId
            self.tableview.reloadData()
        }
    }
    
    
    /// Cho Loan - Xong mỗi bước là gửi api put cập nhật dữ liệu cho mỗi bước
    func loadListBank(newAccountNumber: String) {
        
        APIClient.shared.getListBank(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard let strongSelf = self else { return }
                strongSelf.listWallet.removeAllObjects()
                
                if (model.count > 0 )
                {
                    
                    if strongSelf.walletAction == .LoanNation {
                        strongSelf.listFieldsForLoan.removeAllObjects()
                        
                        strongSelf.listFieldsForLoan.add("add_wallet")
                        if let fields = DataManager.shared.listFieldForStep4 {
                            strongSelf.listFieldsForLoan.addObjects(from: fields)
                        }
                        
                    }
                    
                    
                    if let id = model[0].id, id > 0 {
                        strongSelf.listWallet.addObjects(from: model)
                        if newAccountNumber != "" {
                            for bank in strongSelf.listWallet {
                                if let bank_ = bank as? AccountBank {
                                    if bank_.accountBankNumber == newAccountNumber {
                                        strongSelf.currentBankIdSelected = bank_.id
                                    }
                                }
                            }
                        }
                        
                        strongSelf.tableview.reloadData()
                    }
                }
                
                guard strongSelf.walletAction == .WalletDetail else { return }
                
                strongSelf.tableview.isHidden = strongSelf.listWallet.count < 1
                strongSelf.noWalletLabel.isHidden = strongSelf.listWallet.count > 0
                strongSelf.addBtn.isHidden = strongSelf.listWallet.count > 0
                
            }
            .catch { error in
        }
    }
    
    func getCurrentLoanBank() -> AccountBank? {
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
        self.view.endEditing(true)
        self.hanldeLoanDataToServer()
        
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
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewWallet() {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ADD_WALLET") as! AddWalletViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddWalletNewViewController") as! AddWalletNewViewController
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editWallet(index: Int) {
        guard index < self.listWallet.count, let bank = self.listWallet[index] as? AccountBank else { return }
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
        guard self.walletAction == .WalletDetail else {
            return self.listWallet.count > 0 ? 2 : 1
        }
        return self.listWallet.count > 0 ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.walletAction == .LoanNation, self.listWallet.count == 0 {
                return self.listFieldsForLoan.count
            }
            return listWallet.count
        default:
            if self.walletAction == .WalletDetail {
                return 1
            }
            return self.listFieldsForLoan.count
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
                
                if self.listWallet.count > 0 {
                    if let wallet = self.listWallet[indexPath.row] as? AccountBank, let bankID = wallet.id {
                        self.currentBankIdSelected = bankID
                        self.tableview.reloadData()
                    }
                } else {
                    self.hanldeDidSelectLoanCell(indexPath: indexPath)
                    
                }
                
                break
            case .RegisterInvestor:
                //Cho đăng ký làm nhà đầu tư
                break
            }
            
        default:
            if walletAction == .WalletDetail {
                addNewWallet()
                return
            }
            self.hanldeDidSelectLoanCell(indexPath: indexPath)
            
        }
    }
    
    func hanldeDidSelectLoanCell(indexPath: IndexPath) {
        guard let model = self.listFieldsForLoan[indexPath.row] as? LoanBuilderFields else {
            addNewWallet()
            return
        }
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.TextBox:
            
           
            break
            
        case DATA_TYPE_TB_CELL.DropDown:
            
            break
        default:
            break
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
                if self.listWallet.count > 0 {
                    header.textLabel?.text = NSLocalizedString("CHOOSE_ACCOUNT", comment: "")
                } else {
                    header.textLabel?.text = NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
                }
                
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
            if self.walletAction == .LoanNation {
                if self.listWallet.count > 0 {
                    return NSLocalizedString("CHOOSE_ACCOUNT", comment: "")
                } else {
                    return NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
                }
            } else {
                return NSLocalizedString("ALL_ACCOUNT_CONNECTED", comment: "")
            }
        default:
            return NSLocalizedString("CREATE_NEW_ACCOUNT", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            if self.walletAction == .LoanNation, self.listWallet.count == 0 {
                return self.getCellForLoan(indexPath: indexPath)
            }
            
            let item = listWallet[indexPath.row] as! AccountBank
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
            }
            
            cell?.tag = indexPath.row
            cell?.currentIndex = indexPath
//            cell?.avatar.kf.setImage(with: URL(string: FinPlusHelper.getStringURLIconBank(type: item.bankName ?? "")))
            cell?.avatar.sd_setImage(with: URL(string: FinPlusHelper.getStringURLIconBank(type: item.bankName ?? "")))
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
                        
                        if DataManager.shared.checkMissingBankData(key: "bank", currentBankHolder: item.accountBankName, currenAccount: item.accountBankNumber, id: Int(item.id!)) {
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
            
            if self.walletAction == .WalletDetail {
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
            
            return self.getCellForLoan(indexPath: indexPath)
        }
    }
    
    func getCellForLoan(indexPath: IndexPath) -> UITableViewCell {
        if let data = self.listFieldsForLoan[indexPath.row] as? String {
            if data == "no_wallet" {
                guard let cell = self.tableview.dequeueReusableCell(withIdentifier: "AddNewWalletTBCell", for: indexPath) as? AddNewWalletTBCell else {
                    return UITableViewCell()
                }
                
                return cell
                
            } else {
                var cell = self.tableview.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
                if cell == nil {
                    self.tableview.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                    cell = self.tableview.dequeueReusableCell(withIdentifier: cellIdentifier) as? WalletTableViewCell
                }
                
                cell?.avatar.image = UIImage(named: "add_wallet")
                cell?.nameLabel.text = NSLocalizedString("ADD_NEW_WALLET", comment: "")
                cell?.desLabel.isHidden = true
                cell?.hiddenCharLabel?.isHidden = true
                cell?.optionBtn.setImage(UIImage(named: "arrow_left"), for: .normal)
                
                return cell!
            }
        }
        
        guard let model = self.listFieldsForLoan[indexPath.row] as? LoanBuilderFields else {
            return UITableViewCell()
        }
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.TextBox:
            
            let cell = self.tableview.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            
            cell.field = model
            
            return cell
            
        case DATA_TYPE_TB_CELL.DropDown:
            let cell = self.tableview.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            cell.field = model
            
            return cell
        default:
            return UITableViewCell()
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
        guard index.row < self.listWallet.count, let bank = self.listWallet[index.row] as? AccountBank else { return }
        if self.walletAction == .LoanNation && !DataManager.shared.checkMissingBankData(key: "bank", currentBankHolder: bank.accountBankName, currenAccount: bank.accountBankNumber, id: Int(bank.id!)) {
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
