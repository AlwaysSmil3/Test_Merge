//
//  ExUIView.swift
//  FinPlus
//
//  Created by Cao Van Hai on 6/2/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation

extension UIView {
    
    /// Add Gradient Color
    ///
    /// - Parameter colors: <#colors description#>
    func addGradient(colors: [UIColor]) {
        let gl = CAGradientLayer()
        gl.colors = colors.map { $0.cgColor }
        gl.locations = [0.0, 1.0]
        gl.frame.size = frame.size
        gl.cornerRadius = 5
        
        self.layer.addSublayer(gl)
    }
    
    // OUTPUT 1
    func dropShadow(color: UIColor, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 24
    
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
}
