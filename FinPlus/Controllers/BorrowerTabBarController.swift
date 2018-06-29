//
//  BorrowerTabBarController.swift
//  FinPlus
//
//  Created by nghiendv on 08/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

extension UIImage{
    //Draws the top indicator by making image with filling color
    class func drawTabBarIndicator(color: UIColor, size: CGSize, onTop: Bool) -> UIImage {
        let indicatorHeight = size.height / 30
        let yPosition = onTop ? 0 : (size.height - indicatorHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: yPosition, width: size.width, height: indicatorHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

class BorrowerTabBarController: UITabBarController {
    
    /*
     color of the indicator
     */
    @IBInspectable var indicatorColor: UIColor = UIColor()
    
    /*
     determine if the indicator
     will be drawn on top of bar items or not
     */
    @IBInspectable var onTopIndicator: Bool = true
    
    
    //MARK:- View Controller Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Draw Indicator above the tab bar items
//        guard let numberOfTabs = tabBar.items?.count else {
//            return
//        }
//
//        let numberOfTabsFloat = CGFloat(numberOfTabs)
//        let imageSize = CGSize(width: tabBar.frame.width / numberOfTabsFloat, height: tabBar.frame.height)
//
//        let indicatorImage = UIImage.drawTabBarIndicator(color: indicatorColor,
//                                                         size: imageSize,
//                                                         onTop: onTopIndicator)
//        self.tabBar.selectionIndicatorImage = indicatorImage
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let sHomeBrowwer = UIStoryboard(name: "HomeBrowwer", bundle: nil)
        let sHome = UIStoryboard(name: "Loan", bundle: nil)
        let swallet = UIStoryboard.init(name: "Wallet", bundle: nil)
        let sLoanManager = UIStoryboard.init(name: "LoanManager", bundle: nil)
        let sNotification = UIStoryboard.init(name: "Notification", bundle: nil)
        let sProfile = UIStoryboard.init(name: "Profile", bundle: nil)
        
        let v11 = sHomeBrowwer.instantiateViewController(withIdentifier: "BorrowHomeViewControllerNav")
        
        let v1 = sHome.instantiateViewController(withIdentifier: "LOAN_DETAIL_BASE_NAVI")
//        let v1 = sLoanManager.instantiateViewController(withIdentifier: "LOAN_MANAGER_NAVI")

        let v2 = sLoanManager.instantiateViewController(withIdentifier: "LOAN_MANAGER_NAVI")
        let v3 = swallet.instantiateViewController(withIdentifier: "WALLET_NAVI") as! UINavigationController
        v3.topViewController?.navigationItem.leftBarButtonItem = nil
        
        let v4 = sNotification.instantiateViewController(withIdentifier: "NOTIFICATION_NAVI")
        let v5 = sProfile.instantiateViewController(withIdentifier: "PROFILE_NAVI")

        v1.tabBarItem = UITabBarItem(title: NSLocalizedString("LOAN", comment: ""), image: UIImage(named: "ic_tb_brow1"), selectedImage: UIImage(named: "ic_tb_brow1_selected"))
        v2.tabBarItem = UITabBarItem(title: NSLocalizedString("LOAN_MANAGER", comment: ""), image: UIImage(named: "ic_tb_brow2"), selectedImage: UIImage(named: "ic_tb_brow2_selected"))
        v3.tabBarItem = UITabBarItem(title: NSLocalizedString("ACCOUNT_MANAGER", comment: ""), image: UIImage(named: "ic_tb_brow3"), selectedImage: UIImage(named: "ic_tb_brow3_selected"))
        v4.tabBarItem = UITabBarItem(title: NSLocalizedString("NOTIFICATION", comment: ""), image: UIImage(named: "ic_tb_brow5"), selectedImage: UIImage(named: "ic_tb_brow5_selected"))
        v5.tabBarItem = UITabBarItem(title: NSLocalizedString("BRIEF", comment: ""), image: UIImage(named: "ic_tb_brow4"), selectedImage: UIImage(named: "ic_tb_brow4_selected"))
 
        if let activeLoan = DataManager.shared.browwerInfo?.activeLoan, let loanID = activeLoan.loanId, loanID > 0 {
            //Co khoản vay
            let loanState = (v1 as! UINavigationController).topViewController as! LoanStateViewController
            loanState.activeLoan = activeLoan
            loanState.hiddenBack = true
            self.viewControllers = [v1, v2, v3, v4, v5]
        } else {
            //Chưa có Khoản vay
            self.viewControllers = [v11, v2, v3, v4, v5]
        }
    
        
//        for vc in self.viewControllers! {
//            self.formatTabBarItem(tabBarItem: vc.tabBarItem)
//        }
        self.onTopIndicator = true
        self.indicatorColor = .clear
        self.tabBar.tintColor = MAIN_COLOR
        
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = LIGHT_MODE_SUB_TEXT_COLOR
        } else {
            // Fallback on earlier versions
        }
        self.tabBar.backgroundColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:LIGHT_MODE_SUB_TEXT_COLOR, NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_SMALL)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:MAIN_COLOR, NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_SMALL)], for: .selected)
        
        UIApplication.shared.statusBarStyle = .default
        let attributes = [NSAttributedStringKey.foregroundColor: LIGHT_MODE_MAIN_TEXT_COLOR, NSAttributedStringKey.font: UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL) as Any]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().barTintColor = LIGHT_MODE_NAVI_COLOR
        UINavigationBar.appearance().tintColor = LIGHT_MODE_MAIN_TEXT_COLOR
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
    
    func formatTabBarItem(tabBarItem: UITabBarItem){
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .selected)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .normal)
    }
    
}
