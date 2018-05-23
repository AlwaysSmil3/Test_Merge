//
//  AddressFirstViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol AddressDelegate {
    func getAddress(address: Address, type: Int)
}

class AddressFirstViewController: BaseViewController {
    
    var delegate: AddressDelegate?
    
    let dataSource = ["Tỉnh/ Thành phố", "Quận/ Huyện", "Xã/ Phường ", "Mã bưu điện", "Địa chỉ nhà"]
    
    var cityModel: Model1?
    var districtModel: Model1?
    var communeModel: Model1?
    
    var typeAddress: Int = 0
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTableView.tableFooterView = UIView()
    
    }
    
    //MARK: Actions
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        guard let cityModel_ = self.cityModel, let districtModel_ = self.districtModel, let communeModel_ = self.communeModel else {
            return
        }
        
        let address = Address(city: cityModel_.name!, district: districtModel_.name!, commune: communeModel_.name!, street: "", zipCode: "", long: 0.0, lat: 0.0)
        
        
        self.delegate?.getAddress(address: address, type: self.typeAddress)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddressFirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Address_First_TB_Cell", for: indexPath) as! AddressFirstTBCell
        
        cell.lblTitleCell.text = dataSource[indexPath.row]
        
        if let cityModel = self.cityModel, indexPath.row == 0 {
            cell.lblTitleCell.text = cityModel.name!
        }
        
        if let districtModel = self.districtModel, indexPath.row == 1 {
            cell.lblTitleCell.text = districtModel.name!
        }
        
        if let communeModel = self.communeModel, indexPath.row == 2 {
            cell.lblTitleCell.text = communeModel.name!
        }
        
        return cell
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
            let indexPath = IndexPath(row: 0, section: 0)
            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
        case .District:
            self.districtModel = model
            let indexPath = IndexPath(row: 1, section: 0)
            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
        case .Commune:
            self.communeModel = model
            let indexPath = IndexPath(row: 2, section: 0)
            self.mainTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            break
            
        }
        
    }
}


