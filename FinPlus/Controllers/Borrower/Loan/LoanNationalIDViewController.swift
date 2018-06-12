//
//  LoanNationalIDViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


class LoanNationalIDViewController: LoanBaseViewController {
    
    
    override func viewDidLoad() {
        self.index = 2
        super.viewDidLoad()
    
        if let bottomView = self.bottomScrollView {
            
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataToServer()
    }
    
    private func uploadData(img: UIImage) {
        
        let dataImg = UIImagePNGRepresentation(img)
        
        let loanID = DataManager.shared.loanID ?? 0
        guard let data = dataImg else { return }
        let endPoint = "loans/" + "\(loanID)/" + "file"
        
        self.handleLoadingView(isShow: true)
        APIClient.shared.upload(type: .NATIONALID_BACK, typeMedia: "image", endPoint: endPoint, imagesData: [data], parameters: ["" : ""], onCompletion: { (response) in
            self.handleLoadingView(isShow: false)
            print("Upload \(response)")
            self.showToastWithMessage(message: "Upload success")
            
        }) { (error) in
            self.handleLoadingView(isShow: false)
            
            if let error = error {
                self.showToastWithMessage(message: error.localizedDescription)
                print("error \(error.localizedDescription)")
            }
        }
    }

    //MARK: Actions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        let loanOtherInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanOtherInfoVC") as! LoanOtherInfoVC
        
        self.navigationController?.pushViewController(loanOtherInfoVC, animated: true)
        
    }
}


