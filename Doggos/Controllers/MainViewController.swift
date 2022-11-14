//
//  MainViewController.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit

class MainViewController: UITableViewController {
    
    var data: DataManager
    
    
    init(data: DataManager) {
        self.data = data
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await data.setup { self.tableView.reloadData() }
        }
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Doggos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.circle.fill"), style: .plain, target: self, action: #selector(goToFavorites))
        tableView.register(DogCell.self, forCellReuseIdentifier: "DogCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.breedsNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as? DogCell else {
            fatalError("DogCell is not defined!")
        }
        
        let breed = Array(data.breedsNames.keys.sorted())[indexPath.row]
        cell.configure(breed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBreed = Array(data.breedsNames.keys.sorted())[indexPath.row]
        
        let detailsViewController = DetailsViewController(data: data, breed: currentBreed, subBreeds: data.breedsNames[currentBreed] ?? [])
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc func goToFavorites() {
        let detailsViewController = DetailsViewController(data: data, breed: "Favorites", subBreeds: [])
        
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}
