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
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    
    // @IBAction
    @IBAction private func tapDeleteButton(_ sender: Any) {
        deleteButtonHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: UIImage, deleteImageHandler: (() -> Void)? = nil) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.roundCornersAndAddBorder(radius: 8)
        
        self.deleteButtonHandler = deleteImageHandler
        
        if let _ = deleteButtonHandler {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
}
