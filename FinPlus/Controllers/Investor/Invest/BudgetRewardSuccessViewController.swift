//
//  BudgetRewardSuccessViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BudgetRewardSuccessViewController: UIViewController {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var headerLb: UILabel!
    @IBOutlet weak var backToHomeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backToHomeBtn.layer.cornerRadius = 5
        backToHomeBtn.layer.borderWidth = 1
        backToHomeBtn.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: APP_MODE) {
            self.view.backgroundColor = DARK_BACKGROUND_COLOR
            self.headerLb.textColor = DARK_BODY_TEXT_COLOR
            self.titleLb.textColor = DARK_SUBTEXT_COLOR
        } else {
            self.view.backgroundColor = LIGHT_BACKGROUND_COLOR
            self.headerLb.textColor = LIGHT_BODY_TEXT_COLOR
            self.titleLb.textColor = LIGHT_SUBTEXT_COLOR
        }
    }

    @IBAction func backToHomeAction(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }


}
