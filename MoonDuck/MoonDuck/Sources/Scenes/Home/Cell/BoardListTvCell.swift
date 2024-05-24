//
//  BoardListTvCell.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class BoardListTvCell: UITableViewCell {

    @IBOutlet weak var lbUserNickname: UILabel!
    @IBOutlet weak var lbCreatedData: UILabel!
        
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbLink: UILabel!
    
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
