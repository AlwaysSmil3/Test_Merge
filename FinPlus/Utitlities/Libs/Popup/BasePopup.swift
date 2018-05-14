//
//  BasePopup.swift
//  Ecommerce
//
//  Created by Cao Văn Hải on 1/16/17.
//  Copyright © 2017 VTC. All rights reserved.
//

import Foundation

class BasePopup : BaseViewController {
    
    // MARK: ----------------------Properties & Outlet----------------------
    var completionHandler:(()->Void)?
    
    @IBOutlet var centerView: AnimatableView!
    
    // MARK: ----------------------Life Cycle----------------------
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        centerView.animationType = .zoom(way: .in)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    
    // MARK: ----------------------Action----------------------
    @IBAction func tapGestureBackground(_ sender: Any) {
        
        self.view.endEditing(true)
        self.hide()
    }
    
    // MARK: Method
    
    func show() {
        
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            // Add the alert view controller to the top most UIViewController of the application
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            topViewController.view.endEditing(true)
            
            viewWillAppear(true)
            didMove(toParentViewController: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = topViewController.view.bounds
            
        }
    }
    
    func show(completion: (() -> Void)?)
    {
        
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            // Add the alert view controller to the top most UIViewController of the application
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            topViewController.view.endEditing(true)
            
            viewWillAppear(true)
            didMove(toParentViewController: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = topViewController.view.bounds
            
        }
        
        completionHandler = completion
    }

    
    func hide() {
        
        centerView.animationType = .zoom(way: .out)
        centerView.duration = 0.8
        
        centerView.animate(.zoom(way: .out))
            .completion({
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                //return
            })
    }
    
    // hide with completion handle
    func hide(competionHandle: @escaping () -> Void) {
        centerView.animationType = .zoom(way: .out)
        centerView.duration = 0.8
        
        centerView.animate(.zoom(way: .out))
            .completion({
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                competionHandle()
            })
    }
    
}
