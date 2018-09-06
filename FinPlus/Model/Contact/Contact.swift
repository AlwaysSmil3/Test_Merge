//
//  Contact.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/5/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class Contact: NSObject {
    public var firstName: String?
    public var lastName: String?
    public var fullName: String?
    public var phoneNumber: String?
    
    public var nameDisplay: String?
    
    //avata danh bạ
    public var avatar: UIImage?
    
    required override init() {
        
        super.init()
        
        self.initData()
    }
    
    public func initData() {
        firstName = ""
        lastName = ""
        fullName = ""
        avatar = UIImage()
        
        nameDisplay = ""
        
        phoneNumber = ""
    }
    
    
}
