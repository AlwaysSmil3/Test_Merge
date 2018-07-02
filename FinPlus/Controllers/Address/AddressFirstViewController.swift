//
//  AddressFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol AddressDelegate {
    func getAddress(address: Address, type: Int, title: String)
}

class AddressFirstViewController: BaseViewController {
    
    var delegate: AddressDelegate?
    
    var dataSource : [LoanBuilderFields] = []
    
    var cityModel: Model1?
    var cityModelTemp: Model1?
    
    var districtModel: Model1?
    var districtModelTemp: Model1?
    
    
    var communeModel: Model1?
    
    //Số nhà, thôn, xóm,....
    var numberHouse: String?
    
    var typeAddress: Int = 0
    
    //Title trong fields LoanBuider
    //var titleTypeAddress: String = ""
    var titleString: String = "Địa chỉ"
    
    @IBOutlet var lblTitleHeader: UILabel!
    @IBOutlet var mainTableView: TPKeyboardAvoidingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitleHeader.text = self.titleString
        
        self.initData()
        self.setupMainTBView()
    }
    
    private func initData() {
        
        var data1 = LoanBuilderFields(object: NSObject())
        data1.title = "Tỉnh/Thành phố"
        data1.placeholder = "Nhấn để chọn"
        data1.selectorTitle = "Nhấn để chọn"
        data1.type = DATA_TYPE_TB_CELL.DropDown
        
        self.dataSource.append(data1)
        
        var data2 = LoanBuilderFields(object: NSObject())
        data2.title = "Quận/Huyện"
        data2.placeholder = "Nhấn để chọn"
        data2.selectorTitle = "Nhấn để chọn"
        data2.type = DATA_TYPE_TB_CELL.DropDown
        
        self.dataSource.append(data2)
        
        var data3 = LoanBuilderFields(object: NSObject())
        data3.title = "Phường/Xã/Thị trấn"
        data3.placeholder = "Nhấn để chọn"
        data3.selectorTitle = "Nhấn để chọn"
        data3.type = DATA_TYPE_TB_CELL.DropDown
        
        self.dataSource.append(data3)
        
        var data4 = LoanBuilderFields(object: NSObject())
        data4.title = "Địa chỉ"
        data4.placeholder = "Nhập số nhà, đường, xóm, thôn,..."
        data4.type = DATA_TYPE_TB_CELL.TextBox
        
        self.dataSource.append(data4)
        
    }
    
    /// Setup cho tableView
    func setupMainTBView() {
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Dropdown_TB_Cell")
        mainTableView.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_TextField_TB_Cell")
        
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.separatorColor = UIColor.clear
        mainTableView.tableFooterView = UIView()
        
    }
    
    //MARK: Actions
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        guard let cityModel_ = self.cityModel, let districtModel_ = self.districtModel, let communeModel_ = self.communeModel else {
            self.showToastWithMessage(message: "Vui lòng chọn Tỉnh,Thành phố; Quân, Huyện; Phường, xã, thị trấn")
            return
        }
        let indexPath = IndexPath(row: 3, section: 0)
        guard let cell = self.mainTableView.cellForRow(at: indexPath) as? LoanTypeTextFieldTBCell, let street = cell.tfValue?.text, street.length() > 0 else {
            self.showToastWithMessage(message: "Vui lòng nhập số nhà, đường, thôn, xóm...")
            return
        }
        
        let address = Address(city: cityModel_.name!, district: districtModel_.name!, commune: communeModel_.name!, street: street, zipCode: "", long: 0.0, lat: 0.0)
        
        
        self.delegate?.getAddress(address: address, type: self.typeAddress, title: self.titleString)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddressFirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = dataSource[indexPath.row]
        
        switch model.type! {
        case DATA_TYPE_TB_CELL.TextBox:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.TextField, for: indexPath) as! LoanTypeTextFieldTBCell
            cell.field = model
            return cell
            
        case DATA_TYPE_TB_CELL.DropDown:
            let cell = tableView.dequeueReusableCell(withIdentifier: Loan_Identifier_TB_Cell.DropDown, for: indexPath) as! LoanTypeDropdownTBCell
            cell.field = model
            
            if let cityModel = self.cityModel, indexPath.row == 0 {
                cell.lblValue?.text = cityModel.name!
            }
            
            if let districtModel = self.districtModel, indexPath.row == 1 {
                cell.lblValue?.text = districtModel.name!
            }
            
            if let communeModel = self.communeModel, indexPath.row == 2 {
                cell.lblValue?.text = communeModel.name!
            }
            
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let addressTBView = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressTBViewController") as! AddressTBViewController
            
            addressTBView.type = .City
            addressTBView.delegate = self
            
            self.navigationController?.pushViewController(addressTBView, animated: true)
            
            break
        case 1:
            guard let model = self.cityModel else {
                self.showToastWithMessage(message: "Vui lòng chọn Tỉnh/ Thành phố trước")
                return
            }
            
            let addressTBView = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressTBViewController") as! AddressTBViewController
            
            addressTBView.type = .District
            addressTBView.delegate = self
            addressTBView.id = model.id!
            
            self.navigationController?.pushViewController(addressTBView, animated: true)
            
            break
        case 2:
            guard let model = self.districtModel else {
                self.showToastWithMessage(message: "Vui lòng chọn Quận/ Huyện trước")
                return
            }
            
            let addressTBView = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressTBViewController") as! AddressTBViewController
            
            addressTBView.type = .Commune
            addressTBView.delegate = self
            addressTBView.id = model.id!
            
            self.navigationController?.pushViewController(addressTBView, animated: true)
            
            break
        case 3:
            
            break
            
        default:
            break
        }
        
    }
}

extension AddressFirstViewController: AddressModelDelegate {
    func getModel1(model: Model1, type: TypeAddressTBView) {
        
        switch type {
        case .City:
            self.cityModel = model
            
            guard self.cityModelTemp?.id != model.id else { return }
            self.cityModelTemp = model
            
            self.dataSource[1].title = "Phường/Xã/Thị trấn"
            self.dataSource[1].placeholder = "Nhấn để chọn"
            self.dataSource[1].selectorTitle = "Nhấn để chọn"
            
            self.dataSource[2].title = "Phường/Xã/Thị trấn"
            self.dataSource[2].placeholder = "Nhấn để chọn"
            self.dataSource[2].selectorTitle = "Nhấn để chọn"
            
            self.mainTableView.reloadData()
            
//            let indexPath = IndexPath(row: 0, section: 0)
//            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
        case .District:
            self.districtModel = model
            guard self.districtModelTemp?.id != model.id else { return }
            self.districtModelTemp = model
            
            self.dataSource[3].title = "Phường/Xã/Thị trấn"
            self.dataSource[3].placeholder = "Nhấn để chọn"
            self.dataSource[3].selectorTitle = "Nhấn để chọn"
            
            self.mainTableView.reloadData()
            
//            let indexPath = IndexPath(row: 1, section: 0)
//            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
        case .Commune:
            self.communeModel = model
            let indexPath = IndexPath(row: 2, section: 0)
            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
            
        }
        
    }
}


