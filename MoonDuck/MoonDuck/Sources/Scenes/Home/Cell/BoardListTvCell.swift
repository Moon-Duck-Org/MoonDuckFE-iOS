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
    
    func configure(with board: Board) {
        lbUserNickname?.text = board.userNickname
        lbCreatedData?.text = board.created
        lbTitle?.text = board.title
        lbContent?.text = board.content
        lbLink?.text = board.link
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
