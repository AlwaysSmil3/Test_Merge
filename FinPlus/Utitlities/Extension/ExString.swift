//
//  ExString.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/15/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension String {
    
    func length() -> Int {
        return self.count
    }
    
    
    /// Bỏ dấu tiếng Việt
    ///
    /// - Returns: <#return value description#>
    func removeVietnameseMark() -> String {
        return self.folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: .current)
    }
    
    
}
