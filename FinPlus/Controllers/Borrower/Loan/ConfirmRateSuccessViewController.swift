//
//  ConfirmRateSuccessViewController.swift
//  FinPlus
//
//  Created by nghiendv on 22/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ConfirmRateSuccessViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var btnComeHome: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnComeHome.layer.cornerRadius = 8
        self.btnComeHome.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comHome(_ sender: Any) {
        let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(tabbarVC, animated: true)
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
