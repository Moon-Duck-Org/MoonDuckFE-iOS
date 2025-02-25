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
    private let path: String
    
    init(with provider: AppStorages, title: String, path: String) {
        self.path = path
        self.title = title
        super.init(with: provider, model: AppModels())
    }
}

extension WebViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateTitleLabelText(with: title)
        let loadUrl = URL(fileURLWithPath: path)
        view?.loadWebView(with: loadUrl)
    }
    
    // MARK: - Action
}
