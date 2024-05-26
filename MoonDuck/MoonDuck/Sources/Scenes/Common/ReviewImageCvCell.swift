//
//  ReviewImageCvCell.swift
//  MoonDuck
//
//  Created by suni on 5/26/24.
//

import UIKit

class ReviewImageCvCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.roundCornersAndAddBorder(radius: 12.0)
    }
}
