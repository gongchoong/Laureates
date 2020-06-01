//
//  LaureateCell.swift
//  NobelLaureates
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class LaureateCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var viewModel: LaureateCellViewModel? {
        didSet {
            guard let fullName = viewModel?.fullName, let year = viewModel?.year else {return}
            nameLabel.text = fullName
            yearLabel.text = "\(year)"
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(nameLabel)
        addSubview(yearLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: frame.size.height*0.25),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: centerYAnchor),
            yearLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            yearLabel.rightAnchor.constraint(equalTo: rightAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
