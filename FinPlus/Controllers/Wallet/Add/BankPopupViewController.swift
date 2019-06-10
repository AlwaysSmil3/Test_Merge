//
//  BankPopupViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 11/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

protocol BankPopupSelectedProtocol: class {
    func bankSelected(bank: Bank, index: Int)
}

class BankPopupViewController: BasePopup {
    
    @IBOutlet weak var mainTBView: UITableView!
    
    /// Cell đang chọn
    var currentIndex: Int?
    var dataSource: [Bank] = []
    
    weak var bankSelectedDelegate: BankPopupSelectedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTBView.register(UINib(nibName: "BankPopupTBCell", bundle: nil), forCellReuseIdentifier: "BankPopupTBCell")
        self.mainTBView.separatorColor = UIColor.clear
        self.mainTBView.rowHeight = UITableViewAutomaticDimension
        self.mainTBView.tableFooterView = UIView()
        
        if let data = DataManager.shared.listBankData {
            self.dataSource = data
        } else {
            self.getBanks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToSelection()
        }
    }
    
    private func getBanks() {
        APIClient.shared.getBanks()
            .done(on: DispatchQueue.main) { [weak self] model in
                guard model.count > 0 else { return }
                self?.dataSource.append(contentsOf: model)
                self?.mainTBView.reloadData()
                self?.scrollToSelection()
                DataManager.shared.listBankData = model
            }
            .catch { error in }
    }
    
    func scrollToSelection() {
        if let index = self.currentIndex {
            self.mainTBView?.scrollToRow(at: IndexPath(row: index, section: 0), at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    //MARK: Actions
    @IBAction func btnExistTapped(_ sender: Any) {
        self.hide {
            
        }
    }
    
    @IBAction func btnAgreeTapped(_ sender: Any) {
        guard let index = self.currentIndex else {
            self.showToastWithMessage(message: "Vui lòng chọn ngân hàng")
            return
        }
        self.hide {
            guard index < self.dataSource.count else { return }
            self.bankSelectedDelegate?.bankSelected(bank: self.dataSource[index], index: index)
        }
    }
    
}

extension BankPopupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankPopupTBCell", for: indexPath) as! BankPopupTBCell
        cell.data = self.dataSource[indexPath.row]
        guard let i = self.currentIndex, i == indexPath.row else {
            cell.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_off")
            return cell
        }

        cell.iconSelected?.image = #imageLiteral(resourceName: "ic_radio_on")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentIndex != indexPath.row {
            self.currentIndex = indexPath.row
            self.mainTBView.reloadData()
        }
    }
    
}
