//
//  BorrowHomeViewController.swift
//  FinPlus
//
//  Created by Cao Van Hai on 5/14/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

class BorrowHomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        
        APIClient.shared.getUserInfo(uId: DataManager.shared.userID)
            .then(on: DispatchQueue.main) { model -> Void in
                
                
            }
            .catch { error in
                
            }
        
    }
    
    
    
}
