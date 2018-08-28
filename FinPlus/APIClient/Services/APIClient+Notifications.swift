//
//  APIClient+Notifications.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/16/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func getListNotifications(pageIndex: Int) -> Promise<[NotificationModel]> {
        return Promise<[NotificationModel]> { seal in
            let uID = DataManager.shared.userID
            let endPoint = "/users/\(uID)/notifications?page=\(pageIndex)&limit=\(20)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: true)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    
                    var array: [NotificationModel] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = NotificationModel(object: d)
                            array.append(model1)
                        }
                    }
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
    }
    
    
    /// Update status Notification
    ///
    /// - Parameter notiID: <#notiID description#>
    /// - Returns: <#return value description#>
    func updateNotification(notiID: Int) -> Promise<APIResponseGeneral> {
        let userID = DataManager.shared.userID
        let endPoint = "users/\(userID)/notification"
        let params: JSONDictionary = ["id": notiID,
                      "status": false
        ]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: true, httpType: .PUT)
                .done { json in
                    
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    
    
}
