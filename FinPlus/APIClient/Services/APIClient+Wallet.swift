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
    func getWallets() -> Promise<[Wallet]> {
        
        return Promise<[Wallet]> { seal in
            let uID = DataManager.shared.userID
            let endPoint = "users/" + "\(uID)/" + "wallets"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done(on: DispatchQueue.main) { json in
                    var array: [Wallet] = []
                    if let dataArray = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in dataArray {
                            let wal = Wallet(object: d)
                            array.append(wal)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch{ error in seal.reject(error) }

        }
        
    }
    
    /* POST Thêm ví vào tài khoản người dùng
 
     */
    func addWallet(walletNumber: String, type: Int) -> Promise<[Wallet]> {
        
        return Promise<[Wallet]> { seal in
            
            let uID = DataManager.shared.userID
            let endPoint = "users/" + "\(uID)/" + "wallets"
            
            let params: JSONDictionary = [
                "walletNumber": walletNumber,
                "walletType": type
            ]
            
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .POST)
                .done(on: DispatchQueue.main) { json in
                    
                    var array: [Wallet] = []
                    if let dataArray = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in dataArray {
                            let wal = Wallet(object: d)
                            array.append(wal)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    
    
}
