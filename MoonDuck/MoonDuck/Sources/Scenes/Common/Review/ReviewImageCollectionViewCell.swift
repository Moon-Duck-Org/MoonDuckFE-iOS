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
        
        let image = ImageManager.shared.downloadImage(path: imageUrl)
        imageView.image = image ?? Asset.Assets.imageEmpty.image
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        roundCornersAndAddBorder(radius: 12.0)
        
//        let url = URL(fileURLWithPath: imageUrl)
//        imageView.kf.setImage(
//            with: url,
//            placeholder: Asset.Assets.imageEmpty.image,
//            options: [
//                .transition(.fade(0.2)),
//                .memoryCacheExpiration(.expired), // 메모리 캐시 비활성화
//                .diskCacheExpiration(.expired) // 디스크 캐시 비활성화
//            ],
//            completionHandler: { [weak self] result in
//                switch result {
//                case .success:
//                    break
//                case .failure:
//                    self?.imageView.image = Asset.Assets.imageEmpty.image
//                }
//                self?.imageView.clipsToBounds = true
//                self?.imageView.contentMode = .scaleAspectFill
//                self?.roundCornersAndAddBorder(radius: 12.0)
//            }
//        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
