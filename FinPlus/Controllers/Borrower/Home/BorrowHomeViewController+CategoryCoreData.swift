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
        
        //self.updateCoreData()
        
//        APIClient.shared.getLoanCategories()
//            .done(on: DispatchQueue.main) { model in
//                print(model)
//                DataManager.shared.loanCategories = model
//                self.mainCollectionView.reloadData()
//
//                self.updateCoreData()
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
    
}
