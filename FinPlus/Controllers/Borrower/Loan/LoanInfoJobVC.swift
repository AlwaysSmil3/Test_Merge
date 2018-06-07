//
//  LoanInfoJobVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/21/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import DropDown

class LoanInfoJobVC: LoanBaseViewController {
    
    
    @IBOutlet var btnPosition: UIButton!
    @IBOutlet var tfPosition: UITextField!
    @IBOutlet var btnJob: UIButton!
    @IBOutlet var tfJob: UITextField!
    
    @IBOutlet var tfCompanyName: UITextField!
    @IBOutlet var tfSalary: UITextField!
    @IBOutlet var tfCompanyPhone: UITextField!
    @IBOutlet var lblCompanyAddress: UILabel!
    
    var job: Model1?
    var position: Model1?
    
    // Job
    let jobDropdown = DropDown()
    var jobData: [Model1] = [] {
        didSet {
            if jobData.count > 0 {
                self.jobDropdown.dataSource = jobData.map { $0.name! }
            }
        }
    }
    
    // Postion
    let positionDropdown = DropDown()
    var positionData: [Model1] = [] {
        didSet {
            if positionData.count > 0 {
                self.positionDropdown.dataSource = positionData.map { $0.name! }
            }
        }
    }
    
    var companyAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDropdown()
        
        self.getJobs()
        self.getPositions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    //MARK: Setup Dropdown
    
    private func setupDropdown() {
        
        //Job
        self.jobDropdown.anchorView = self.btnJob
        self.jobDropdown.dataSource = []
        
        self.jobDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.job = self.jobData[index]
            self.tfJob.text = item
        }
        
        //Position
        self.positionDropdown.anchorView = self.btnPosition
        self.positionDropdown.dataSource = []
        
        self.positionDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.position = self.positionData[index]
            self.tfPosition.text = item
        }
    }

    
    //MARK: Get API
    private func getJobs() {
        APIClient.shared.getJobs()
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.jobData = model
            }
            .catch { error in }
    }
    
    private func getPositions() {
        APIClient.shared.getPositions()
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.positionData = model
            }
            .catch { error in }
    }
    
    private func updateDataForLoanAPI(completion: () -> Void) {
        guard let addr = self.companyAddress else { return }
        
        DataManager.shared.loanInfo.jobInfo.address = addr
        DataManager.shared.loanInfo.jobInfo.company = self.tfCompanyName.text!
        DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = self.tfCompanyPhone.text!
        DataManager.shared.loanInfo.jobInfo.salary = Int32(self.tfSalary.text!) ?? 0
        
        DataManager.shared.loanInfo.jobInfo.jobType = self.tfJob.text!
        DataManager.shared.loanInfo.jobInfo.position = self.tfPosition.text!
        
        completion()
    }
    
    
    //MARK: Actions
    @IBAction func btnJobTapped(_ sender: Any) {
        self.jobDropdown.show()
    }
    
    
    @IBAction func btnPositionTapped(_ sender: Any) {
        self.positionDropdown.show()
    }
    
    
    @IBAction func btnCompanyAddressTapped(_ sender: Any) {
        let firstAddressVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressFirstViewController") as! AddressFirstViewController
        firstAddressVC.delegate = self
        
        self.navigationController?.pushViewController(firstAddressVC, animated: true)
        
    }
    
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        self.updateDataForLoanAPI {
            let loanWalletVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanWalletViewController") as! LoanWalletViewController
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
        }
        
    }
    
    
}

extension LoanInfoJobVC: AddressDelegate {
    
    func getAddress(address: Address, type: Int) {
        let addr = address.commune + ", " + address.district + ", " + address.city
        self.lblCompanyAddress.text = addr
        self.companyAddress = address
    }
    
}



