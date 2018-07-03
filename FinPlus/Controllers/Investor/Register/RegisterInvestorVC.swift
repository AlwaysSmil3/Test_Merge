//
//  RegisterInvestorVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class RegisterInvestorVC: BaseViewController {
    
    
    @IBOutlet var mainTBView: TPKeyboardAvoidingTableView!
    
    //BirthDay
    var birthDay: Date? {
        didSet {
            if let date1 = self.birthDay {
                let date = date1.toString(.custom(kDisplayFormat))
                
                guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
                self.mainTBView?.deselectRow(at: indexPath, animated: true)
                if let cell = self.mainTBView?.cellForRow(at: indexPath) as? RegisterInvestorDateTBCell {
                    cell.dataRes?.value = date
                    //DateTime ISO 8601
                    let timeISO8601 = date1.toString(.iso8601(ISO8601Format.DateTimeSec))
                    self.registerInvestModel.birthday = timeISO8601
                }
            }
        }
    }
    
    // facebook Info
    var faceBookInfo: FacebookInfo?
    
    // Loại user: Browwer hay Investor, browwer = 0, investor = 1
    var accountType: TypeAccount?
    
    var pw: String?
    
    var registerInvestModel: InvestorRegisterModel = InvestorRegisterModel()
    
    var dataSource: [InvestorRegister] = [
        InvestorRegister(title: "Họ và tên", value: "", icon: nil, placeHolder: "Họ và tên của bạn"),
        InvestorRegister(title: "Ngày sinh", value: "Ngày sinh của bạn", icon: nil, placeHolder: ""),
        InvestorRegister(title: "Số chứng minh thư", value: "", icon: nil, placeHolder: "Số CMTND của bạn"),
        InvestorRegister(title: "Địa chỉ email", value: "", icon: nil, placeHolder: "Địa chỉ email của bạn"),
        InvestorRegister(title: "Địa chỉ nhà", value: "Nhấn để chọn địa chỉ", icon: nil, placeHolder: ""),
        InvestorRegister(title: "Chọn tài khoản ngân hàng", value: "Thêm tài khoản ngân hàng", icon: #imageLiteral(resourceName: "add_wallet"), placeHolder: ""),
        InvestorRegister(title: "Kết nối tài khoản Facebook", value: "Kết nối với Facebook", icon: #imageLiteral(resourceName: "ic_fb_1"), placeHolder: ""),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTBView.register(UINib(nibName: "RegisterInvestorDateTBCell", bundle: nil), forCellReuseIdentifier: "Register_Investor_Date_TB_Cell")
        mainTBView.register(UINib(nibName: "RegisterInvestorTFTBCell", bundle: nil), forCellReuseIdentifier: "Register_Investor_TF_TB_Cell")
        mainTBView.register(UINib(nibName: "RegisterInvestorAddressTBCell", bundle: nil), forCellReuseIdentifier: "Register_Investor_Address_TB_Cell")
        mainTBView.register(UINib(nibName: "RegisterInvestorSelectionTBCell", bundle: nil), forCellReuseIdentifier: "Register_Investor_Selection_TB_Cell")
        
        mainTBView.rowHeight = UITableViewAutomaticDimension
        mainTBView.separatorColor = UIColor.clear
        mainTBView.tableFooterView = UIView()
        
        self.registerInvestModel.phoneNumber = DataManager.shared.currentAccount
        self.registerInvestModel.password = self.pw ?? ""
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    /// Show date time Picker
    func showDateDialog() {
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in
            
            if let date = date {
                self.birthDay = date
            }
        }
    }
    
    /// Sang màn chọn địa chỉ
    func gotoAddressVC() {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {

//        // lionel fix to test
        let investorWaitingVC = InvestorSignupWaitingViewController(nibName: "InvestorSignupWaitingViewController", bundle: nil)
        self.navigationController?.present(investorWaitingVC, animated: true, completion: nil)
        return
//        // end

        if let cell = self.mainTBView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterInvestorTFTBCell {
            //Name
            self.registerInvestModel.displayName = cell.tfValue?.text ?? ""
            
        }
        
        if let cell = self.mainTBView?.cellForRow(at: IndexPath(row: 2, section: 0)) as? RegisterInvestorTFTBCell {
            //NationalID
            self.registerInvestModel.nationalId = cell.tfValue?.text ?? ""
            
        }
        
        if let cell = self.mainTBView?.cellForRow(at: IndexPath(row: 3, section: 0)) as? RegisterInvestorTFTBCell {
            //Email
            self.registerInvestModel.email = cell.tfValue?.text ?? ""
            
        }
        
        guard let displayName = self.registerInvestModel.displayName, displayName.length() > 0, let birthDay = self.registerInvestModel.birthday, birthDay.length() > 0, let nationalID = self.registerInvestModel.nationalId, nationalID.length() > 0, let email = self.registerInvestModel.email, email.length() > 0 else { return }
        
        APIClient.shared.updateInfoForInvestor(investInfo: self.registerInvestModel)
            .done(on: DispatchQueue.main) { [weak self] model in
                let investorWaitingVC = InvestorSignupWaitingViewController(nibName: "InvestorSignupWaitingViewController", bundle: nil)
                self?.navigationController?.present(investorWaitingVC, animated: true, completion: nil)
                
            }
            .catch { error in}

    }

}

extension RegisterInvestorVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_TF_TB_Cell", for: indexPath) as! RegisterInvestorTFTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_Date_TB_Cell", for: indexPath) as! RegisterInvestorDateTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_TF_TB_Cell", for: indexPath) as! RegisterInvestorTFTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_TF_TB_Cell", for: indexPath) as! RegisterInvestorTFTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_Address_TB_Cell", for: indexPath) as! RegisterInvestorAddressTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_Selection_TB_Cell", for: indexPath) as! RegisterInvestorSelectionTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_Selection_TB_Cell", for: indexPath) as! RegisterInvestorSelectionTBCell
            cell.dataRes = self.dataSource[indexPath.row]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_Investor_TF_TB_Cell", for: indexPath) as! RegisterInvestorTFTBCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            break
        case 1:
            //Ngay sinh
            self.showDateDialog()
            break
        case 2:
            
            break
        case 3:
            
            break
        case 4:
            //Dia chi
            self.gotoAddressVC()
            break
        case 5:
            //Chon bank
            let loanWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "LIST_WALLET") as! ListWalletViewController
            loanWalletVC.walletAction = .RegisterInvestor
            loanWalletVC.delegate = self
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
            
            break
            
        case 6:
            //Ket noi Facebook
            let verifyFBVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyFacebookVC") as! VerifyFacebookVC
            
            verifyFBVC.pw = self.pw
            verifyFBVC.accountType = self.accountType
            verifyFBVC.delegate = self
            
            self.navigationController?.pushViewController(verifyFBVC, animated: true)
            
            break
            
        default:
            break
        }
        
        
    }
    
    
    
    
    
}

//MARK: Address Delegate
extension RegisterInvestorVC: AddressDelegate {
    func getAddress(address: Address, type: Int, title: String) {
        let add = address.street + ", " + address.commune + ", " + address.district + ", " + address.city
        //Update Address
        self.registerInvestModel.residentAddress = address
        self.registerInvestModel.residentAddress?.zipCode = "66666"
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? RegisterInvestorAddressTBCell {
            cell.dataRes?.value = add
            
        }
        
        
    }
}

//MARK: RegisterInvestorVC
extension RegisterInvestorVC: FacebookInfoDelegate {
    func getFacebookInfo(info: FacebookInfo) {
        
        //Update FB info
        self.registerInvestModel.accessToken = info.accessToken
        self.registerInvestModel.avatar = info.avatar
        self.registerInvestModel.fullname = info.fullName
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? RegisterInvestorSelectionTBCell {
            cell.dataRes?.value = info.fullName
            cell.imgIcon.sd_setImage(with: URL(string: info.avatar), completed: nil)
            cell.icDisclosure?.image = #imageLiteral(resourceName: "option_icon")
        }
    }
}

//MARK: BankData Delegate
extension RegisterInvestorVC: BankDataDelegate {
    func getBankAccountData(bank: AccountBank) {
        
        //Update bank
        self.registerInvestModel.bank?.accountHolder = bank.accountBankName ?? ""
        self.registerInvestModel.bank?.accountNumber = bank.accountBankNumber ?? ""
        self.registerInvestModel.bank?.type = bank.bankName ?? ""
        self.registerInvestModel.bank?.branch = bank.district ?? ""
        
        
        guard let indexPath = self.mainTBView?.indexPathForSelectedRow else { return }
        self.mainTBView?.deselectRow(at: indexPath, animated: true)
        if let cell = self.mainTBView?.cellForRow(at: indexPath) as? RegisterInvestorSelectionTBCell {
            cell.dataRes?.value = (bank.bankName ?? "") + " - " + (bank.accountBankNumber ?? "")
            cell.imgIcon.image = bank.icon
            
            switch(BankName(rawValue: bank.bankType!))
            {
            case .Vietcombank?: cell.imgIcon.image = UIImage(named: "vcb_selected")
            case .Viettinbank?: cell.imgIcon.image = UIImage(named: "viettin_selected")
            case .Techcombank?: cell.imgIcon.image = UIImage(named: "tech_selected")
            case .Agribank?: cell.imgIcon.image = UIImage(named: "agri_selected")
            case .none:
                break
            }
            
            cell.icDisclosure?.image = #imageLiteral(resourceName: "option_icon")
        }
        
    }
}


