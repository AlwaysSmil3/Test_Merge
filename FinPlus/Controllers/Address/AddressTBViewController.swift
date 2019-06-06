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
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mainTBView: UITableView!
    
    var delegate: AddressModelDelegate?
    
    var type: TypeAddressTBView = .City
    var id: Int16?
    
    var dataSource: [Model1] = [] {
        didSet {
            self.dataSourceTemp = self.dataSource
        }
    }
    
    var dataSourceTemp: [Model1] = [] {
        didSet {
            self.mainTBView.reloadData()
        }
    }
    
    
    var isSearch: Bool = false {
        
        didSet {
            guard !self.isSearch else { return }
            
            self.view.endEditing(true)
            self.dataSourceTemp = self.dataSource
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.tableFooterView = UIView()
        
        //Add ToolBar
        let toolbar = UIToolbar()
        let nextButtonItem = UIBarButtonItem(title: NSLocalizedString("Xong",
                                                                      comment: ""),
                                             style: .done,
                                             target: self,
                                             action: #selector(pinCodeNextAction))
        toolbar.items = [nextButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        self.searchBar.inputAccessoryView = toolbar

        
        self.getData()
    }
    
    @objc private func pinCodeNextAction() {
        self.view.endEditing(true)
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
                guard model.count > 0 else { return }
                self?.dataSource = model
            }
            .catch { error in }
    }
    
    private func getDistricts(cityID: Int16) {
        APIClient.shared.getDistricts(cityID: cityID)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard model.count > 0 else { return }
                self?.dataSource = model
                
            }
            .catch{ error in }
        
        
    }
    
    private func getComunes(districtsID: Int16) {
        APIClient.shared.getCommunes(districtID: districtsID)
            .done(on: DispatchQueue.main) { [weak self]model in
                guard model.count > 0 else { return }
                self?.dataSource = model
            }
            .catch { error in }
        
    }
    

    
}

extension AddressTBViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceTemp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Address_First_TB_Cell", for: indexPath) as! AddressFirstTBCell
        
        let model = self.dataSourceTemp[indexPath.row]
        cell.lblTitleCell.text = model.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.getModel1(model: self.dataSourceTemp[indexPath.row], type: self.type)
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension AddressTBViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.length() > 0 {
            //self.searchBar.showsCancelButton = true
            self.dataSourceTemp = self.dataSource.filter({ (model) -> Bool in
                //Bỏ dấu
                let textFold = model.name!.removeVietnameseMark()
                let serchTextFold = searchText.removeVietnameseMark()
                //let texFoldLower = textFold.lowercased() // Khong viet hoa
                return model.name!.contains(searchText) || textFold.contains(serchTextFold)
            })
        } else {
            //self.searchBar.showsCancelButton = false
            self.dataSourceTemp = self.dataSource
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearch = false
    }
    
    
}




