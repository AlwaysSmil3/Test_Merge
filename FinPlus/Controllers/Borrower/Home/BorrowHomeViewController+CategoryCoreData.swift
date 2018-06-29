//
//  BorrowHomeViewController+CategoryCoreData.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/18/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreData

extension BorrowHomeViewController {
    
    // Lấy danh sách các loại khoản vay
    func getLoanCategories() {
        
        guard DataManager.shared.isUpdateFromConfig || DataManager.shared.loanCategories.count == 0 else { return }
        //Có thay đổi cần cập nhật lại dữ liệu
        
        APIClient.shared.getLoanCategories()
            .done(on: DispatchQueue.main) { model in
                print(model)
                DataManager.shared.loanCategories = model
                self.mainCollectionView.reloadData()
                
                self.updateCoreData()
                
            }
            .catch { error in }
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
    
    /*
    /// Lấy dữ liệu từ CoreData
    ///
    /// - Parameter completion: <#completion description#>
    func fetchCoreData(completion: () -> Void) {
        guard let context = self.managedContext else { return }
        //Lay list entity
        let list = FinPlusHelper.fetchRecordsForEntity("LoanCategory", inManagedObjectContext: context)
        
        guard list.count > 0 else { return }
        
        DataManager.shared.loanCategories.removeAll()
        
        for entity in list {
            
            var loan = LoanCategories(object: NSObject())
            
            if let title = entity.value(forKey: CDLoanCategoryTitle) as? String {
                loan.title = title
            }
            if let desc = entity.value(forKey: CDLoanCategoryDescription) as? String {
                loan.descriptionValue = desc
            }
            if let id = entity.value(forKey: CDLoanCategoryID) as? Int16 {
                loan.id = id
            }
            if let max = entity.value(forKey: CDLoanCategoryMax) as? Int32 {
                loan.max = max
            }
            if let min = entity.value(forKey: CDLoanCategoryMin) as? Int32 {
                loan.min = min
            }
            if let termMax = entity.value(forKey: CDLoanCategoryTermMax) as? Int16 {
                loan.termMax = termMax
            }
            if let termMin = entity.value(forKey: CDLoanCategoryTermMin) as? Int16 {
                loan.termMin = termMin
            }
            if let interestRate = entity.value(forKey: CDLoanCategoryInterestRate) as? Double {
                loan.interestRate = interestRate
            }
            if let url = entity.value(forKey: CDLoanCategoryImageURL) as? String {
                loan.imageUrl = url
            }
            
            DataManager.shared.loanCategories.append(loan)
            
        }
        
        completion()
        
    }
    */
    
    
    
    
}
