//
//  BaseViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    
    @IBOutlet var btnContinue: UIButton?
    @IBOutlet var imgBgBtnContinue: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add shadow for button
        if let btn = self.btnContinue {
            btn.dropShadow(color: DISABLE_BUTTON_COLOR)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("----- deinit: \(String(describing: self.self))")
    }
    
    
    /// cho trạng thái enable hay disable button
    ///
    /// - Parameter isEnable: <#isEnable description#>
    func isEnableContinueButton(isEnable: Bool) {
        guard isEnable else {
            if let imgbg = self.imgBgBtnContinue {
                imgbg.image = #imageLiteral(resourceName: "bg_button_disable_login")
            }
            
            if let btn = self.btnContinue {
                btn.dropShadow(color: DISABLE_BUTTON_COLOR)
                btn.isEnabled = false
            }
            
            return
        }
        
        if let imgBg = self.imgBgBtnContinue {
            imgBg.image = #imageLiteral(resourceName: "bg_button_enable_login")
        }
        
        if let btn = self.btnContinue {
            btn.dropShadow(color: MAIN_COLOR)
            btn.isEnabled = true
        }
        
    }
    
    // MARK: - Action
    
    
    @IBAction func btnBackCurrentClicked(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackToRootClicked(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}


