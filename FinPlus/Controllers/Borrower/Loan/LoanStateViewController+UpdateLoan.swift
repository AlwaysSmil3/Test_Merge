//
//  LoanStateViewController+UpdateLoan.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/29/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreData

extension LoanStateViewController {
    
    // Lấy danh sách các loại khoản vay
    func getLoanCategories() {
        
//        guard DataManager.shared.isUpdateFromConfig || DataManager.shared.loanCategories.count == 0 else { return }
        //Có thay đổi cần cập nhật lại dữ liệu
        
        //self.updateCoreData()

        
//        APIClient.shared.getLoanCategories()
//            .done(on: DispatchQueue.main) { model in
//                print(model)
//                //DataManager.shared.loanCategories = model
//
//                //self.updateCoreData()
//
//            }
//            .catch { error in }
    }
    
    func updateCoreData() {
        guard let context = self.managedContext else { return }
        
        //Lay list entity
        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
        let entity = NSEntityDescription.entity(forEntityName: "LoanCategory", in: context)
        
        if list.count > 0 {
            //Xoa dữ liệu hiện tại
            for i in list {
                context.delete(i)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
            
        }
        
        // Cập nhật dữ liệu mới
        for data in DataManager.shared.loanCategories {
            
            let categoryEntity = NSManagedObject(entity: entity!, insertInto: self.managedContext)
            
            categoryEntity.setValue(data.id, forKey: CDLoanCategoryID)
            categoryEntity.setValue(data.title, forKey: CDLoanCategoryTitle)
            categoryEntity.setValue(data.descriptionValue, forKey: CDLoanCategoryDescription)
            categoryEntity.setValue(data.min, forKey: CDLoanCategoryMin)
            categoryEntity.setValue(data.max, forKey: CDLoanCategoryMax)
            categoryEntity.setValue(data.termMin, forKey: CDLoanCategoryTermMin)
            categoryEntity.setValue(data.termMax, forKey: CDLoanCategoryTermMax)
            categoryEntity.setValue(data.interestRate, forKey: CDLoanCategoryInterestRate)
            categoryEntity.setValue(data.imageUrl, forKey: CDLoanCategoryImageURL)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func getPaymentInfo(completion: @escaping() -> Void) {
        APIClient.shared.getPaymentMoneyInfo()
            .done(on: DispatchQueue.global()) { [weak self]model in
                
                DispatchQueue.main.async {
                    self?.paymentInfo = model
                    completion()
                }
                
            }
            .catch { error in completion() }
    }
    
    func addBankTotDataSource() {
        // get loan bank
        let loanBankId = DataManager.shared.loanInfo.bankId
        if let userBanks = DataManager.shared.browwerInfo?.banks {
            for bank in userBanks {
                if let bankId = bank.id {
                    if bankId == loanBankId {
                        let accountNumber = bank.accountBankNumber ?? ""
                        //                        if let number = bank.accountBankNumber, number.count > 4 {
                        //                            accountNumber = String(number.suffix(4))
                        //                        } else {
                        //                            accountNumber = bank.accountBankNumber ?? ""
                        //                        }
                        //                        accountNumber = "● ● ● ● \(accountNumber)"
                        
                        //                        let subtitleParameters = [NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 12)]
                        
                        let bankName = bank.bankName ?? ""
                        let prefixBankName = FinPlusHelper.getPrefixBankName(bankName: bankName)
                        
                        
                        dataSource.append(LoanSummaryModel(name: "Tài khoản nhận tiền", value: prefixBankName + bankName, attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Chủ tài khoản", value: "\(bank.accountBankName ?? "None")", attributed: nil))
                        dataSource.append(LoanSummaryModel(name: "Số tài khoản", value: accountNumber, attributed: nil))
                        
                    }
                }
            }
        }
    }
    
    // Hoan thien don
    @IBAction func update_loan()
    {
        guard DataManager.shared.loanCategories.count > 0 else { return }
        guard let _ = DataManager.shared.browwerInfo else { return }
        
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.getCurrentCategory()
        //DataManager.shared.currentIndexCategoriesSelectedPopup = 0
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    @IBAction func update_loan_MissData()
    {
        
        if DataManager.shared.listKeyMissingLoanKey == nil || DataManager.shared.listKeyMissingLoanKey!.count == 0 {
 
            //Khi user da nhap het rồi thì chuyển trạng thái luôn
            updateLoanStatusInvalidData()
            return
        }
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        guard let _ = DataManager.shared.browwerInfo else { return }
        
        self.gotoFirstVCHaveInvalidData()
    }
    
    func gotoFirstVCHaveInvalidData() {
        
        guard let indexVC = DataManager.shared.getStartIndexHaveMissingData() else {
            let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
            loanPersionalInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
            
            return
        }
        
        switch indexVC {
        case 2:
            let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
            loanPersionalInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
            
            break
        case 3:
            let loanInfoJobVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanInfoJobVC") as! LoanInfoJobVC
            loanInfoJobVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController( loanInfoJobVC, animated: true)
            
            break
        case 4:
            let loanWalletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "LIST_WALLET") as! ListWalletViewController
            loanWalletVC.walletAction = .LoanNation
            loanWalletVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            
            self.navigationController?.pushViewController(loanWalletVC, animated: true)
            
            break
        case 5:
            let loanNationalIDVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanNationalIDViewController") as! LoanNationalIDViewController
            loanNationalIDVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(loanNationalIDVC, animated: true)
            
            break
        case 6:
            let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
            
            loanOtherInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            
            self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
            
            break
        default:
            let loanPersionalInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanPersionalInfoVC") as! LoanPersionalInfoVC
            loanPersionalInfoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(loanPersionalInfoVC, animated: true)
            
            break
        }
        
        
        
        
    }
    
    
    
}
