//
//  AddressFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol AddressDelegate: class {
    func getAddress(address: Address, type: Int, title: String, id: String)
}

class AddressFirstViewController: BaseViewController {
    
    @IBOutlet var lblTitleHeader: UILabel!
    @IBOutlet var mainTableView: TPKeyboardAvoidingTableView!
    
    weak var delegate: AddressDelegate?
    var dataSource : [LoanBuilderFields] = []
    var cityModel: Model1?
    var cityModelTemp: Model1?
    var districtModel: Model1?
    var districtModelTemp: Model1?
    var communeModel: Model1?
    //Số nhà, thôn, xóm,....
    var numberHouse: String?
    var typeAddress = 0
    var titleString = "Địa chỉ"
    var id = "jobAddress"
    var valueTemp: String?
    var addressStringValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitleHeader.text = self.titleString
        self.initData()
        self.mapDataFromServer()
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
    
    func mapDataFromServer() {
        if id.contains("jobAddress") {
            self.mapData(address: DataManager.shared.loanInfo.jobInfo.jobAddress)
        } else if id.contains("academicAddress") {
            self.mapData(address: DataManager.shared.loanInfo.jobInfo.academicAddress)
        } else if id.contains("currentAddress") {
            self.mapData(address: DataManager.shared.loanInfo.userInfo.temporaryAddress)
        } else if id.contains("residentAddress") {
            self.mapData(address: DataManager.shared.loanInfo.userInfo.residentAddress)
        } else {
            guard let valueString = self.addressStringValue else { return }
            self.mapDataWith(value: valueString)
        }
    }
    
    private func mapDataWith(value: String) {
        let listValue = value.components(separatedBy: KeySeparateAddressFormatString)
        
        guard listValue.count > 3 else { return }
        
        self.numberHouse = listValue[0]
        
        self.communeModel = Model1(object: NSObject())
        self.communeModel?.name = listValue[1]
        
        self.districtModel = Model1(object: NSObject())
        self.districtModel?.name = listValue[2]
        
        self.cityModel = Model1(object: NSObject())
        self.cityModel?.name = listValue[3]
        self.getCities(city: listValue[3], district: listValue[2], comune: listValue[1])
    }
    
    private func mapData(address: Address) {
        guard address.city.count > 0 else { return }
        
        self.numberHouse = address.street
        
        self.communeModel = Model1(object: NSObject())
        self.communeModel?.name = address.commune
        
        self.districtModel = Model1(object: NSObject())
        self.districtModel?.name = address.district
        
        self.cityModel = Model1(object: NSObject())
        self.cityModel?.name = address.city
        self.getCities(city: address.city, district: address.district, comune: address.commune)
    }
    
    //MAKR: Call API map id
    private func getCities(city: String, district: String, comune: String) {
        APIClient.shared.getCities()
            .done(on: DispatchQueue.global()) { [weak self] model in
                guard model.count > 0 else { return }
                let temp = model.filter { $0.name == city }
                if temp.count > 0 {
                    self?.cityModel?.id = temp[0].id!
                    self?.getDistricts(cityID: temp[0].id!, district: district, comune: comune)
                }
            }
            .catch { error in }
    }
    
    private func getDistricts(cityID: Int16, district: String, comune: String) {
        APIClient.shared.getDistricts(cityID: cityID)
            .done(on: DispatchQueue.global()) { [weak self]model in
                guard model.count > 0 else { return }
                let temp = model.filter { $0.name == district }
                if temp.count > 0 {
                    self?.districtModel?.id = temp[0].id!
                    self?.getComunes(districtsID: temp[0].id!, comune: comune)
                }
            }
            .catch { error in }
    }
    
    private func getComunes(districtsID: Int16, comune: String) {
        APIClient.shared.getCommunes(districtID: districtsID)
            .done(on: DispatchQueue.global()) { [weak self]model in
                guard model.count > 0 else { return }
                let temp = model.filter { $0.name == comune }
                if temp.count > 0 {
                    self?.communeModel?.id = temp[0].id
                }
            }
            .catch { error in }
    }
    
    /// Setup cho tableView
    func setupMainTBView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
//        mainTableView.register(UINib(nibName: "LoanTypeDropdownTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_Dropdown_TB_Cell")
//        mainTableView.register(UINib(nibName: "LoanTypeTextFieldTBCell", bundle: nil), forCellReuseIdentifier: "Loan_Type_TextField_TB_Cell")
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.separatorColor = UIColor.clear
        mainTableView.tableFooterView = UIView()
        
        mainTableView.registerCell(LoanTypeDropdownTBCell.className)
        mainTableView.registerCell(LoanTypeTextFieldTBCell.className)
    }
    
    //MARK: Actions
    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let cityModel_ = self.cityModel, let districtModel_ = self.districtModel, let communeModel_ = self.communeModel else {
            self.showToastWithMessage(message: "Vui lòng chọn Tỉnh,Thành phố; Quận, Huyện; Phường, xã, thị trấn")
            return
        }
        let indexPath = IndexPath(row: 3, section: 0)
        guard let cell = self.mainTableView.cellForRow(at: indexPath) as? LoanTypeTextFieldTBCell, let street = cell.tfValue?.text, street.length() > 0 else {
            self.showToastWithMessage(message: "Vui lòng nhập số nhà, đường, thôn, xóm...")
            return
        }
        
        let address = Address(city: cityModel_.name!, district: districtModel_.name!, commune: communeModel_.name!, street: street, zipCode: "", long: 0.0, lat: 0.0)
        
        self.delegate?.getAddress(address: address, type: self.typeAddress, title: self.titleString, id: self.id)
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
            
            if let text = cell.tfValue?.text, text.count == 0 {
                if let stress = numberHouse {
                    cell.tfValue?.text = stress
                }
            }
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
            self.districtModel = nil
            self.communeModel = nil
            self.mainTableView.reloadData()
        case .District:
            self.districtModel = model
            guard self.districtModelTemp?.id != model.id else { return }
            self.districtModelTemp = model
            self.communeModel = nil
            self.mainTableView.reloadData()
        case .Commune:
            self.communeModel = model
            let indexPath = IndexPath(row: 2, section: 0)
            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        let indexPath = IndexPath(row: 3, section: 0)
        guard let cell = self.mainTableView.cellForRow(at: indexPath) as? LoanTypeTextFieldTBCell else {
            return
        }
        
        cell.tfValue?.text = ""
    }
    
}
