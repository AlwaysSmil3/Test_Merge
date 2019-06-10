//
//  SpreadCell.swift
//  FinPlus
//
//  Created by nghiendv on 12/06/2018.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import UIKit
import SpreadsheetView

class TitleCell: Cell {
    
    let label = UILabel()
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIView()
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#4D6678")
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MonthCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#08121E")
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MoneyCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#4D6678")
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class PayCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#3EAA5F")
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
