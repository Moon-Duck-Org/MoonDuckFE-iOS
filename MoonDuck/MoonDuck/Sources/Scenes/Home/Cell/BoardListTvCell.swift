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
    
    @IBOutlet private weak var imageCollectioinView: UICollectionView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var bottomMarginConstraint: NSLayoutConstraint!

    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreButton: CellButton!
    
    func configure(with board: Review) {
        lbUserNickname?.text = board.nickname
        lbCreatedData?.text = board.created
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
        
        if board.imageUrlList.count < 1 {
            imageHeightConstraint.constant = 0
            imageCollectioinView.isHidden = true
        } else {
            imageHeightConstraint.constant = 200
            imageCollectioinView.isHidden = false
        }
    }
    
}
