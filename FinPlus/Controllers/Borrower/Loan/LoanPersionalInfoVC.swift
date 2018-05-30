//
//  LoanPersionalInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import DropDown

// Giới tính
enum Gender: Int {
    case Male = 0
    case Female
}

// Số điện thọai người thân
enum RelationPhoneNumber: Int {
    case Wife = 0
    case Husband
    case Father
    case Mother

}


class LoanPersionalInfoVC: LoanBaseViewController {
    
    @IBOutlet var tfFullName: UITextField!
    @IBOutlet var tfGender: UITextField!
    @IBOutlet var btnGender: UIButton!
    
    @IBOutlet var tfRelationPhoneType: UITextField!
    @IBOutlet var tfRelationPhone: UITextField!
    @IBOutlet var btnRelationPhone: UIButton!
    
    @IBOutlet var tfBirthDay: UITextField!
    @IBOutlet var tfNationalID: UITextField!
    
    @IBOutlet var lblResidentAddress: UILabel!
    @IBOutlet var lblTemporaryAddress: UILabel!
    
    
    // Dropdown DataSource
    let genderDropdownDataSource = ["Nam", "Nữ"]
    let relationPhoneNumberDropdownDataSource = ["Vợ", "Chồng", "Bố", "Mẹ"]
    
    // Gender
    let genderDropdown = DropDown()
    var gender: Gender = .Male
    
    //Relationship PhoneNumber
    let relationPhoneNumberDropdown = DropDown()
    var relationPhoneNumberType: RelationPhoneNumber = .Wife
    
    //BirthDay
    var birthDay: Date? {
        didSet {
            if let date = self.birthDay {
                self.tfBirthDay.text = date.toString(.custom(kDisplayFormat))
            }
        }
    }
    
    // Address
    var residentAddress: Address?
    var temporatyAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDropdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    private func setupDropdown() {
        
        // Gender Dropdown
        self.genderDropdown.anchorView = self.btnGender
        self.genderDropdown.dataSource = self.genderDropdownDataSource
        
        self.genderDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard self.gender.rawValue != index else { return }
            self.tfGender.text = self.genderDropdownDataSource[index]
            if index == 0 {
                self.gender = .Male
            } else if index == 1 {
                self.gender = .Female
            }
        }
        
        // Relation PhoneNumber Dropdown
        self.relationPhoneNumberDropdown.anchorView = self.btnRelationPhone
        self.relationPhoneNumberDropdown.dataSource = self.relationPhoneNumberDropdownDataSource
        
        self.relationPhoneNumberDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard self.relationPhoneNumberType.rawValue != index else { return }
            self.tfRelationPhoneType.text = self.relationPhoneNumberDropdownDataSource[index]
            self.tfRelationPhone.placeholder = "Nhập số điện thoại của " + self.relationPhoneNumberDropdownDataSource[index]
            
            switch index {
            case 0:
                self.relationPhoneNumberType = .Wife
                break
            case 1:
                self.relationPhoneNumberType = .Husband
                break
            case 2:
                self.relationPhoneNumberType = .Father
                break
            case 3:
                self.relationPhoneNumberType = .Mother
                break
            default:
                break
            }
        }
        
    }
    
    private func updateDataForLoanAPI(completion: () -> Void) {
        guard let birthDay = self.birthDay, let residentAddr = self.residentAddress, let tempAddr = self.temporatyAddress else { return }
        
        DataManager.shared.loanInfo.userInfo.fullName = self.tfFullName.text!
        DataManager.shared.loanInfo.userInfo.gender = "\(self.gender.rawValue)"
        DataManager.shared.loanInfo.userInfo.birthDay = "\(birthDay.timeIntervalSince1970)"
        print("\(birthDay.timeIntervalSince1970)")
        DataManager.shared.loanInfo.userInfo.nationalID = self.tfNationalID.text!
        
        DataManager.shared.loanInfo.userInfo.residentAddress = residentAddr
        DataManager.shared.loanInfo.userInfo.temporaryAddress = tempAddr
        
        DataManager.shared.loanInfo.userInfo.relationships.phoneNumber = self.tfRelationPhone.text!
        DataManager.shared.loanInfo.userInfo.relationships.type = self.relationPhoneNumberType.rawValue
        
        completion()
    }
    
    //MARK: Actions
    
    @IBAction func btnGenderSelected(_ sender: Any) {
        self.genderDropdown.show()
    }
    
    @IBAction func btnBirthDayTapped(_ sender: Any) {
        
        DatePickerDialog().show("Ngày sinh", doneButtonTitle: "Đồng ý", cancelButtonTitle: "Huỷ", defaultDate: Date() , minimumDate: nil, maximumDate: Date(), datePickerMode: UIDatePickerMode.date) { (date) in
            
            if let date = date {
                self.birthDay = date
            }
        }
        
    }
    
    @IBAction func btnRelationCallTapped(_ sender: Any) {
        self.relationPhoneNumberDropdown.show()
        
    }
    
    @IBAction func btnResidentAddressTapped(_ sender: Any) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
    }
    
    
    @IBAction func btnTemporaryAddressTapped(_ sender: Any) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.typeAddress = 1
        firstAddressVC.delegate = self
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
    }
    
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.updateDataForLoanAPI {
            let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
            
            self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
        }
    }
    
    
    
}


extension LoanPersionalInfoVC: AddressDelegate {
    func getAddress(address: Address, type: Int) {
        let add = address.commune + ", " + address.district + ", " + address.city
        if type == 0 {
            self.lblResidentAddress.text = add
            self.residentAddress = address
        } else {
            self.lblTemporaryAddress.text = add
            self.temporatyAddress = address
        }
    }
}
