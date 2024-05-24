//
//  BoardImageCvCell.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class BoardImageCvCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.roundCornersAndAddBorder(radius: 12)
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
