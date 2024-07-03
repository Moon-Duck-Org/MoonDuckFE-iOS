//
//  WebViewController.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import UIKit

import WebKit

protocol WebView: BaseView {
    // UI Logic
    func updateTitleLabel(with title: String)
    func loadWebView(with url: URL)
    
    // Navigation
}

class WebViewController: BaseViewController, WebView, Navigatable {
    
    var navigator: Navigator?
    let presenter: WebPresenter
    
    // @IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var webView: WKWebView!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    
    init(navigator: Navigator,
         presenter: WebPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: WebViewController.className, bundle: Bundle(for: WebViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension WebViewController {
    func updateTitleLabel(with title: String) {
        titleLabel.text = title
    }
    
    func loadWebView(with url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

// MARK: - Navigation
extension WebViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
}
