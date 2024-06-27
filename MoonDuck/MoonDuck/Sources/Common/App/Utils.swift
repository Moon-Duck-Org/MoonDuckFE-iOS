//
//  Utils.swift
//  MoonDuck
//
//  Created by suni on 6/25/24.
//

import Foundation
import UIKit
import SafariServices

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
}
