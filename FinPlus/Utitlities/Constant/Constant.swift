//
//  Constant.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

// MARK: API Constant
enum API_MESSAGE {
    static let NO_INTERNET = "Vui lòng kiểm tra lại kết nối mạng của bạn"
    static let OTHER_ERROR = "Lỗi không xác định. Vui lòng thử lại sau"
    static let DATA_FORMART_ERROR = "Không xử lý được dữ liệu nhận được"
}

// Định nghĩa Constant nối vào đuôi media để upload lên server
enum TYPE_UPLOAD_MEDIA_LENDING: String {
    case NATIONALID_FRONT = "FRONT"
    case NATIONALID_BACK = "BACK"
    case NATIONALID_ALL = "ALL"
    case OPTIONAL_MEDIA = "OPTIONALMEDIA"
}

let API_RESPONSE_RETURN_CODE = "returnCode"
let API_RESPONSE_RETURN_MESSAGE = "returnMsg"
let API_RESPONSE_RETURN_DATA = "data"

let API_DEVICE_TYPE_OS = 0 // ios 0, android: 1



let MS_TITLE_ALERT = "Thông báo"

let MONEY_TERM_DISPLAY = 1000000






