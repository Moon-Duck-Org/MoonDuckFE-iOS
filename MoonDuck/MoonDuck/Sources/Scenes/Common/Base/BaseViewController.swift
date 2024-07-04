//
//  BaseViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol BaseView: AnyObject {
    var isEditingText: Bool { get set }
    
    func createTouchEvent()
    func updateLoadingView(isLoading: Bool)
    func showToastMessage(_ message: String)
    func endEditing()
}

class BaseViewController: UIViewController {
    lazy var throttler = Throttler(interval: 1.0)
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var isEditingText: Bool = false
        
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
    
    func updateLoadingView(isLoading: Bool) {
        self.loadingView.isLoading = isLoading
    }
    
    func showToastMessage(_ message: String) {
        showToast(message: message)
    }
    /**
     # createTouchEvent
     - Author: suni
     - Date: 24.06.14
     - Note: ViewController 터치로 키보드를 숨기는 이벤트를 생성하는 함수
     */
    func createTouchEvent() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc
    func endEditing() {
        if isEditingText {
            view.endEditing(true)
            isEditingText = false
        }
    }
}
