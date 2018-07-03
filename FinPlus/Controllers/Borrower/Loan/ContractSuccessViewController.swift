//
//  ContractSuccessViewController.swift
//  FinPlus
//
//  Created by nghiendv on 21/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class ContractSuccessViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var btnComeHome: UIButton!
    @IBOutlet weak var btnReviewContract: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnComeHome.layer.cornerRadius = 8
        self.btnComeHome.layer.masksToBounds = true
        self.btnComeHome.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        
        self.titleLabel.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_BIG)
        self.desLabel.font = UIFont(name: FONT_FAMILY_REGULAR, size: FONT_SIZE_SEMIMALL)
        self.btnReviewContract.titleLabel?.font = UIFont(name: FONT_FAMILY_SEMIBOLD, size: FONT_SIZE_NORMAL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comHome(_ sender: Any) {
        
        //Lay thong tin nguoi dung
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.browwerInfo = model
                
                let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                if let window = UIApplication.shared.delegate?.window, let win = window {
                    win.rootViewController = tabbarVC
                }
                
            }
            .catch { error in
                
        }
        
//        let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    @IBAction func reviewContract(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SIGN") as! SignContractViewController
        vc.isSigned = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
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
