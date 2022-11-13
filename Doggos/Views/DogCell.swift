//
//  DogCell.swift
//  Doggos
//
//  Created by leonardo on 10/11/22.
//

import Foundation
import UIKit

class DogCell: UITableViewCell {
    
    lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func configure(_ data: String) {
        breedLabel.text = data.capitalized
        contentView.addSubview(breedLabel)

        breedLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        breedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        breedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
