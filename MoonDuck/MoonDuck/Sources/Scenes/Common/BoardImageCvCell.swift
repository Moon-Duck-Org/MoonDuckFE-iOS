//
//  BoardImageCvCell.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class BoardImageCvCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: CellButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(with image: UIImage,
                   isDelete: Bool = false) {
        
        imageView.image = image
        deleteButton.isHidden = !isDelete
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.roundCornersAndAddBorder(radius: 8)
    }
}
