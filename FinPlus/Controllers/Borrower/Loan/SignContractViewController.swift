//
//  SignContractViewController.swift
//  FinPlus
//
//  Created by nghiendv on 21/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit

class SignContractViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var borderView: UIView!
    
    var isSigned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor(hexString: "#E3EBF0").cgColor
        self.borderView.layer.cornerRadius = 8
        
        if (isSigned)
        {
            self.btnSign.setTitle("Đã ký", for: .normal)
            self.btnSign.backgroundColor = UIColor(hexString: "#B8C9D3")
            self.btnSign?.tintColor = .white
            self.btnSign.isEnabled = true
            self.btnSign.layer.cornerRadius = 8
            self.btnSign.layer.masksToBounds = true
        }
        else
        {
            self.btnSign.setBackgroundColor(color: MAIN_COLOR, forState: .normal)
            self.btnSign.setBackgroundColor(color: UIColor(hexString: "#4D6678"), forState: .focused)
            self.btnSign?.tintColor = .white
            self.btnSign.layer.cornerRadius = 8
            self.btnSign.layer.masksToBounds = true
        }
        
        self.btnSign.titleLabel?.font = UIFont(name: FONT_FAMILY_BOLD, size: FONT_SIZE_NORMAL)
        self.title = NSLocalizedString("Hợp đồng vay", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let htmlPath = Bundle.main.path(forResource: "hop-dong", ofType: "html")!
        let url = URL(fileURLWithPath: htmlPath)
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navi_back() {
        self.navigationController?.isNavigationBarHidden = isSigned
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sign_contract(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CONTRACT_SUCCESS")
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc!, animated: true)
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

