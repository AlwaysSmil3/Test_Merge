//
//  APIClient+Wallet.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    
    /* GET Lấy danh sách ví theo tài khoản người dùng
     
     */
    func getWallets() -> Promise<[AccountBank]> {
        
        return Promise<[AccountBank]> { seal in
            let uID = DataManager.shared.userID
            let endPoint = "\(APIService.AccountService)users/" + "\(uID)/" + "wallets"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done(on: DispatchQueue.main) { json in
                    var array: [AccountBank] = []
                    if let dataArray = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = dataArray.compactMap { AccountBank(object: $0) }

                    }
                    
                    seal.fulfill(array)
                }
                .catch{ error in seal.reject(error) }

        }
        
    }
    
    /* POST Thêm ví vào tài khoản người dùng
 
     */
    func addWallet(walletNumber: String, type: Int) -> Promise<[AccountBank]> {
        
        return Promise<[AccountBank]> { seal in
            
            let uID = DataManager.shared.userID
            let endPoint = "\(APIService.AccountService)users/" + "\(uID)/" + "wallets"
            
            let params: JSONDictionary = [
                "walletNumber": walletNumber,
                "walletType": type
            ]
            
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done(on: DispatchQueue.main) { json in
                    
                    var array: [AccountBank] = []
                    if let dataArray = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = dataArray.compactMap { AccountBank(object: $0) }

                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    
    /// xoá Tài khoản bank
    ///
    /// - Parameter bankAccountID: <#bankAccountID description#>
    /// - Returns: <#return value description#>
    func deleteBankAccount(bankAccountID: Int32) -> Promise<APIResponseGeneral> {
        let userID = DataManager.shared.userID
        let endPoint = "\(APIService.AccountService)users/\(userID)" + "/bank-account/\(bankAccountID)/"
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: [:], isShowLoadingView: true, httpType: .DELETE)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                                if status {
                                }
                                
                            })
                        }
                        
                        return
                    }
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    
    /// Cập nhật tài khoản ngân hàng
    ///
    /// - Parameter bankAccountID: <#bankAccountID description#>
    /// - Returns: <#return value description#>
    func updateBankAccount(bankAccountID: Int32, params: JSONDictionary) -> Promise<APIResponseGeneral> {
        let userID = DataManager.shared.userID
        let endPoint = "\(APIService.AccountService)users/\(userID)" + "/bank-account/\(bankAccountID)/"
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .PUT)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        if let message = json[API_RESPONSE_RETURN_MESSAGE] as? String {
                            UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "OK", cancelTitle: nil, completion: { (status) in
                                if status {
                                }
                                
                            })
                        }
                        
                        return
                    }
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    
    
    
}
