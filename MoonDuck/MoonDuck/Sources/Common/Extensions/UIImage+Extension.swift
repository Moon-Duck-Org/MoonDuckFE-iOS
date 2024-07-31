//
//  UIImage+Extension.swift
//  MoonDuck
//
//  Created by suni on 7/31/24.
//

import UIKit

extension UIImage {
    func downscaleTOjpegData(maxBytes: UInt) -> Data? {
        var quality = 1.0
        while quality > 0 {
            guard let jpeg = jpegData(compressionQuality: quality)
            else { return nil }
            if jpeg.count <= maxBytes {
                return jpeg
            }
            quality -= 0.1
        }
        return nil
    }
}
