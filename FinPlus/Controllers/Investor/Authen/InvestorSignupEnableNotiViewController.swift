//
//  InvestorSignupEnableNotiViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class InvestorSignupEnableNotiViewController: UIViewController {

    @IBOutlet weak var showNotiSettingBtn: UILabel!
    @IBOutlet weak var dissmissBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNotiSettingAction(_ sender: Any) {
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
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
        }
    }
    @IBAction func dissmissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
