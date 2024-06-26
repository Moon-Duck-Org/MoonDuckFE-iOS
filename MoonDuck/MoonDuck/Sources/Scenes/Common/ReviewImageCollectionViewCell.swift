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
        
        let url = URL(string: imageUrl)
        imageView.kf.setImage(
            with: url,
            placeholder: Asset.Assets.imageEmpty.image,
            options: [
                .transition(.fade(0.2))
            ],
            completionHandler: { [weak self] result in
                switch result {
                case .success(let value):
                    break
                case .failure(let error):
                    self?.imageView.image = Asset.Assets.imageEmpty.image
                }
                self?.imageView.clipsToBounds = true
                self?.imageView.contentMode = .scaleAspectFill
                self?.roundCornersAndAddBorder(radius: 12.0)
            }
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
