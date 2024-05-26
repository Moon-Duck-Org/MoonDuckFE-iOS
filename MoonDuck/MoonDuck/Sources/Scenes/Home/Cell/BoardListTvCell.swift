//
//  BoardListTvCell.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class BoardListTvCell: UITableViewCell {

    @IBOutlet private weak var lbUserNickname: UILabel!
    @IBOutlet private weak var lbCreatedData: UILabel!
        
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbContent: UILabel!
    @IBOutlet private weak var lbLink: UILabel!
    
    @IBOutlet weak var imageCollectioinView: UICollectionView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var bottomMarginConstraint: NSLayoutConstraint!

    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreButton: CellButton!
    
    @IBOutlet weak private var rating1: UIButton!
    @IBOutlet weak private var rating2: UIButton!
    @IBOutlet weak private var rating3: UIButton!
    @IBOutlet weak private var rating4: UIButton!
    @IBOutlet weak private var rating5: UIButton!
    
    var review: Review?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCollectioinView.delegate = self
        imageCollectioinView.dataSource = self
        imageCollectioinView.register(UINib(nibName: ReviewImageCvCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewImageCvCell.className)
        
    }
    func configure(with board: Review) {
        review = board
        lbUserNickname?.text = board.nickname
        lbCreatedData?.text = board.created.toDateString()
        lbTitle?.text = board.title
        lbContent?.text = board.content
        
        if let link = board.link, !link.isEmpty {
            lbLink?.text = board.link
            linkView?.isHidden = false
            bottomMarginConstraint?.constant = 49
        } else {
            lbLink?.text = ""
            linkView?.isHidden = true
            bottomMarginConstraint?.constant = 20
        }
        
        if board.getImageList().count < 1 {
            imageHeightConstraint.constant = 0
            imageCollectioinView.isHidden = true
        } else {
            imageHeightConstraint.constant = 200
            imageCollectioinView.isHidden = false
        }
        
        setRating(board.rating)
        
        imageCollectioinView.reloadData()
    }
    
    private func setRating(_ rating: Int) {
        rating1.isSelected = rating > 0
        rating2.isSelected = rating > 1
        rating3.isSelected = rating > 2
        rating4.isSelected = rating > 3
        rating5.isSelected = rating > 4
    }
    
}
// MARK: - UICollectionViewDataSource
extension BoardListTvCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review?.getImageList().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewImageCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCvCell.className, for: indexPath) as? ReviewImageCvCell {
            if let image = review?.getImage(at: indexPath.row) {
                cell.configure(with: image)
            } else {
                cell.configure(with: Asset.Assets.imageEmptyHome.image)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension BoardListTvCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 181, height: 181)
    }
}
