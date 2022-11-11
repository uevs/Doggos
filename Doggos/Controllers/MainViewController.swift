//
//  MainViewController.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit

class MainViewController: UITableViewController {
    
    let data = DataStore(dataGetter: DataGetter())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Doggos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.circle.fill"), style: .plain, target: self, action: #selector(goToFavorites))
        tableView.register(DogCell.self, forCellReuseIdentifier: "DogCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.breeds.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as? DogCell else {
            fatalError("DogCell is not defined!")
        }
        
        let breed = Array(data.breeds.keys.sorted())[indexPath.row]
        cell.configure(breed.capitalized)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBreed = Array(data.breeds.keys.sorted())[indexPath.row]
        
        let detailsViewController = DetailsViewController(breed: currentBreed.capitalized, images: [], subBreeds: data.breeds[currentBreed] ?? [])
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc func goToFavorites() {

    }
}
