//
//  UIViewController+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/26/24.
//

import UIKit

extension UIViewController {
    func showToast(message: String) {
        DispatchQueue.main.async {
            let frameView = UIView()
            frameView.backgroundColor = Asset.Color.black.color.withAlphaComponent(0.9)
            frameView.alpha = 0.8
            frameView.layer.cornerRadius = 6
            frameView.translatesAutoresizingMaskIntoConstraints = false
            
            let toastLabel = UILabel()
            toastLabel.textColor = UIColor(asset: Asset.Color.white)
            toastLabel.font = FontFamily.NotoSansCJKKR.medium.font(size: 14)
            toastLabel.text = message
            toastLabel.numberOfLines = 0
            toastLabel.textAlignment = .center
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(frameView)
            frameView.addSubview(toastLabel)
            NSLayoutConstraint.activate([
                // frameView constraints
                frameView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -7),
                frameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                frameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                frameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                
                // toastLabel constraints
                toastLabel.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 8),
                toastLabel.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -8),
                toastLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 8),
                toastLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -8)
            ])
            
            UIView.animate(withDuration: 2.0,
                           delay: 1.5,
                           options: .curveEaseOut,
                           animations: {
                frameView.alpha = 0.0
            }, completion: { _ in
                frameView.removeFromSuperview()
            })
        }
    }
}
