//
//  ConfirmRateSuccessViewController.swift
//  FinPlus
//
//  Created by nghiendv on 22/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import CoreLocation

class ConfirmRateSuccessViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var btnComeHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnComeHome.layer.cornerRadius = 8
        self.btnComeHome.layer.masksToBounds = true
        self.btnComeHome.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        
        self.titleLabel.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_BIG)
        self.desLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initLocationManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPermissionLocation(completion: () -> Void) {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            // For use in foreground
            self.initLocationManager()
            return
        }
        
        if status == .denied || status == .restricted {
            let message = "Để xác nhận lãi suất, Mony cần biết chính xác vị trí hiện tại của bạn. Vui lòng bật các dịch vụ định vị GPS để hoàn thiện đơn vay."
            
            self.showAlertView(title: "Không tìm thấy địa điểm", message: message, okTitle: "Bật định vị", cancelTitle: nil, completion: { (bool) in
                
                guard bool else {
                    return
                }
                
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(settingsUrl)
                        }
                    }
                }
            })
            return
        }
        
        self.checkLocationsIsValid {
            completion()
        }
    }
    
    
    @IBAction func comHome(_ sender: Any) {
        self.getPermissionLocation {
            DataManager.shared.loanInfo.status = STATUS_LOAN.RAISING_CAPITAL.rawValue
            APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
                .done(on: DispatchQueue.main) { model in
                    DataManager.shared.loanID = model.loanId!
                    
                    //Lay thong tin nguoi dung
                    APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                        .done(on: DispatchQueue.main) { model in
                            DataManager.shared.browwerInfo = model
                            let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                            if let window = UIApplication.shared.delegate?.window, let win = window {
                                win.rootViewController = tabbarVC
                            }
                        }
                        .catch { error in }
                }
                .catch { error in }
        }
    }

}
