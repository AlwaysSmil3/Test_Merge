//
//  APIClient+User.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/17/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /* Lấy thông tin người dùng
     
     */
    func getUserInfo(uId: Int32) -> Promise<BrowwerInfo> {
        
        return Promise<BrowwerInfo> { seal in
            let endPoint = EndPoint.User.User + "\(uId)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    print(json)
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        
                        if let activeLoan = data["activeLoan"] as? JSONDictionary, let missingData = activeLoan["missingData"] {
                            DataManager.shared.missingLoanData = BrowwerActiveLoan(object: missingData)
                        }
                        
                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
                }
            
        }
        
    }
    
    /*
     
     PUT [Done] Cập push notification token
     HEADERS
     Content-Type
     application/json
     PATH VARIABLES
     uid
     
     Mã khách hàng của Fin+
     BODY
     
     {
     "token":"xxxxxxxxxxxxxxxxxxxxxxx"
     }
     

     */
    func pushNotificationToken() -> Promise<APIResponseGeneral> {
        let token = DataManager.shared.pushNotificationToken ?? ""
        
        let params: JSONDictionary = [
            "token": token
        ]
        
        return Promise<APIResponseGeneral> { seal in
            
            let uID = DataManager.shared.userID
            let endPoint = "users/" + "\(uID)" + "/push-token"
            
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: false, httpType: HTTPMethodType.PUT)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in
                    seal.reject(error)
            }
            
        }
        
    }
    
    
    
}
