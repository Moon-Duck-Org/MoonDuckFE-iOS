//
//  BoardDetailViewController.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

protocol BoardDetailView: NSObject {
    
}

class BoardDetailViewController: UIViewController, BoardDetailView, Navigatable {
    
    @IBAction private func backkButtonTap(_ sender: Any) {
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
