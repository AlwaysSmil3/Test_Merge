//
//  APIClient+Config.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension APIClient {
    
    /*
     GET Lấy cấu hình hệ thống
     
     */
    
    func getConfigs() -> Promise<Config> {
        return Promise<Config> { seal in
            getDataWithEndPoint(endPoint: EndPoint.Config.Configs, isShowLoadingView: false)
                .done { json in
                    
                    //Tỷ giá lãi xuất
                    if DataManager.shared.listRateInfo.count == 0, let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary, let listRate = data["rateInfo"] as? [JSONDictionary] {
                        for d in listRate {
                            let rate = RateInfo(object: d)
                            DataManager.shared.listRateInfo.append(rate)
                        }
                        
                    }
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? JSONDictionary {
                        
                        if let versionData = data["minBorrowerAppVersion"] as? JSONDictionary, let versionDataIOS = versionData["ios"] as? JSONDictionary {
                            DataManager.shared.jsonDataVercodeFromConfig = versionDataIOS
                        }
                        
                        let model = Config(object: data)
                        seal.fulfill(model)
                    }
                    
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách các tỉnh thành phố
     
     */
    func getCities() -> Promise<[Model1]> {
        return Promise<[Model1]> { seal in
            getDataWithEndPoint(endPoint: EndPoint.Config.Cities, isShowLoadingView: false)
                .done { json in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }
    
    /*
     GET Lấy danh sách quận/huyện
     
     */
    func getDistricts(cityID: Int16) -> Promise<[Model1]> {
        return Promise<[Model1]> { seal in
            
            let endPoint = "cities/\(cityID)/" + EndPoint.Config.Districts
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    /*
     GET Lấy danh sách xã/phường
     
     */
    func getCommunes(districtID: Int16) -> Promise<[Model1]> {
        return Promise<[Model1]> { seal in
            
            let endPoint = "districts/\(districtID)/" + EndPoint.Config.Communes
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    /* GET Lấy danh sách nghề nghiệp
 
     */
    func getJobs() -> Promise<[Model1]> {
        return Promise<[Model1]> { seal in
            
            getDataWithEndPoint(endPoint: EndPoint.Config.Job, isShowLoadingView: false)
                .done { json in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
        
    }
    
    /* GET Lấy danh sách vị trí làm việc
     
     */
    func getPositions() -> Promise<[Model1]> {
        return Promise<[Model1]> { seal in
            
            getDataWithEndPoint(endPoint: EndPoint.Config.Position, isShowLoadingView: false)
                .done { json in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in seal.reject(error)}
        }
        
        
    }
    
    
    /*
     GET Lấy danh sách ngan hang
     
     */
    func getBanks() -> Promise<[Bank]> {
        return Promise<[Bank]> { seal in
            getDataWithEndPoint(endPoint: EndPoint.Config.Banks, isShowLoadingView: false)
                .done { json in
                    
                    guard let returnCode = json[API_RESPONSE_RETURN_CODE] as? Int, returnCode > 0 else {
                        let message = json[API_RESPONSE_RETURN_MESSAGE] as? String ?? API_MESSAGE.OTHER_ERROR
                        UIApplication.shared.topViewController()?.showGreenBtnMessage(title: MS_TITLE_ALERT, message: message, okTitle: "Đóng", cancelTitle: nil, completion: { (status) in
                            if status {
                                
                            }
                            
                        })
                        
                        return
                    }
                    
                    var array: [Bank] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Bank(object: d)
                            array.append(model1)
                        }
                    }
                    
                    seal.fulfill(array)
                }
                .catch { error in
                    seal.reject(error)
            }
        }
    }
    
    
    
}
