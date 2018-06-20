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
            getDataWithEndPoint(host: hostLoan, endPoint: EndPoint.Config.Configs, isShowLoadingView: false)
                .done { json in
                    let model = Config(object: json)
                    seal.fulfill(model)
                    
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
            getDataWithEndPoint(host: hostLoan, endPoint: EndPoint.Config.Cities, isShowLoadingView: false)
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
            
            let endPoint = "\(cityID)/" + EndPoint.Config.Districts
            
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
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
            
            let endPoint = "\(districtID)/" + EndPoint.Config.Communes
            
            getDataWithEndPoint(host: hostLoan, endPoint: endPoint, isShowLoadingView: false)
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
    
    
    
    
    
    
}
