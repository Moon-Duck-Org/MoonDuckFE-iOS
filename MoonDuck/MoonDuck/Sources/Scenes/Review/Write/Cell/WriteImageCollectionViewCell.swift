//
//  WriteImageCollectionViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import UIKit

class WriteImageCollectionViewCell: UICollectionViewCell {

    private var deleteButtonHandler: (() -> Void)?
    
    // @IBOutlet
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    // @IBAction
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        deleteButtonHandler?()
    }
    
    func configure(with image: UIImage, deleteImageHandler: (() -> Void)? = nil) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.roundCornersAndAddBorder(radius: 8)
        
        self.deleteButtonHandler = deleteImageHandler
        
        if deleteButtonHandler != nil {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
}
