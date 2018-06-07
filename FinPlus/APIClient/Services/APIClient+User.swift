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
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        seal.fulfill(model)
                    }
                }
                .catch { error in
                    seal.reject(error)
                }
            
        }
        
    }
    
    
    
}
