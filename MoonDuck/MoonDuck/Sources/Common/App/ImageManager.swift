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
            completion(savedPaths)
        }
    }

    func saveImage(image: UIImage, reviewID: String, index: Int, completion: @escaping ((String?) -> Void)) {
        guard (0...4).contains(index) else {
            Log.error("❌ Invalid index: \(index). Must be between 0 and 4.")
            completion(nil)
            return
        }
        
        let fileManager = FileManager.default
        let imageName = "review_\(reviewID)_\(index).jpg"
        
        guard let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            Log.error("❌ Document Directory를 찾을 수 없습니다.")
            completion(nil)
            return
        }
        
        let fileURL = directory.appendingPathComponent(imageName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) ?? image.pngData() else {
            Log.error("❌ 이미지 데이터를 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        do {
            // 기존 파일이 있을 경우 덮어씌움
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
                Log.info("🔄 기존 이미지 삭제 후 새 파일 저장: \(fileURL)")
            }
            
            try imageData.write(to: fileURL, options: .atomic)
            Log.info("✅ 이미지 저장 성공: \(fileURL.path)")
            completion(fileURL.path)
        } catch {
            Log.error("❌ 이미지 저장 실패: \(error.localizedDescription)")
            completion(nil)
        }
    }

    func downloadImage(path: String) -> UIImage? {
        let name = URL(fileURLWithPath: path).lastPathComponent
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path)
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
            Log.error("Could not deleteImage🥺: \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    func deleteImages(names: [String]) {
        let fileManager = FileManager.default
        
        guard let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            Log.error("❌ Document Directory를 찾을 수 없습니다.")
            return
        }
        
        for name in names {
            let fileURL = directory.appendingPathComponent(name)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    try fileManager.removeItem(at: fileURL)
                    Log.info("✅ 이미지 삭제 성공: \(name)")
                } catch {
                    Log.error("❌ 이미지 삭제 실패: \(name), 오류: \(error.localizedDescription)")
                }
            } else {
                Log.info("⚠️ 이미지 없음, 삭제 스킵: \(name)")
            }
        }
    }

}
