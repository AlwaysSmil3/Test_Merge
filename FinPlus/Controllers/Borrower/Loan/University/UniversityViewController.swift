//
//  UniversityViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/6/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import MYTableViewIndex

protocol UniversitySelectionDelegate {
    func universitySelected(model: UniversityModel)
}

class UniversityViewController: BaseViewController {
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableViewIndex: TableViewIndex!
    
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
        
//        self.tableViewIndex.delegate = self
//        self.tableViewIndex.dataSource = self
        self.tableViewIndex.isHidden = true
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

//MARK: TableViewIndexDataSource, TableViewIndexDelegate
extension UniversityViewController: TableViewIndexDataSource, TableViewIndexDelegate {
    
    func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {
        let items = UILocalizedIndexedCollation.current().sectionIndexTitles.map{ title -> UIView in
            return StringItem(text: title)
        }
//        if hasSearchIndex {
//            items.insert(SearchItem(), at: 0)
//        }
        return items
    }
    
    func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {
        let originalOffset = self.mainTableView.contentOffset
        
//        if item is SearchItem {
//            self.mainTableView.scrollRectToVisible(searchController.searchBar.frame, animated: false)
//        } else {
            //let sectionIndex = hasSearchIndex ? index - 1 : index
            let sectionIndex = index
            let rowCount = self.mainTableView.numberOfRows(inSection: sectionIndex)
            let indexPath = IndexPath(row: rowCount > 0 ? 0 : NSNotFound, section: sectionIndex)
            self.mainTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        //}
        return self.mainTableView.contentOffset != originalOffset
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

