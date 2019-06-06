//
//  UniversityViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/6/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol UniversitySelectionDelegate {
    func universitySelected(model: UniversityModel)
}

class UniversityViewController: BaseViewController {
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var dataSource: [UniversityModel] = [] {
        didSet {
            self.dataSourceTemp = self.dataSource
        }
    }
    var dataSourceTemp: [UniversityModel] = [] {
        didSet {
            self.mainTableView.reloadData()
        }
    }
    
    var delegateUniversity: UniversitySelectionDelegate?
    
    var isSearch: Bool = false {
        
        didSet {
            guard !self.isSearch else { return }
            
            self.view.endEditing(true)
            self.dataSourceTemp = self.dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTableView.tableFooterView = UIView()
        
        self.getDataUniversityFromJSON()
        
        let toolbar = UIToolbar()
        let nextButtonItem = UIBarButtonItem(title: NSLocalizedString("Xong",
                                                                      comment: ""),
                                             style: .done,
                                             target: self,
                                             action: #selector(doneAction))
        toolbar.items = [nextButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        self.searchBar.inputAccessoryView = toolbar
    }
    
    @objc private func doneAction() {
        self.view.endEditing(true)
    }
    
    /// Get Data from JSON
    func getDataUniversityFromJSON() {
        if let path = Bundle.main.path(forResource: "university", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Any] {
                    // do stuff
                    var list: [UniversityModel] = []
                    
                    jsonResult.forEach({ (data) in
                        let university = UniversityModel(object: data)
                        list.append(university)
                    })
                    
                    self.dataSource = list
                    
                }
            } catch {
                // handle error
            }
        }
    }
    
    
    
    
    
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension UniversityViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        self.delegateUniversity?.universitySelected(model: self.dataSourceTemp[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


//MARK: UISearchBarDelegate
extension UniversityViewController: UISearchBarDelegate {
    
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

