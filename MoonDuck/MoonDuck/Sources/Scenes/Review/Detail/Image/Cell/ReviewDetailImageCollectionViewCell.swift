//
//  ReviewDetailImageCollectionViewCell.swift
//  MoonDuck
//
//  Created by suni on 7/8/24.
//

import UIKit

class ReviewDetailImageCollectionViewCell: UICollectionViewCell {
    
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
                case .success:
                    break
                case .failure:
                    self?.imageView.image = Asset.Assets.imageEmpty.image
                }
            }
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
