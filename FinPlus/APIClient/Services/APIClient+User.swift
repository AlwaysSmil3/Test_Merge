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
        
        return Promise { fullFill, reject in
            
            let endPoint = EndPoint.User.User + "\(uId)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .then { json -> Void in
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        let model = BrowwerInfo(object: data)
                        fullFill(model)
                    }
                }
                .catch { error in
                    reject(error)
                }
            
        }
        
        
        
        
    }
    
    
    
}
