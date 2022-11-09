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
    }
    
    
    @objc func goToFavorites() {

    }
}
