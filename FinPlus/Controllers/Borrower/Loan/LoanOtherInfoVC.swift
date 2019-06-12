//
//  LoanOtherInfoVC.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/22/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class LoanOtherInfoVC: LoanBaseViewController {
    
    var currentSelectedCollection: IndexPath?
    
    override func viewDidLoad() {
        self.index = 3
        super.viewDidLoad()
        self.currentStep = 5
        //self.updateDataToServer()
        
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
        
        self.configTextMesseageView()
        self.initLoanCate()
        self.mainTBView?.showsVerticalScrollIndicator = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    /// check input with field is Required
    private func checkIsReqruiedOptionalText() -> Bool {
        guard let builder = self.loanCate?.builders, builder.count > 3, let listField = builder[3].fieldsDisplay else { return true }
        
        for (index, text) in DataManager.shared.loanInfo.optionalText.enumerated() {
            if text.count == 0 {
                for fi in listField {
                    if fi.id == "optionalText", let arrayIndex = fi.arrayIndex, arrayIndex == index, fi.isRequired == true {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    /// check input with field is Required
    private func checkIsReqruiedOptionalMedia() -> Bool {
        guard let builder = self.loanCate?.builders, builder.count > 3, let listField = builder[3].fieldsDisplay else { return true }
                
        for (index, media) in DataManager.shared.loanInfo.optionalMedia.enumerated() {
            if media.count == 0 {
                for fi in listField {
                    if fi.id == "optionalMedia", let arrayIndex = fi.arrayIndex, arrayIndex == index, fi.isRequired == true {
                        print(arrayIndex)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func validateInput(completion: () -> Void) {
        
        if !self.checkIsReqruiedOptionalText() {
            self.showToastWithMessage(message: "Vui lòng nhập đầy đủ thông tin để sang bước tiếp theo")
            return
        }

        if !self.checkIsReqruiedOptionalMedia() {
            self.showToastWithMessage(message: "Vui lòng upload đầy đủ ảnh để sang bước tiếp theo")
            return
        }
        
        if !DataManager.shared.checkDataInvalidChangedInStepOtherInfo() {
            //For Missing Data
            self.showToastWithMessage(message: "Vui lòng thay đổi các thông tin không chính xác.")
            return
        }
        
        completion()
    }
    
    //MARK: ACtions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.validateInput {
            guard DataManager.shared.listKeyMissingLoanKey == nil || DataManager.shared.listKeyMissingLoanKey!.count == 0 else {
                DataManager.shared.loanInfo.currentStep = 5
                updateLoanStatusInvalidData()
                return
            }
            
            self.updateDataToServer(step: 5, completion: {
                if let avatar = DataManager.shared.browwerInfo?.avatar, avatar.count > 0 {
                    //Đã có thông tin Facebook
                    let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
                    self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
                    return
                }
                
                //Chưa có thông tin Facebook
                let socialInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSocialInfoViewController") as! LoanSocialInfoViewController
                
                self.navigationController?.pushViewController(socialInfoVC, animated: true)
            })
        }
    }
    
}

//MARK: UICollection View Delegate Flow Layout
extension LoanOtherInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (BOUND_SCREEN.size.width - 32) / 3
        return CGSize(width: width, height: width)
    }
    
}
