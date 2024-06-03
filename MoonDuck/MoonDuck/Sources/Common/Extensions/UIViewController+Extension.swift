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
        let frameView = UIView().then({
            $0.backgroundColor = Asset.Color.black.color.withAlphaComponent(0.9)
            $0.alpha = 0.8
            $0.layer.cornerRadius = 6
        })
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor(asset: Asset.Color.white)
        toastLabel.font = FontFamily.NotoSansCJKKR.medium.font(size: 14)
        toastLabel.text = message
        
        view.addSubview(frameView)
        frameView.addSubview(toastLabel)
        frameView.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-7)
            $0.centerX.equalTo(view.snp.centerX)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(37)
        })
        toastLabel.snp.makeConstraints({
            $0.center.equalTo(frameView.snp.center)
        })
        UIView.animate(withDuration: 1.5,
                       delay: 1.5,
                       options: .curveEaseOut,
                       animations: {
            frameView.alpha = 0.0
        }, completion: { _ in
            frameView.removeFromSuperview()
        })
    }
}
