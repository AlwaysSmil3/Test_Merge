//
//  ExUIImage.swift
//  FinPlus
//
//  Created by Cao Van Hai on 7/23/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import Accelerate

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
    
    /*
    func resizeImageUsingVImage(size: CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        
        guard error == kvImageNoError else { return nil }
        
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        
        guard error == kvImageNoError else { return nil }
        
        // create a UIImage
        
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        
        destCGImage = nil
        
        return resizedImage
        
    }
    */
    
    
}
