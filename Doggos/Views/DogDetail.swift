//
//  DogDetail.swift
//  Doggos
//
//  Created by leonardo on 10/11/22.
//

import Foundation
import UIKit

class DogDetailView: UICollectionView {
    
}

class DogDetailCell: UICollectionViewCell {
    
    var isFavorite: Bool = false
    
    lazy var dogImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var favoriteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.layer.opacity = isFavorite ? 1 : 0
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    func toggleFavorite() {
        isFavorite.toggle()
        favoriteIcon.layer.opacity = isFavorite ? 1 : 0
    }
    
    func configure(){
        favoriteIcon.clipsToBounds = true
        favoriteIcon.layer.zPosition = 1
        favoriteIcon.contentMode = .scaleAspectFit
        
        dogImage.clipsToBounds = true
        dogImage.contentMode = .scaleAspectFill

        contentView.addSubview(favoriteIcon)
        contentView.addSubview(dogImage)
        
        dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dogImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dogImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dogImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        favoriteIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        favoriteIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    
}
