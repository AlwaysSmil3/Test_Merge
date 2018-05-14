//
//  ExUIViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // MARK: ------------Toast------------
    func showToastWithMessage(message: String?) {
        
        UIViewController.showToastWithMessage(message: message)
    }
    
    static func showToastWithMessage(message: String?) {
        ToastCenter.default.cancelAll()
        
        let toast = Toast(text: message, delay: 0, duration: Delay.short)
        toast.show()
    }
    
    
    //MARK:----------------- Show Alert View----------------------
    func showAlertView(title: String, message: String, okTitle: String?, cancelTitle: String?, completion:((_ isPressedOK: Bool) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (okTitle != nil) {
            let okAction = UIAlertAction(title: okTitle, style: .default, handler: { (result: UIAlertAction) in
                print("OK")
                completion?(true)
            })
            
            alert.addAction(okAction)
        }
        
        if (cancelTitle != nil) {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (result: UIAlertAction) in
                print("Cancel")
                completion?(false)
            })
            
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
