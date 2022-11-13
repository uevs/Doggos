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
    
    lazy var dogImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func configure() {
        dogImage.clipsToBounds = true
        dogImage.contentMode = .scaleAspectFill
        
        contentView.addSubview(dogImage)
        
        dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dogImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dogImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dogImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
}
