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
    
    var job: Model1?
    var position: Model1?
    
    // Job
 
    var jobData: [Model1] = [] {
        didSet {
            if jobData.count > 0 {
                
            }
        }
    }
    
    // Postion

    var positionData: [Model1] = [] {
        didSet {
            if positionData.count > 0 {
                
            }
        }
    }
    
    var companyAddress: Address?
    
    override func viewDidLoad() {
        self.index = 1
        super.viewDidLoad()
        
        
        self.getJobs()
        self.getPositions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
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
        /*
        guard let addr = self.companyAddress else { return }
        
        DataManager.shared.loanInfo.jobInfo.address = addr
        DataManager.shared.loanInfo.jobInfo.company = self.tfCompanyName.text!
        DataManager.shared.loanInfo.jobInfo.companyPhoneNumber = self.tfCompanyPhone.text!
        DataManager.shared.loanInfo.jobInfo.salary = Int32(self.tfSalary.text!) ?? 0
        
        DataManager.shared.loanInfo.jobInfo.jobType = self.tfJob.text!
        DataManager.shared.loanInfo.jobInfo.position = self.tfPosition.text!
        */
        
        completion()
    }
    
    
    //MARK: Actions

    @IBAction func btnContinueTapped(_ sender: Any) {
        self.updateDataForLoanAPI {
            let loanWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "LIST_WALLET") as! ListWalletViewController
            loanWalletVC.walletAction = .LoanNation
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
        }
        
    }
    
}




