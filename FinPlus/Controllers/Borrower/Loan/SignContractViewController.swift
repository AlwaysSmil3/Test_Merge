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
    var activeLoan: BrowwerActiveLoan?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        self.borderView.layer.cornerRadius = 8
        
        self.webView.scrollView.showsVerticalScrollIndicator = false;
        self.webView.scrollView.showsHorizontalScrollIndicator = false;
        
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
        
        self.navigationController?.isNavigationBarHidden = false
        
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
        if self.isSigned { return }
        self.sendOTP()
    }
    
    func sendOTP() {
        
        self.handleLoadingView(isShow: true)
        
        APIClient.shared.getOTPContract(loanID: (self.activeLoan?.loanId)!)
        .done(on: DispatchQueue.main) { model in
            self.handleLoadingView(isShow: false)
            
            let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
            verifyVC.verifyType = .SignContract
            verifyVC.loanId = self.activeLoan?.loanId
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(verifyVC, animated: true)
        }
        .catch { error in
            self.handleLoadingView(isShow: false)
            self.showAlertView(title: "Có lỗi", message: "Đã có lỗi trong quá trình gửi mã xác thực. Vui lòng thử lại.", okTitle: "Thử lại", cancelTitle: "Hủy", completion: { (okAction) in
                if (okAction)
                {
                    self.sendOTP()
                }
            })
        }
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

