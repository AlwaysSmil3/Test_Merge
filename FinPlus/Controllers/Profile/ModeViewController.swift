//
//  ModeViewController.swift
//  FinPlus
//
//  Created by nghiendv on 25/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ModeViewController: UIViewController {

    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("APP_MODE", comment: "")
        modeSwitch.isOn = UserDefaults.standard.bool(forKey: APP_MODE)
        
        setupMode(mode: UserDefaults.standard.bool(forKey: APP_MODE))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_back(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switch_changed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: APP_MODE)
        UserDefaults.standard.synchronize()
        setupMode(mode: sender.isOn)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ModeNotificationIdentifier), object: nil)
    }
    
    func setupMode(mode: Bool) {
        if (mode)
        {
            self.modeLabel.textColor = DARK_MODE_MAIN_TEXT_COLOR
            self.view.backgroundColor = DARK_MODE_BACKGROUND_COLOR
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = DARK_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = DARK_MODE_MAIN_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: DARK_MODE_MAIN_TEXT_COLOR]
        }
        else
        {
            self.modeLabel.textColor = LIGHT_MODE_MAIN_TEXT_COLOR
            self.view.backgroundColor = LIGHT_MODE_BACKGROUND_COLOR
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = LIGHT_MODE_NAVI_COLOR
            self.navigationController?.navigationBar.tintColor = LIGHT_MODE_MAIN_TEXT_COLOR
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: LIGHT_MODE_MAIN_TEXT_COLOR]
        }
    }
    
}
