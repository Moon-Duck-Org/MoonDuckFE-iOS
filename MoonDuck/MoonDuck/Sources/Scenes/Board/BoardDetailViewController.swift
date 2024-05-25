//
//  BoardDetailViewController.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

protocol BoardDetailView: NSObject {
    func reloadData(board: Board)
}

class BoardDetailViewController: UIViewController, BoardDetailView, Navigatable {
    
    @IBOutlet weak private var categoryImageView: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak private var contentLabel: UILabel!
    
    @IBOutlet weak private var linkView: UIView!
    @IBOutlet weak private var linkLabel: UILabel!
    @IBOutlet weak private var linkHieghtConstraint: NSLayoutConstraint!
    
    @IBAction private func backButtonTap(_ sender: Any) {
        self.navigator.pop(sender: self)
    }
    @IBAction private func moreButtonTap(_ sender: Any) {
        
    }
    
    let presenter: BoardDetailPresenter
    var navigator: Navigator!
    
    init(navigator: Navigator,
         presenter: BoardDetailPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: BoardDetailViewController.className, bundle: Bundle(for: BoardDetailViewController.self))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(board: Board) {
        categoryImageView.image = board.category.roundImage
        dateLabel.text = board.created
        contentLabel.text = board.content
        
        if let link = board.link, !link.isEmpty {
            linkLabel.text = link
            linkHieghtConstraint.constant = 66.0
        } else {
            linkLabel.text = ""
            linkHieghtConstraint.constant = 0.0
        }
    }

}
