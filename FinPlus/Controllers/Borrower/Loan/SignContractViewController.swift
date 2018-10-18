//
//  SignContractViewController.swift
//  FinPlus
//
//  Created by nghiendv on 21/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import CoreLocation


class SignContractViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var borderView: UIView!
    
    var isSigned = false
    var activeLoan: BrowwerActiveLoan?
    var data: APIResponseGeneral?
    
    var contractUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.timeCount = 60
        }

        // Do any additional setup after loading the view.
        self.webView.delegate = self
        
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = LIGHT_MODE_BORDER_COLOR.cgColor
        self.borderView.layer.cornerRadius = 8
        
        self.webView.scrollView.showsVerticalScrollIndicator = false;
        self.webView.scrollView.showsHorizontalScrollIndicator = false;
        
        
        if (isSigned)
        {
            self.btnSign.setTitle("Đã ký hợp đồng", for: .normal)
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
        self.title = "Ký hợp đồng"
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Load ContractURL
        if self.isSigned {
            if let urlString = self.contractUrl, let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.webView.loadRequest(request)
            } else if let urlString = DataManager.shared.browwerInfo?.activeLoan?.contractUrl, let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.webView.loadRequest(request)
            }
        } else {
            if self.data == nil {
                self.getContractSign()
            }
        }
        
        self.initLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Zoom webView
    func enableZoomPageWebView() {
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
        self.webView.stringByEvaluatingJavaScript(from: "document.querySelector('meta[name=viewport]').setAttribute('content', 'user-scalable = 1;', false); ")
    }
    
    func getContractSign() {
        SVProgressHUD.show(withStatus: "Đang lấy hợp đồng...")
        APIClient.shared.getContractWhenSign()
            .done(on: DispatchQueue.global()) { [weak self]model in
                SVProgressHUD.dismiss()
                self?.data = model
                
                if let url = URL(string: model.data!) {
                    let request = URLRequest(url: url)
                    DispatchQueue.main.async {
                        self?.webView.loadRequest(request)
                    }
                    
                }
            }
            .catch { error in
                SVProgressHUD.dismiss()
        }
        
    }
    
    
    
    
    func getPermissionLocation(completion: () -> Void) {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            // For use in foreground
            self.initLocationManager()
            return
        }
        
        if status == .denied || status == .restricted {
            let message = "Để ký hợp đồng giải ngân, Mony cần biết chính xác vị trí hiện tại của bạn. Vui lòng bật các dịch vụ định vị GPS để hoàn thiện đơn vay."
            
            self.showAlertView(title: "Không tìm thấy địa điểm", message: message, okTitle: "Bật định vị", cancelTitle: nil, completion: { (bool) in
                
                guard bool else {
                    return
                }
                
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                
            })
            
            
            return
        }
        
        self.checkLocationsIsValid {
            completion()
        }
        
    }
    
    
    @IBAction func navi_back() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sign_contract(_ sender: Any) {
        if self.isSigned { return }
        self.sendOTP()
    }
    
    private func toReadContract() {
        
        let readContract = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "ReadContractViewController") as! ReadContractViewController
        self.present(readContract, animated: true, completion: nil)
        
    }
    
    func getOTPContract() {
        APIClient.shared.getOTPContract(loanID: (self.activeLoan?.loanId)!)
            .done(on: DispatchQueue.main) { [weak self]model in
                self?.toVerifyVC()
                
            }
            .catch { error in
                self.showAlertView(title: "Có lỗi", message: "Đã có lỗi trong quá trình gửi mã xác thực. Vui lòng thử lại.", okTitle: "Thử lại", cancelTitle: "Hủy", completion: { (okAction) in
                    if (okAction)
                    {
                        self.sendOTP()
                    }
                })
        }
    }
    
    
    func sendOTP() {
        self.getPermissionLocation {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if delegate.timeCount == 60 {
                    delegate.timeCount = 0
                    self.getOTPContract()
                } else {
                    self.toVerifyVC()
                }
            } else {
                self.getOTPContract()
            }
        }
    }
    
    func toVerifyVC() {
        let verifyVC = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTPAuthenVC") as! VerifyOTPAuthenVC
        verifyVC.verifyType = .SignContract
        verifyVC.loanId = self.activeLoan?.loanId
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.enableZoomPageWebView()
    }
}


