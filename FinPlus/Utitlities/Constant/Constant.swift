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
    case DRAFT = 1 // H3
    case WAITING_FOR_APPROVAL = 2 // H4
    case PENDING = 3 // H5
    case ACCEPTED = 4 // H6
    case REJECTED = 5 // H13
    case CANCELED = 6
    case RAISING_CAPITAL = 7
    case COMPLETED = 8 // H3
    
    case PAY_TEST_STATUS = 9

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

// Investor color
// 1. ColorChart
let POSITIVE1_COLOR = UIColor(hexString: "#218043")
let POSITIVE2_COLOR = UIColor(hexString: "#3EAA5F")
let POSITIVE3_COLOR = UIColor(hexString: "#5DC181")
let POSITIVE4_COLOR = UIColor(hexString: "#94D4AB")
let POSITIVE5_COLOR = UIColor(hexString: "#B8E6C8")

let NAGATIVE1_COLOR = UIColor(hexString: "#FFD39F")
let NAGATIVE2_COLOR = UIColor(hexString: "#FFBB6B")
let NAGATIVE3_COLOR = UIColor(hexString: "#ED8A17")
let NAGATIVE4_COLOR = UIColor(hexString: "#EB712D")
let NAGATIVE5_COLOR = UIColor(hexString: "#DA3535")

// 2. Light Theme Color
let LIGHT_NAVI_COLOR = UIColor(hexString: "#F1F5F8").withAlphaComponent(0.75)
let LIGHT_BACKGROUND_COLOR = UIColor(hexString: "#F7F7F7")
let LIGHT_FOREGROUND_COLOR = UIColor(hexString: "#E3EBF0")
let LIGHT_BODY_TEXT_COLOR = UIColor(hexString: "#08121E")
let LIGHT_DESCRIPTION_COLOR = UIColor(hexString: "#4D6678")
let LIGHT_SUBTEXT_COLOR = UIColor(hexString: "#8EA3AF")
let LIGHT_PLACEHOLDER_COLOR = UIColor(hexString: "#B8C9D3")
let LIGHT_BORDER_AND_LINE_COLOR = UIColor(hexString: "#E3EBF0")

// 2. Dark Theme Color
let DARK_NAVI_COLOR = UIColor(hexString: "#070809").withAlphaComponent(0.75)
let DARK_BACKGROUND_COLOR = UIColor(hexString: "#171B1E")
let DARK_FOREGROUND_COLOR = UIColor(hexString: "#111416")
let DARK_BODY_TEXT_COLOR = UIColor(hexString: "#D7D7D7")
let DARK_DESCRIPTION_COLOR = UIColor(hexString: "#757E87")
let DARK_SUBTEXT_COLOR = UIColor(hexString: "#54595D")
let DARK_PLACEHOLDER_COLOR = UIColor(hexString: "#34393D")
let DARK_BORDER_AND_LINE_COLOR = UIColor(hexString: "#1E2428")



//MARK: Font
let FONT_CAPTION = UIFont(name: "SFProDisplay-Semibold", size: 11) ?? UIFont.systemFont(ofSize: 11)

let MS_TITLE_ALERT = "Thông báo"

let MONEY_TERM_DISPLAY: Int32 = 1000000
let BOUND_SCREEN = UIScreen.main.bounds

// UserDefault
let userDefault = UserDefaults.standard
var systemConfig : Config?
let fUSER_DEFAUT_ACCOUNT_NAME = "USER_DEFAUT_ACCOUNT_NAME"
let fNEW_ACCOUNT_NAME = "NEW_ACCOUNT_NAME"
let fUSER_DEFAUT_TOKEN = "USER_DEFAUT_TOKEN"
//let fSYSTEM_CONFIG = "SYSTEM_CONFIG"
let fVERSION_CONFIG = "VERSION_CONFIG"




