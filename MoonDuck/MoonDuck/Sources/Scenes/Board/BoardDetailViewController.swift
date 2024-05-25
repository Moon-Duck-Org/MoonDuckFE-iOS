//
//  BoardDetailViewController.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

protocol BoardDetailView: NSObject {
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
}
