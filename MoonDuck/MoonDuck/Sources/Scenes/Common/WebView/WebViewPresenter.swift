//
//  WebViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

protocol WebPresenter: AnyObject {
    var view: WebView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
}

class WebViewPresenter: BaseViewPresenter, WebPresenter {
    weak var view: WebView?
    private let title: String
    private let url: String
    
    init(with provider: AppServices, title: String, url: String) {
        self.url = url
        self.title = title
        super.init(with: provider)
    }
}

extension WebViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateTitleLabelText(with: title)
        if let loadUrl = URL(string: url) {
            view?.loadWebView(with: loadUrl)
        }
    }
    
    // MARK: - Action
}
