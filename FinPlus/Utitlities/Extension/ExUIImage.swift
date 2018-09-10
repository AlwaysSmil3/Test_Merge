//
//  ExUIImage.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation


extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
    
    /// Resize with size Mony
    ///
    /// - Parameter originSize: <#originSize description#>
    /// - Returns: <#return value description#>
    func resizeMonyImage(originSize: CGSize) -> UIImage? {
        let value: CGFloat = 2048
        
        if originSize.width < originSize.height && originSize.height < value {
            return self.resizeImage(size: CGSize(width: originSize.width, height: originSize.height))
        }
        
        if originSize.width > originSize.height && originSize.height > value {
            
            return self.resizeImage(size: CGSize(width: value, height: (originSize.height * value)/originSize.width))
        }
        
        if originSize.height > originSize.width && originSize.width > value {
            
            return self.resizeImage(size: CGSize(width: (originSize.width * value)/originSize.height, height: value))
        }
        
        return self.resizeImage(size: CGSize(width: originSize.width, height: originSize.height))
    }
    
    func resizeImage(size: CGSize) -> UIImage? {
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    /// Rotate image
    ///
    /// - Parameter radians: <#radians description#>
    /// - Returns: <#return value description#>
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    

    
    
}
