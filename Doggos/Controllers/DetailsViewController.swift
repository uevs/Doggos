//
//  DetailsViewController.swift
//  Doggos
//
//  Created by leonardo on 10/11/22.
//

import Foundation
import UIKit

class DetailsViewController: UICollectionViewController {
    
    var breed: String
    var images: [String]
    var subBreeds: [String]
    
    var layout: UICollectionViewFlowLayout
    
    init(breed: String, images: [String], subBreeds: [String]) {
        layout = UICollectionViewFlowLayout()
        self.breed = breed
        self.images = images
        self.subBreeds = subBreeds
        super.init(collectionViewLayout: layout)
        
        print("this is a \(breed)")
        print("these are the images \(images)")
        print("these are the sub-breeds \(subBreeds)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view = collectionView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alwaysBounceVertical = true
        self.title = breed
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    
}



