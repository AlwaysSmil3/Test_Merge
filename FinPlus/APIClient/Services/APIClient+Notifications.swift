//
//  APIClient+Notifications.swift
//  FinPlus
//
//  Created by Cao Van Hai on 8/16/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    func getListNotifications(after: Int, limit: Int = 20) -> Promise<[NotificationModel]> {
        return Promise<[NotificationModel]> { seal in
            let uID = DataManager.shared.userID
            let endPoint = "\(APIService.AccountService)/users/\(uID)/notifications?after=\(after)&limit=\(limit)"
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode == 1 else {
                        self.showErrorMessage(json: json)
                        return
                    }
                    
                    var array: [NotificationModel] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        array = data.compactMap {NotificationModel(object: $0)}
                    }
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /// Update status Notification
    func updateNotification(notiID: Int) -> Promise<APIResponseGeneral> {
        let userID = DataManager.shared.userID
        let endPoint = "\(APIService.AccountService)users/\(userID)/notification"
        let params: JSONDictionary = ["id": notiID, "status": false]
        
        return Promise<APIResponseGeneral> { seal in
            requestWithEndPoint(endPoint: endPoint, params: params, isShowLoadingView: false, httpType: .PUT)
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
