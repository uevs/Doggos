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

        dogImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
        dogImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true

    }
    
}
