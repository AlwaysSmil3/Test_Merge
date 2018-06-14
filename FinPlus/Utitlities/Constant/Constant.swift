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

// Các trạng thái của khoản vay
enum STATUS_LOAN: Int {
    case DRAFT = 0 // H3
    case WAITING_FOR_APPROVAL = 1 // H4
    case PENDING = 2 // H5
    case ACCEPTED = 3 // H6
    case REJECTED = 4 // H13
    case CANCELED = 5
    case RAISING_CAPITAL = 7
    
}


/// Các kiểu type TB cell from Loan_Builder
enum DATA_TYPE_TB_CELL {
    static let TextBox = "text_box"
    static let DropDown = "dropdown"
    static let DateTime = "datetime"
    static let DropdownTexBox = "dropdown_text_box"
    static let Address = "address"
    static let Footer = "footer"
    static let File = "file"
    static let MultipleFile = "multiple_file"
    
}

let API_RESPONSE_RETURN_CODE = "returnCode"
let API_RESPONSE_RETURN_MESSAGE = "returnMsg"
let API_RESPONSE_RETURN_DATA = "data"

let API_DEVICE_TYPE_OS = 0 // ios 0, android: 1

//MARK: Colors
let MAIN_COLOR = UIColor(hexString: "#3BAB63")
let BAR_DEFAULT_COLOR = UIColor(hexString: "#c9c9cd")
let DISABLE_BUTTON_COLOR = UIColor(hexString: "#B8C9D3")
let TEXT_NORMAL_COLOR = UIColor(hexString: "#4D6678")

let DROP_SHADOW_COLOR = UIColor(hexString: "#00142a")

//MARK: Font
let FONT_CAPTION = UIFont(name: "SFProDisplay-Semibold", size: 11) ?? UIFont.systemFont(ofSize: 11)

let MS_TITLE_ALERT = "Thông báo"

let MONEY_TERM_DISPLAY = 1000000
let BOUND_SCREEN = UIScreen.main.bounds

// UserDefault
let userDefault = UserDefaults.standard
var systemConfig : Config?
let fUSER_DEFAUT_ACCOUNT_NAME = "USER_DEFAUT_ACCOUNT_NAME"
let fNEW_ACCOUNT_NAME = "NEW_ACCOUNT_NAME"
let fUSER_DEFAUT_TOKEN = "USER_DEFAUT_TOKEN"
//let fSYSTEM_CONFIG = "SYSTEM_CONFIG"




