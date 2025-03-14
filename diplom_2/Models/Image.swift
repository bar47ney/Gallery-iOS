//
//  Image.swift
//  diplom_1
//
//  Created by Сергей Недведский on 19.01.25.
//

import Foundation

final class Image: Codable {
    let imageSrc: String
    var imageName: String
    var isFavorite: Bool
    var createdDate: String
    
    init(imageName: String = "Image", imageSrc: String, isFavorite: Bool = false, createdDate: String = "Date") {
        self.imageName = imageName
        self.imageSrc = imageSrc
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
    
    func setImageName(imageName: String){
        self.imageName = imageName
    }
    
    func setCreatedDate(createdDate: String){
        self.createdDate = createdDate
    }
    
    func setIsFavorite(isFavorite: Bool){
        self.isFavorite = isFavorite
    }
    
    func getImageName() -> String{
        self.imageName
    }
}
