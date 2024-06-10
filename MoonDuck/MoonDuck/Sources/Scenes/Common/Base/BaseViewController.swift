//
//  BaseViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol BaseView: AnyObject {
    func updateLoadingView(_ isLoading: Bool)
    func showToast(_ message: String)
}

class BaseViewController: UIViewController {
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.loadingView)
        NSLayoutConstraint.activate([
            self.loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
        
        self.loadingView.isLoading = false
    }
    
    func updateLoadingView(_ isLoading: Bool) {
        self.loadingView.isLoading = isLoading
    }
    
    func showToast(_ message: String) {
        showToast(message: message)
    }
}
