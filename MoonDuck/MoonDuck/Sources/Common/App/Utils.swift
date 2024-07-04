//
//  Utils.swift
//  MoonDuck
//
//  Created by suni on 6/25/24.
//

import Foundation
import UIKit

import SafariServices
import Kingfisher

class Utils {
    static func formattedDate(createdAt date: String) -> String {
        let splitDate = date.split(separator: "T")
        if splitDate.count > 0 {
            let dateStr = String(splitDate[0]).split(separator: "-")
            if dateStr.count > 2 {
                let (year, month, day) = (dateStr[0], dateStr[1], dateStr[2])
                return "\(year)년 \(month)월 \(day)일"
            }
        }
        return date
    }
    
    static func openSafariViewController(urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        if url.scheme == "http" || url.scheme == "https" {
            let viewController = Navigator.default.root
            let safariViewController = SFSafariViewController(url: url)
            DispatchQueue.main.async {
                viewController.present(safariViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    static func downloadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        let downloader = KingfisherManager.shared.downloader

        downloader.downloadImage(with: url, options: nil) { result in
            switch result {
            case .success(let value):
                // 성공적으로 이미지를 다운로드한 경우 UIImage를 반환
                completion(value.image)
            case .failure(let error):
                // 에러 처리
                Log.error("Error downloading image: \(error)")
                completion(Asset.Assets.imageEmpty.image)
            }
        }
    }
    
    static func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
