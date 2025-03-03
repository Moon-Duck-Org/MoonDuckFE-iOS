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
        
        let image = ImageManager.shared.downloadImage(path: imageUrl)
        imageView.image = image ?? Asset.Assets.imageEmpty.image
        
//        let url = URL(fileURLWithPath: imageUrl)
//
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
//                case .failure(let error):
//                    Log.error("❌ 이미지 로드 실패: \(error)")
//                    self?.imageView.image = Asset.Assets.imageEmpty.image
//                }
//            }
//        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
