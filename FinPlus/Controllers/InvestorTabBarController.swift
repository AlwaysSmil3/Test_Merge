//
//  InvestorTabBarController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorTabBarController: UITabBarController {

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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ModeNotificationIdentifier), object: nil, queue: nil, using: { (notification) in
            self.setupMode()
        })

        let investStoryboard = UIStoryboard.init(name: "Invest", bundle: nil)
        let sProfile = UIStoryboard.init(name: "Profile", bundle: nil)

        let v1 = investStoryboard.instantiateViewController(withIdentifier: "INVEST_NAVI")
        let v2 = investStoryboard.instantiateViewController(withIdentifier: "INVEST_NAVI")
        let v3 = investStoryboard.instantiateViewController(withIdentifier: "INVEST_NAVI")
        let v4 = investStoryboard.instantiateViewController(withIdentifier: "INVEST_NAVI")
        
        let v5 = sProfile.instantiateViewController(withIdentifier: "PROFILE_NAVI")  as! UINavigationController
        let vc = v5.topViewController as! ProfileViewController
        vc.isInvestor = true
        
        v1.tabBarItem = UITabBarItem(title: NSLocalizedString("LOAN", comment: ""), image: UIImage(named: "ic_tb_brow1"), selectedImage: UIImage(named: "ic_tb_brow1_selected"))
        v2.tabBarItem = UITabBarItem(title: NSLocalizedString("LOAN_MANAGER", comment: ""), image: UIImage(named: "ic_tb_brow2"), selectedImage: UIImage(named: "ic_tb_brow2_selected"))
        v3.tabBarItem = UITabBarItem(title: NSLocalizedString("ACCOUNT_MANAGER", comment: ""), image: UIImage(named: "ic_tb_brow3"), selectedImage: UIImage(named: "ic_tb_brow3_selected"))
        v4.tabBarItem = UITabBarItem(title: NSLocalizedString("NOTIFICATION", comment: ""), image: UIImage(named: "ic_tb_brow4"), selectedImage: UIImage(named: "ic_tb_brow4_selected"))
        v5.tabBarItem = UITabBarItem(title: NSLocalizedString("BRIEF", comment: ""), image: UIImage(named: "ic_tb_brow4"), selectedImage: UIImage(named: "ic_tb_brow4_selected"))

        self.viewControllers = [v1, v2, v3, v4, v5]

        //        for vc in self.viewControllers! {
        //            self.formatTabBarItem(tabBarItem: vc.tabBarItem)
        //        }
        
        self.onTopIndicator = true
        self.indicatorColor = .clear
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = MAIN_COLOR
        
        setupMode()
    }
    
    func setupMode() {
        let mode = UserDefaults.standard.bool(forKey: APP_MODE)
        
        if (mode)
        {
            if #available(iOS 10.0, *) {
                self.tabBar.unselectedItemTintColor = DARK_MODE_MAIN_TEXT_COLOR
            } else {
                // Fallback on earlier versions
            }
            
            self.tabBar.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            self.tabBar.barTintColor = DARK_MODE_BACKGROUND_COLOR
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:DARK_MODE_MAIN_TEXT_COLOR, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11)], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:MAIN_COLOR, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11)], for: .selected)
        }
        else
        {
            if #available(iOS 10.0, *) {
                self.tabBar.unselectedItemTintColor = BAR_DEFAULT_COLOR
            } else {
                // Fallback on earlier versions
            }
            
            self.tabBar.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            self.tabBar.barTintColor = LIGHT_MODE_BACKGROUND_COLOR
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:LIGHT_MODE_MAIN_TEXT_COLOR, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11)], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:MAIN_COLOR, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 11)], for: .selected)
        }
    }

    func formatTabBarItem(tabBarItem: UITabBarItem){
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .selected)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .normal)
    }

}
