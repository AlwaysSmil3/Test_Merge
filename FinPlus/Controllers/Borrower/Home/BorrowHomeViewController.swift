//
//  BorrowHomeViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreData
import SDWebImage

class BorrowHomeViewController: BaseViewController {
    
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var contentLoanView: UIView!
    @IBOutlet var mainCollectionView: UICollectionView!
    
    @IBOutlet var headerView: UIView!
    
    // Loan status cho các trạng thái của Loan
    var loanStatus: Int = DataManager.shared.browwerInfo?.activeLoan?.status ?? -1 {
        didSet {
            
        }
    }
    // CoreData
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //Lấy data Local
        if let context = self.managedContext {
            FinPlusHelper.fetchCoreData(context: context) {
                self.mainCollectionView.reloadData()
            }
        }

        self.getLoanCategories()

        self.setupUI()
        
        //Map DataLoan
        DataManager.shared.mapDataBrowwerAndLoan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupUI() {
        guard let brow = DataManager.shared.browwerInfo else { return }
        self.lblTitle.text = "Xin chào " + (brow.fullName ?? "") + "!"
    }
    
    
    //MARK: Actions

    

}


//MARK: UICollectionView Delegate, DataSource

extension BorrowHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.loanCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home_Brower_Collection_Cell", for: indexPath) as! HomeBrowerCollectionCell
        
        let model = DataManager.shared.loanCategories[indexPath.row]
        
        let urlString = hostLoan + model.imageUrl!
        let url = URL(string: urlString)
        cell.imgIcon.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_homeBrower_group1"))
        cell.lblName.text = FinPlusHelper.addCharactorToString(input: model.title!)
        cell.lblDistanceAmount.text = "\(model.min! / MONEY_TERM_DISPLAY)-\(model.max! / MONEY_TERM_DISPLAY) triệu"
        
        return cell
    }
    
    /**
     * Initial size
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return FinPlusHelper.setCellSizeDisplayFitThird(indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard DataManager.shared.loanCategories.count > 0 else { return }
        
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[indexPath.row]
        DataManager.shared.currentIndexCategoriesSelectedPopup = indexPath.row
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    
}




