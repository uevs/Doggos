//
//  DetailsViewController.swift
//  Doggos
//
//  Created by leonardo on 10/11/22.
//

import Foundation
import UIKit

class DetailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var data: DataManager
    
    private var breed: String /// The current breed displayed in the view's instance
    private var imagesURLs: [String] = [] /// The URLs from which images will be fetched
    private var subBreeds: [String] /// SubBreeds, if any
    
    /// This view can also display as a "Favorites" viw if the breed name given to the init is "Favorites"
    private var isFavoritesView: Bool {
        return breed == "Favorites"
    }
    
    private var layout: UICollectionViewFlowLayout
    
    
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
        
        /// Cells can be zoomed in or out by the user
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
        self.collectionView.allowsMultipleSelection = true
        self.title = breed.capitalized
        
        /// If the view is used as a Favorites, it fetches the URLs of Favorites from the data class, otherwise it fetches the breed URLS  from the API.
        if isFavoritesView {
            self.imagesURLs = self.data.favorites
            self.collectionView.reloadData()
        } else {
            Task {
                await data.setupBreedView(breed: self.breed) {
                    self.imagesURLs = self.data.breedImagesURL[self.breed]!
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> DogDetailCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogDetailCell
        
        cell.dogImage.image = nil
        
        let url = imagesURLs[indexPath.row]
        cell.isFavorite = data.favorites.contains(url)
        cell.reset()
        cell.configure()
        
        /// Gets cell image from the internet/cache.
        Task {
            cell.dogImage.image = try await data.getImage(breed: breed, url: url) {
                collectionView.reloadData()
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
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data.toggleFavorite(url: imagesURLs[indexPath.row])
        let cell = collectionView.cellForItem(at: indexPath) as! DogDetailCell
        cell.toggleFavorite()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        data.toggleFavorite(url: imagesURLs[indexPath.row])
        let cell = collectionView.cellForItem(at: indexPath) as! DogDetailCell
        cell.toggleFavorite()
    }
    
    
    @objc func zoomIn() {
        if DataManager.magnification > 1 {
            DataManager.magnification -= 1
            collectionView.reloadData()
        }
    }
    
    
    @objc func zoomOut() {
        if DataManager.magnification < 5 {
            DataManager.magnification += 1
            collectionView.reloadData()
        }
    }
}



