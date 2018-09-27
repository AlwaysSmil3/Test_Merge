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
        
        self.currentStep = 4
        self.updateDataToServer()
        
        if let bottomView = self.bottomScrollView {
            bottomView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
        }
        
        self.configTextMesseageView()
        
        self.initLoanCate()
        //NotificationCenter.default.addObserver(self, selector: #selector(showInputMesseage(notification:)), name: .showMuiltiLineInputText, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //MARK: For catch event show hidden keyboard
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard self.isMuiltiLineText else { return }
        self.isMuiltiLineText = false
        //Do something here
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            self.contentInputView?.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.bottomConstraintContentInputView?.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }) { (status) in
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        //Do something here
        self.hideInputMessageView()
    }
    
    
    @objc func showInputMesseage(notification: NSNotification) {
        self.isMuiltiLineText = true
        self.sbInputView?.textView.becomeFirstResponder()
    }
    
    
    /// check input with field is Required
    ///
    /// - Returns: <#return value description#>
    private func checkIsReqruiedOptionalText() -> Bool {
        guard let builder = self.loanCate?.builders, builder.count > 3, let listField = builder[3].fields else { return true }
        
        var index = 0
        for text in DataManager.shared.loanInfo.optionalText {
            if text.count == 0 &&  listField.count > index && listField[index].isRequired == true {
                return false
            }
            index += 1
        }
        return true
    }
    
    
    /// check input with field is Required
    ///
    /// - Returns: <#return value description#>
    private func checkIsReqruiedOptionalMedia() -> Bool {
        guard let builder = self.loanCate?.builders, builder.count > 3, let listField = builder[3].fields else { return true }
        
        var index = 0
        let totalCount = DataManager.shared.loanInfo.optionalMedia.count
        
        for media in DataManager.shared.loanInfo.optionalMedia {
            
            if index < totalCount - 1 && media.count == 0 && listField.count > (index + DataManager.shared.loanInfo.optionalText.count) && listField[index + DataManager.shared.loanInfo.optionalText.count].isRequired == true {
                
                return false
            }
            index += 1
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
            
            if let avatar = DataManager.shared.browwerInfo?.avatar, avatar.count > 0 {
                //Đã có thông tin Facebook
                let loanSummaryInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSummaryInfoVC") as! LoanSummaryInfoVC
                
                self.navigationController?.pushViewController(loanSummaryInfoVC, animated: true)
                
                return
            }
            
            //Chưa có thông tin Facebook
            
            let socialInfoVC = UIStoryboard(name: "Loan", bundle: nil).instantiateViewController(withIdentifier: "LoanSocialInfoViewController") as! LoanSocialInfoViewController
            
            self.navigationController?.pushViewController(socialInfoVC, animated: true)
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


