//
//  AddressTBViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

enum TypeAddressTBView: Int {
    case City = 0 // Tỉnh/ thành phố
    case District // Quận/ huyện
    case Commune  // Xã/ Phường
}

protocol AddressModelDelegate {
    func getModel1(model: Model1, type: TypeAddressTBView)
}

class AddressTBViewController: BaseViewController {
    
    @IBOutlet var mainTBView: UITableView!
    
    var delegate: AddressModelDelegate?
    
    var type: TypeAddressTBView = .City
    var id: Int16?
    
    var dataSource: [Model1] = [] {
        didSet {
            self.mainTBView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.tableFooterView = UIView()
        
        self.getData()
        
    }
    
    private func getData() {
        switch self.type {
        case .City:
            self.getCities()
            break
        case .District:
            if let id = self.id {
                self.getDistricts(cityID: id)
            }
            break
        case .Commune:
            if let id = self.id {
                self.getComunes(districtsID: id)
            }
            break
        }
        
    }
    
    private func getCities() {
        
        APIClient.shared.getCities()
            .done(on: DispatchQueue.main) { [weak self]model in
                print("city \(model)")
                self?.dataSource = model
            }
            .catch { error in }
    }
    
    private func getDistricts(cityID: Int16) {
        APIClient.shared.getDistricts(cityID: cityID)
            .done(on: DispatchQueue.main) { [weak self]model in
                print("Districts\(model)")
                self?.dataSource = model
                
            }
            .catch{ error in }
        
        
    }
    
    private func getComunes(districtsID: Int16) {
        APIClient.shared.getCommunes(districtID: districtsID)
            .done(on: DispatchQueue.main) { [weak self]model in
                print("Commune \(model)")
                self?.dataSource = model
            }
            .catch { error in }
        
    }
    

    
}

extension AddressTBViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Address_First_TB_Cell", for: indexPath) as! AddressFirstTBCell
        
        let model = self.dataSource[indexPath.row]
        cell.lblTitleCell.text = model.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.getModel1(model: self.dataSource[indexPath.row], type: self.type)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
