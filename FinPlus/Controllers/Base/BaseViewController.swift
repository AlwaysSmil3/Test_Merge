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
        
        if let btn = self.btnContinue {
            btn.dropShadow(color: DISABLE_BUTTON_COLOR)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("----- deinit: \(String(describing: self.self))")
    }
    
    // MARK: - Action
    
    
    @IBAction func btnBackCurrentClicked(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackToRootClicked(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}


