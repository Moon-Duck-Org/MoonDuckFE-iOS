//
//  ReviewImageCollectionViewCell.swift
//  MoonDuck
//
//  Created by suni on 5/26/24.
//

import UIKit
import Kingfisher

class ReviewImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(
                with: url,
                placeholder: Asset.Assets.imageEmpty.image,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ],
                completionHandler: { [weak self] _ in
                    self?.imageView.contentMode = .scaleAspectFill
                    self?.imageView.roundCornersAndAddBorder(radius: 12.0)
                }
            )
        } else {
            imageView.image = Asset.Assets.imageEmpty.image
            imageView.contentMode = .scaleAspectFill
            imageView.roundCornersAndAddBorder(radius: 12.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
