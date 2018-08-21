//
//  ExUIViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
//import NVActivityIndicatorView
import SVProgressHUD

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
    
    func handleDataNoti() {
        guard let alert = DataManager.shared.notificationData else { return }
        if let body = alert["body"] as? String, let title = alert["title"] as? String {
            DataManager.shared.notificationData = nil
            self.showAlertView(title: title, message: body, okTitle: "OK", cancelTitle: nil)
        }
    }
    
    
    func reLoadStatusLoanVC() {
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.isNeedReloadLoanStatusVC = false
                DataManager.shared.browwerInfo = model
                
                let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                if let window = UIApplication.shared.delegate?.window, let win = window {
                    win.rootViewController = tabbarVC
                }
                
            }
            .catch { error in
                
        }
    }
    
    //MARK:----------------- Show Alert View----------------------
    func showAlertView(title: String, message: String, okTitle: String?, cancelTitle: String?, completion:((_ isPressedOK: Bool) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (cancelTitle != nil) {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: { (result: UIAlertAction) in
                print("Cancel")
                completion?(false)
            })
            
            alert.addAction(cancelAction)
        }
        if (okTitle != nil) {
            let okAction = UIAlertAction(title: okTitle, style: .destructive, handler: { (result: UIAlertAction) in
                print("OK")
                completion?(true)
            })
            
            alert.addAction(okAction)
        }
        
        
        self.present(alert, animated: true, completion: nil)
    }

    func showGreenBtnMessage(title: String, message: String, okTitle: String?, cancelTitle: String?, completion:((_ isPressedOK: Bool) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        if (cancelTitle != nil) {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: { (result: UIAlertAction) in
                print("Cancel")
                completion?(false)
            })
            cancelAction.setValue(MAIN_COLOR, forKey: "titleTextColor")
            alert.addAction(cancelAction)
        }
        
        if (okTitle != nil) {
            let okAction = UIAlertAction(title: okTitle, style: .destructive, handler: { (result: UIAlertAction) in
                print("OK")
                completion?(true)
            })
            okAction.setValue(MAIN_COLOR, forKey: "titleTextColor")
            
            alert.addAction(okAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLoadingView(isShow: Bool) {
        if isShow {
            self.showLoadingView()
        } else {
            self.hideLoadingView()
        }
    }
    
    // Show loading view
    private func showLoadingView() {
        SVProgressHUD.show(withStatus: "Mony...")
        
    }
    
    // Hide
    private func hideLoadingView() {
        SVProgressHUD.dismiss()
    }
    
}

/*
extension UIViewController: NVActivityIndicatorViewable {
    
    // MARK: Indicator view
    func handleLoadingView(isShow: Bool) {
        if isShow {
            self.showLoadingView()
        } else {
            self.hideLoadingView()
        }
    }
    
    // Show loading view
    private func showLoadingView() {
        SVProgressHUD.show(withStatus: "Mony...")
//        let size = CGSize(width: 30, height:30)
//        startAnimating(size, message: "", type: .ballScaleMultiple)
    }
    
    // Hide
    private func hideLoadingView() {
        //stopAnimating()
        SVProgressHUD.dismiss()
    }
    
    
}
*/
