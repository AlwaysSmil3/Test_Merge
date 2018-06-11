//
//  APIClient+Invest.swift
//  FinPlus
//
//  Created by Lionel Vũ Thành Đô on 6/11/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
extension APIClient {
    /*
     GET Lấy danh sách khoản vay khả dụng
     */
    func getLoans() -> Promise<APIResponseGeneral> {
        return Promise<APIResponseGeneral> { seal in

            let uid = DataManager.shared.userID
            let endPoint = "\(uid)/" + EndPoint.Loan.Loans

            getDataWithEndPoint(endPoint: endPoint, isShowLoadingView: false)
                .done { json in
                    let model = APIResponseGeneral(object: json)
                    seal.fulfill(model)
                }
                .catch { error in seal.reject(error)}
        }
    }
}
