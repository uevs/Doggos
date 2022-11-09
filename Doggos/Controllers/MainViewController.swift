//
//  MainViewController.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Doggos"
        
    }
    
    
}
