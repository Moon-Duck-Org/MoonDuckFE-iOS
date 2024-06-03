//
//  BoardDetailViewController.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

protocol BoardDetailView: NSObject, ReviewWriteDelegate {
    func moveBoardEdit(with provider: BoardEditViewPresenter)
    func popView()
    
    func updateData(review: Review)
}

class BoardDetailViewController: UIViewController, BoardDetailView, Navigatable {
    
    @IBOutlet weak private var categoryImageView: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak private var contentLabel: UILabel!
    
    @IBOutlet weak private var linkView: UIView!
    @IBOutlet weak private var linkLabel: UILabel!
    @IBOutlet weak private var linkHieghtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var rating1: UIButton!
    @IBOutlet weak private var rating2: UIButton!
    @IBOutlet weak private var rating3: UIButton!
    @IBOutlet weak private var rating4: UIButton!
    @IBOutlet weak private var rating5: UIButton!
    
    @IBAction private func backButtonTap(_ sender: Any) {
        self.navigator.pop(sender: self)
    }
    @IBAction private func moreButtonTap(_ sender: Any) {
        Alert.shared.showDetailMore(self, writeHandler: {
            self.presenter.tapWriteReview()
        }, shareHandler: {
            let str = self.presenter.review.content
            Alert.shared.showSystemShare(self, str: str)
        }, deleteHandler: {
            Alert.shared.showAlert(self, style: .deleteTwoButton, title: "삭제하시겠어요?", destructiveHandler: {
                self.presenter.tapDeleteReview()
            })
        })
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(review: Review) {
        categoryImageView.image = review.category.roundImage
        dateLabel.text = review.created.toDateString()
        titleLabel.text = review.title
        contentLabel.text = review.content
        
        if let link = review.link, !link.isEmpty {
            linkView.isHidden = false
            linkLabel.text = link
            linkHieghtConstraint.constant = 66.0
        } else {
            linkView.isHidden = true
            linkLabel.text = ""
            linkHieghtConstraint.constant = 0.0
        }
        
        setRating(review.rating)
    }
    
    private func setRating(_ rating: Int) {
        rating1.isSelected = rating > 0
        rating2.isSelected = rating > 1
        rating3.isSelected = rating > 2
        rating4.isSelected = rating > 3
        rating5.isSelected = rating > 4
    }
    
    func popView() {
        navigator.pop(sender: self)
    }
}

// MARK: - Navigation
extension BoardDetailViewController {
    func moveBoardEdit(with presenter: BoardEditViewPresenter) {
        navigator.show(seque: .boardEdit(presenter: presenter), sender: self, transition: .navigation)
    }
}

// MARK: - ReviewWriteDelegate
extension BoardDetailViewController {
    func writeReview(_ review: Review, didChange boardId: Int) {
        presenter.reloadReview()
    }
    
    func writeReview(_ review: Review, didCreate boardId: Int) {
        
    }
}
