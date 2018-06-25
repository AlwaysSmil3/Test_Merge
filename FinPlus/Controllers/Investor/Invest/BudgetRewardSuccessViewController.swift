//
//  BudgetRewardSuccessViewController.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/25/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class BudgetRewardSuccessViewController: UIViewController {

    @IBOutlet weak var backToHomeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backToHomeBtn.layer.cornerRadius = 5
        backToHomeBtn.layer.borderWidth = 1
        backToHomeBtn.layer.borderColor = UIColor(hexString: "#3EAA5F").cgColor

        // Do any additional setup after loading the view.
    }

    @IBAction func backToHomeAction(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
