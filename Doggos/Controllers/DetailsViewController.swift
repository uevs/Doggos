//
//  DetailsViewController.swift
//  Doggos
//
//  Created by leonardo on 10/11/22.
//

import Foundation
import UIKit

class DetailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var data: DataManager
    
    var breed: String
    var imagesURLs: [String] = []
    var subBreeds: [String]
    
    var layout: UICollectionViewFlowLayout
    
    init(data: DataManager, breed: String, subBreeds: [String]) {
        layout = UICollectionViewFlowLayout()
        self.data = data
        self.breed = breed
        self.subBreeds = subBreeds
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/DataManager.magnification, height: UIScreen.main.bounds.width/DataManager.magnification)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(DogDetailCell.self, forCellWithReuseIdentifier: "cell")
        
        let plus = UIBarButtonItem(image: UIImage(systemName: "plus.magnifyingglass"), style: .plain, target: self, action: #selector(zoomIn))
        let minus = UIBarButtonItem(image: UIImage(systemName: "minus.magnifyingglass"), style: .plain, target: self, action: #selector(zoomOut))

        navigationItem.rightBarButtonItems = [plus, minus]
        
        
        self.view = collectionView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alwaysBounceVertical = true
        self.title = breed.capitalized
        
        Task {
            await data.setupBreedView(breed: self.breed) {
                self.imagesURLs = self.data.breedImagesURL[self.breed]!
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> DogDetailCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogDetailCell
        
        let url = imagesURLs[indexPath.row]
        
        cell.configure()
        cell.dogImage.image = nil
        
        Task {
            do  {
                cell.dogImage.image = try await data.getImage(url: url, completion: {
                    collectionView.reloadData()
                })
            } catch {
                
            }

        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/DataManager.magnification, height: UIScreen.main.bounds.width/DataManager.magnification)
    }
    
    
    @objc func zoomIn() {
        if DataManager.magnification < 5 {
            DataManager.magnification += 1
            collectionView.reloadData()
        }

    }
    
    @objc func zoomOut() {
        if DataManager.magnification > 1 {
            DataManager.magnification -= 1
            collectionView.reloadData()
        }
        
    }
    
}



