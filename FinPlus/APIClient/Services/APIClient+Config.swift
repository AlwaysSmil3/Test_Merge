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
    
    func getVersion() -> Promise<Version> {
        return Promise { fullFill, reject in
            getDataWithEndPoint(endPoint: EndPoint.Config.Configs, isShowLoadingView: false)
                .then { json -> Void in
                    
                    let model = Version(object: json)
                    fullFill(model)
                    
                }
                .catch { error in
                    reject(error)
            }
        }
    }
    
    /*
     GET Lấy danh sách các tỉnh thành phố
     
     */
    func getCities() -> Promise<[Model1]> {
        return Promise { fullFill, reject in
            getDataWithEndPoint(endPoint: EndPoint.Config.Cities, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in
                    reject(error)
                }
        }
    }
    
    /*
     GET Lấy danh sách quận/huyện
     
     */
    func getDistricts(cityID: Int) -> Promise<[Model1]> {
        return Promise { fullFill, reject in
            
            let endPoint = "\(cityID)/" + EndPoint.Config.Districts
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in
                    reject(error)
            }
        }
    }
    
    
    /*
     GET Lấy danh sách xã/phường
     
     */
    func getCommunes(districtID: Int) -> Promise<[Model1]> {
        return Promise { fullFill, reject in
            
            let endPoint = "\(districtID)/" + EndPoint.Config.Communes
            
            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in
                    reject(error)
            }
        }
    }
    
    /* GET Lấy danh sách nghề nghiệp
 
     */
    func getJobs() -> Promise<[Model1]> {
        return Promise { fullFill, reject in
            
            getDataWithEndPoint(endPoint: EndPoint.Config.Job, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in reject(error)}
        }
        
    }
    
    /* GET Lấy danh sách vị trí làm việc
     
     */
    func getPositions() -> Promise<[Model1]> {
        return Promise { fullFill, reject in
            
            getDataWithEndPoint(endPoint: EndPoint.Config.Position, isShowLoadingView: false)
                .then { json -> Void in
                    
                    var array: [Model1] = []
                    
                    if let data = json[API_RESPONSE_RETURN_DATA] as? [JSONDictionary] {
                        for d in data {
                            let model1 = Model1(object: d)
                            array.append(model1)
                        }
                    }
                    
                    fullFill(array)
                }
                .catch { error in reject(error)}
        }
        
        
    }
    
    
    
    
    
    
}
