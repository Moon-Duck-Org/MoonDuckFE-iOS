//
//  UIViewController+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/26/24.
//

import UIKit
import SnapKit
import Then

extension UIViewController {
    func showToast(message: String) {
        DispatchQueue.main.async {
            let frameView = UIView().then({
                $0.backgroundColor = Asset.Color.black.color.withAlphaComponent(0.9)
                $0.alpha = 0.8
                $0.layer.cornerRadius = 6
            })
            let toastLabel = UILabel()
            toastLabel.textColor = UIColor(asset: Asset.Color.white)
            toastLabel.font = FontFamily.NotoSansCJKKR.medium.font(size: 14)
            toastLabel.text = message
            toastLabel.numberOfLines = 0
            toastLabel.textAlignment = .center
            
            self.view.addSubview(frameView)
            frameView.addSubview(toastLabel)
            frameView.snp.makeConstraints({
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-7)
                $0.centerX.equalTo(self.view.snp.centerX)
                $0.leading.equalTo(self.view.snp.leading).offset(16)
                $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            })
            toastLabel.snp.makeConstraints({
                $0.leading.trailing.bottom.top.equalToSuperview().inset(8)
            })
            
            UIView.animate(withDuration: 2.0,
                           delay: 0.5,
                           options: .curveEaseOut,
                           animations: {
                frameView.alpha = 0.0
            }, completion: { _ in
                frameView.removeFromSuperview()
            })
        }
    }
}
