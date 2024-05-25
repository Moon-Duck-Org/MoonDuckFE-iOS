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
    }
    
    func configure(with image: UIImage) {        
        contentView.roundCornersAndAddBorder(radius: 12)
        imageView.image = image
    }
}
