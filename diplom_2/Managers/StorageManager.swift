//
//  StorageManager.swift
//  diplom_1
//
//  Created by Сергей Недведский on 8.01.25.
//

import Foundation
import UIKit

private extension String {
    static let images = "images"
    static let password = "password"
}

final class StorageManagaer {

    static let shared = StorageManagaer()

    private init() {

    }
    
    //MARK: -  Image Save
    
    func saveImage(image: Image){
        var images = loadImages()
        images.insert(image, at: 0)
        
        UserDefaults.standard.set(encodable: images, forKey: .images)
    }
    
    func saveChangedImages(images: [Image]){
        UserDefaults.standard.set(encodable: images, forKey: .images)
    }
    
    func savePassword(password: String){
        UserDefaults.standard.set(encodable: password, forKey: .password)
    }
    
    func loadPassword() -> String? {
//        UserDefaults.standard.removeObject(forKey: .password)
        let password = UserDefaults.standard.value(String.self, forKey: .password)
        return password ?? nil
    }
    
    func loadImages() -> [Image]{
        let images = UserDefaults.standard.value([Image].self, forKey: .images)
        return images ?? []
    }

    func savelmage(_ image: UIImage) -> String? {
        guard
            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first,
            let data = image.jpegData(compressionQuality: 1)
        else {
            return nil
        }
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
                //try? FileManager.default.removeItem(atPath: fileURL.path)
            }
        }

        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }

    }

    func loadImage(filename: String) -> UIImage? {
        guard
            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first
        else {
            return nil
        }
        let fileUrl = documentsDirectory.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileUrl.path)
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data)
        {
            return value
        }
        return nil
    }
}
