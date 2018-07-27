//
//  Constant.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/8/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


//Type User
enum UserRole: String {
    case Borrower = "0"
    case Investor = "1"
    case Admin = "2"
}

// MARK: API Constant
enum API_MESSAGE {
    static let Request_Timeout = "Request Timeout"
    static let NO_INTERNET = "Vui lòng kiểm tra lại kết nối mạng của bạn"
    static let OTHER_ERROR = "Lỗi không xác định. Vui lòng thử lại sau"
    static let DATA_FORMART_ERROR = "Không xử lý được dữ liệu nhận được"
}

// Giới tính
enum Gender: Int {
    case Male = 0
    case Female = 1
}

// Số điện thọai người thân
enum RelationPhoneNumber: Int {
    case Wife = 0
    case Husband = 1
    case Father = 2
    case Mother = 3
}

// Các kiểu chụp CMND
enum FILE_TYPE_IMG: Int {
    case ALL = 0 // Cầm CMND trước mặt chụp cả mặt
    case FRONT = 1
    case BACK = 2
    case Optional = 3
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
    
    case OTHER = -1
    case DRAFT = 0 // Khoản vay chưa hoàn thiện (Đang ở trạng thái client tạo đơn vay)
    case SALE_REVIEW = 1 // Đợi sales duyệt (Chờ sales review đơn vay đầy đủ & hợp lệ)
    case SALE_PENDING = 2 // Y/c bổ sung thông tin từ sales
    case RISK_REVIEW = 3 // Thẩm định viên duyệt
    case RISK_PENDING = 4 // Y/c bổ sung thông tin từ thẩm định viên
    case REJECTED = 5 // Bị từ chối
    case INTEREST_CONFIRM = 6 // Chờ xác nhận lãi suất
    case INTEREST_CONFIRM_EXPIRED = 7 // Quá hạn xác nhận lãi suất
    case RAISING_CAPITAL = 8 // Lên chợ và đang huy động vốn
    case PARTIAL_FILLED = 9 // Huy động được 1 phần
    case FILLED = 10 // Huy động vốn được 100%
    case CONTRACT_READY = 11 // Chờ ký hợp đồng
    case EXPIRED = 12 // Đơn vay quá hạn huy động
    case CONTRACT_SIGNED = 13 // Đã ký hợp đồng
    case DISBURSAL = 14 // Đã giải ngân
    case OVERDUE_DEPT = 15 // Nợ quá hạn (Thông tin có nợ bổ sung nợ quá hạn bao nhiêu ngày)
    case TIMELY_DEPT = 16 // Nợ đúng hạn
    case CANCELED = 17 // Đã hủy
    case SETTLED = 18 // Khoản vay đã thanh toán thành công

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
    static let Choice = "choice"
    
}

let APP_MODE = "APP_MODE"
//let IS_INVESTOR = "IS_INVESTOR"

//Category ID
let Loan_Student_Category_ID: Int16 = 1 // Id cua vay sinh vien

let API_RESPONSE_RETURN_CODE = "returnCode"
let API_RESPONSE_RETURN_MESSAGE = "returnMsg"
let API_RESPONSE_RETURN_DATA = "data"

let API_DEVICE_TYPE_OS = 0 // ios 0, android: 1

//MARK: Colors
let MAIN_COLOR = UIColor(hexString: "#3EAA5F")
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
let LIGHT_FOREGROUND_COLOR = LIGHT_MODE_BORDER_COLOR
let LIGHT_BODY_TEXT_COLOR = UIColor(hexString: "#08121E")
let LIGHT_DESCRIPTION_COLOR = UIColor(hexString: "#4D6678")
let LIGHT_SUBTEXT_COLOR = UIColor(hexString: "#8EA3AF")
let LIGHT_PLACEHOLDER_COLOR = UIColor(hexString: "#B8C9D3")
let LIGHT_BORDER_AND_LINE_COLOR = LIGHT_MODE_BORDER_COLOR

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

let FONT_FAMILY_BOLD = "SFProDisplay-Bold"
let FONT_FAMILY_SEMIBOLD = "SFProDisplay-Semibold"
let FONT_FAMILY_MEDIUM = "SFProDisplay-Medium"
let FONT_FAMILY_REGULAR = "SFProDisplay-Regular"

let FONT_SIZE_LARGE : CGFloat = 34
let FONT_SIZE_BIG : CGFloat = 26
let FONT_SIZE_SEMIBIG : CGFloat = 22
let FONT_SIZE_NORMAL : CGFloat = 17
let FONT_SIZE_SEMIMALL : CGFloat = 15
let FONT_SIZE_SMALL : CGFloat = 11

let MS_TITLE_ALERT = "Thông báo"

let MONEY_TERM_DISPLAY: Int32 = 1000000
let BOUND_SCREEN = UIScreen.main.bounds

// UserDefault
let userDefault = UserDefaults.standard
//var systemConfig : Config?
let fUSER_DEFAUT_ACCOUNT_NAME = "USER_DEFAUT_ACCOUNT_NAME"
let fNEW_ACCOUNT_NAME = "NEW_ACCOUNT_NAME"
let fUSER_DEFAUT_TOKEN = "USER_DEFAUT_TOKEN"
//let fSYSTEM_CONFIG = "SYSTEM_CONFIG"
let fVERSION_CONFIG = "VERSION_CONFIG"
let kUserDefault_Aler_Popup_Confirm_Loan = "UserDefault_Aler_Popup_Confirm_Loan"

func getState(type: STATUS_LOAN) -> String {
    switch type {
    case .DRAFT:
        return "Chưa hoàn thiện"
    case .SALE_REVIEW, .SALE_PENDING, .RISK_REVIEW:
        return "Chờ phê duyệt"
    case .RISK_PENDING:
        return "Cần bổ sung thông tin"
    case .REJECTED:
        return "Đơn vay bị từ chối"
    case .INTEREST_CONFIRM:
        return "Chờ xác nhận lãi suất"
    case .INTEREST_CONFIRM_EXPIRED:
        return "Quá hạn xác nhận lãi suất"
    case .RAISING_CAPITAL:
        return "Đang huy động"
    case .PARTIAL_FILLED:
        return "Huy động được một phần"
    case .FILLED:
        return "Đã huy động đủ 100%"
    case .CONTRACT_READY:
        return "Chờ ký hợp đồng"
    case .EXPIRED:
        return "Quá hạn huy động"
    case .CONTRACT_SIGNED:
        return "Đã ký hợp đồng"
    case .DISBURSAL:
        return "Đã giải ngân"
    case .OVERDUE_DEPT:
        return "Nợ quá hạn"
    case .TIMELY_DEPT:
        return "Nợ đúng hạn"
    case .CANCELED:
        return "Đã hủy"
    case .SETTLED:
        return "Khoản vay đã thanh toán thành công"
    default:
        return "Hoàn thành"
    }
}

func getColorText(type: STATUS_LOAN) -> UIColor {
    switch type {
    case .DRAFT, .RISK_PENDING:
        return UIColor(hexString: "#ED8A17") // Da cam
    case .SALE_PENDING, .SALE_REVIEW, .RISK_REVIEW, .INTEREST_CONFIRM, .RAISING_CAPITAL, .PARTIAL_FILLED, .FILLED, .CONTRACT_READY, .CONTRACT_SIGNED, .DISBURSAL, .TIMELY_DEPT:
        return UIColor(hexString: "#3EAA5F") // Xanh
    case .REJECTED, .INTEREST_CONFIRM_EXPIRED, .EXPIRED, .OVERDUE_DEPT, .CANCELED:
        return UIColor(hexString: "#DA3535") // Đỏ
    default:
        return UIColor(hexString: "#4D6678") // Xám lông chuột
    }
}


//Check run máy ảo hay deivce
struct Platform {
    
    static let isSimulator: Bool = {
        
        var isSim = false
        
        #if arch(i386) || arch(x86_64)
        
        isSim = true
        
        #endif
        
        return isSim
        
    }()
    
}




