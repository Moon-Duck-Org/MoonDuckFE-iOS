//
//  ImageManager.swift
//  MoonDuck
//
//  Created by suni on 2/20/25.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    func saveImages(images: [UIImage], reviewID: String, completion: @escaping (([String]) -> Void)) {
        guard !images.isEmpty else {
            Log.error("이미지가 비어 있음")
            completion([])
            return
        }
        
        let maxImages = 5
        let limitedImages = Array(images.prefix(maxImages)) // 최대 5개까지만 저장
        var savedPaths: [String] = Array(repeating: "", count: limitedImages.count)

        let dispatchGroup = DispatchGroup()

        for (index, image) in limitedImages.enumerated() {
            dispatchGroup.enter()
            saveImage(image: image, reviewID: reviewID, index: index) { path in
                if let path = path {
                    savedPaths[index] = path
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(savedPaths.filter { !$0.isEmpty }) // 빈 값 제거 후 반환
        }
    }

    func saveImage(image: UIImage, reviewID: String, index: Int, completion: @escaping ((String?) -> Void)) {
        guard (0...4).contains(index) else {
            Log.error("Invalid index: \(index). Must be between 0 and 4.")
            completion(nil)
            return
        }
        
        let imageName = "review_\(reviewID)_\(index).jpg"
        
        guard let data: Data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            completion(nil)
            return
        }
        
        if let directory = try? FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false) {
            let fileURL = directory.appendingPathComponent(imageName)
            
            do {
                try data.write(to: fileURL)
                completion(fileURL.path) // 저장 성공 시 경로 반환
            } catch let error as NSError {
                Log.error("Could not saveImage🥺: \(error), \(error.userInfo)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }

    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func deleteImage(named: String,
                     completion: @escaping ((Bool) -> Void)) {
        guard let directory =
                try? FileManager.default.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil,
                                             create: false) as NSURL
        else {
            completion(false)
            return
        }
        do {
            if let docuPath = directory.path {
                let fileNames = try
                FileManager.default.contentsOfDirectory(atPath: docuPath)
                for fileName in fileNames {
                    if fileName == named {
                        let filePathName = "\(docuPath)/\(fileName)"
                        try FileManager.default.removeItem(atPath: filePathName)
                        completion(true)
                        return
                    }
                }
            }
        } catch let error as NSError {
            print("Could not deleteImage🥺: \(error), \(error.userInfo)")
            completion(false)
        }
    }
}
