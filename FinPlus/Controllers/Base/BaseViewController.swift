//
//  BaseViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreLocation

class BaseViewController: UIViewController {
    
    @IBOutlet var btnContinue: UIButton?
    @IBOutlet var imgBgBtnContinue: UIImageView?
    @IBOutlet var errorConnectView: UIView?
    
    //Current Location
    var locationManager: CLLocationManager?
    
    func setupTitleView(title: String, subTitle: String? = nil) {
        let topText = NSLocalizedString(title, comment: "")
        
        let titleParameters = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#08121E"),
                               NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_BOLD, size: 17)]
        let subtitleParameters = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#4D6678"),
                                  NSAttributedStringKey.font : UIFont(name: FONT_FAMILY_REGULAR, size: 11)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters as [NSAttributedStringKey : Any])
        
        if let sub = subTitle {
            let bottomText = NSLocalizedString(sub, comment: "")
            let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters as [NSAttributedStringKey : Any])
            
            title.append(NSAttributedString(string: "\n"))
            title.append(subtitle)
        }
        
        let size = title.size()
        
        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        self.navigationItem.titleView = titleLabel
    }
    
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
    
    func initLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        
        // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    /// cho trạng thái enable hay disable button
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
    
    @IBAction func btnBackCurrentClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackToRootClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Goto App Investor
    func gotoAppInvestor() {
        if let url = URL(string: "monyInvestor://") {
            if UIApplication.shared.canOpenURL(url) {
                //da cai app
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                //chua cai app
                if let link = URL(string: "") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(link, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(link)
                    }
                }
            }
        }
    }
    
    /// show nack View
    func showSnackView(message: String, titleButton: String, completion: @escaping () -> Void) {
        // Present a snack to allow the user to undo this action
        let snack = LPSnackbar(title: message, buttonTitle: titleButton)
        snack.view.backgroundColor = UIColor(hexString: "#242424")
        
        // Show the snack
        snack.show(animated: true) { undone in
            // The snack has finished showing, we get back a boolean value which tells us
            // whether user tapped the button or not
            guard undone else { return }
            completion()
        }
    }
    
    func checkLocationsIsValid(completion: () -> Void) {
        guard let _ = DataManager.shared.currentLocation else {
            self.showGreenBtnMessage(title: "Không thể xác minh vị trí", message: "Rất tiếc! thiết bị không thể lấy được vị trí hiện tại của bạn. Vui lòng thử lại sau!", okTitle: "Đóng", cancelTitle: nil)
            return
        }
        completion()
    }
    
}

//MARK: CLLocationManagerDelegate
extension BaseViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        DataManager.shared.currentLocation = locValue
    }
}
