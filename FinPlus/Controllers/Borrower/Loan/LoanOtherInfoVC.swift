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
    
    private func validateInput(completion: () -> Void) {
        
        var optionalTextIsDone = true
        for text in DataManager.shared.loanInfo.optionalText {
            if text.count == 0 {
                optionalTextIsDone = false
                break
            }
        }

        if !optionalTextIsDone {
            self.showToastWithMessage(message: "Vui lòng nhập đầy đủ thông tin để sang bước tiếp theo")
            return
        }

        var optionalMediaIsDone = true
        var index = 0
        for media in DataManager.shared.loanInfo.optionalMedia {
            if index == 0 && media.count == 0 {
                optionalMediaIsDone = false
                break
            }
            index += 1
        }

        if !optionalMediaIsDone {
            self.showToastWithMessage(message: "Vui lòng upload đầy đủ ảnh để sang bước tiếp theo")
            return
        }
        
        completion()
        
        
    }
    
    //MARK: ACtions
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.validateInput {
            guard DataManager.shared.listKeyMissingLoanKey == nil || DataManager.shared.listKeyMissingLoanKey!.count == 0 else {
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
    
    /*
    private func updateLoanStatus() {
        DataManager.shared.loanInfo.status = DataManager.shared.loanInfo.status - 1

        clearValueInValidUserDefaultData()

        APIClient.shared.loan(isShowLoandingView: true, httpType: .PUT)
            .done(on: DispatchQueue.main) { model in
                DataManager.shared.loanID = model.loanId!

                //Lay thong tin nguoi dung
                APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
                    .done(on: DispatchQueue.main) { model in
                        DataManager.shared.browwerInfo = model

                        self.showGreenBtnMessage(title: MS_TITLE_ALERT, message: "Bạn đã cập nhật thông tin xong!", okTitle: "Về trang chủ", cancelTitle: nil) { (status) in
                            if status {
                                if let info = DataManager.shared.browwerInfo?.activeLoan,  let loanId = info.loanId, loanId > 0 {
                                    let tabbarVC = BorrowerTabBarController(nibName: nil, bundle: nil)
                                    if let window = UIApplication.shared.delegate?.window, let win = window {
                                        win.rootViewController = tabbarVC
                                    }
                                } else {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }

                    }
                    .catch { error in
                        self.navigationController?.popToRootViewController(animated: true)
                }

            }
            .catch { error in }


    }
    */
    
    
}


//MARK: UICollection View Delegate Flow Layout
extension LoanOtherInfoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (BOUND_SCREEN.size.width - 32) / 3
        return CGSize(width: width, height: width)
    }
    
}


