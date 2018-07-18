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
    
    
    @IBOutlet weak var heightConstraintContentView: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
            //cập nhật lại Home
            let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
            if let window = UIApplication.shared.delegate?.window, let win = window {
                win.rootViewController = tabbarVC
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.heightConstraintContentView.constant = self.headerView.frame.size.height + self.contentLoanView.frame.size.height - BOUND_SCREEN.size.height + 10
        //self.mainScrollView.contentSize = CGSize(width: BOUND_SCREEN.size.width, height: self.headerView.frame.size.height + self.contentLoanView.frame.size.height + 20)
    }
    
    private func setupUI() {
        guard let brow = DataManager.shared.browwerInfo else { return }
        
        var name = DataManager.shared.currentAccount
        
        if let fullName = brow.fullName, fullName.length() > 0 {
            name = fullName
        }
        
        self.lblTitle.text = "Xin chào " + name + "!"
        
    }
    
    
    //MARK: Actions

    

}


//MARK: UICollectionView Delegate, DataSource

extension BorrowHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollDiff               = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop    : CGFloat = 0
        var absoluteBottom : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        absoluteBottom               = absoluteBottom > 0 ? absoluteBottom : 0
        
        let isScrollingDown          = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp            = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if isScrollingUp {
            //Top
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.lblTitle.text = self.titleTemp
                self.lblHeader1.text = "Bạn muốn vay để làm gì?"
                self.lblHeader2.text = "Hãy lựa chọn cho mình một khoản vay phù hợp trong danh sách dưới đây."
                self.view.layoutIfNeeded()
            }) { (status) in
                
            }
            
        } else if isScrollingDown {
            //Down

            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.lblTitle.text = nil
                self.lblHeader1.text = nil
                self.lblHeader2.text = nil
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                
            })
        }
        
        self.previousScrollOffset = scrollView.contentOffset.y
        
        
    }
    */
    
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
        
        DataManager.shared.currentIndexCategoriesSelectedPopup = indexPath.row
        
        if let value = userDefault.value(forKey: kUserDefault_Aler_Popup_Confirm_Loan) as? String, value == "1" {
            //Đã hiện popup rồi, người dùng chọn k cần hiện nữa
            self.gotoLoanFirstVC()
        } else {
            let popupConfirm = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "AlertConfirmCreateLoanPopup") as! AlertConfirmCreateLoanPopup
            popupConfirm.delegate = self
            
            popupConfirm.show()
        }

    }
    
    func gotoLoanFirstVC() {
        let loanFirstVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanFirstViewController") as! LoanFirstViewController
        
        loanFirstVC.hidesBottomBarWhenPushed = true
        loanFirstVC.loanCategory = DataManager.shared.loanCategories[DataManager.shared.currentIndexCategoriesSelectedPopup ?? 0]
        
        self.navigationController?.pushViewController(loanFirstVC, animated: true)
    }
    
    
}

//MARK: AlertAggreeCreateLoanDelegate
extension BorrowHomeViewController: AlertAggreeCreateLoanDelegate {
    func confirmAggree() {
        self.gotoLoanFirstVC()
        
    }
}





